---
title: "Sidekiq: Contained Callbacks"

description: "ActiveJob in Rails provides nice benefits. The background queueing gem Sidekiq allows for tailored options that you cannot use with ActiveJob. This post looks at a project's transition from ActiveJob to Sidekiq, and how to fill the missing functionality of ActiveJob Callbacks. By the end, we come up with a way to contain the callback logic to their own modules without modifying the concrete jobs."

tags:
- ruby
- rails
- sidekiq
---

# ActiveSupport Callbacks
In my [last post](/lets-pry-into-ruby-objects/) I touched on `pry` and how it helped me verify that my class had `around_perform` ActiveSupport Callbacks attached to it. In this post I will delve further into _what_ I was trying to accomplish.

# [ActiveJob, Sidekiq] - [ActiveJob]
I was working on a Rails 4.2.x project that had background job processing. We used [ActiveJob](https://github.com/rails/rails/tree/4-2-stable/activejob) as our adapter to our background jobs. Behind the scenes, we were using the [Sidekiq](http://sidekiq.org/) gem.

We eventually needed specifics that only native Sidekiq can provide through its `sidekiq_options`. These options that Sidekiq provides were something that we didn't need initially. As mentioned in the [Sidekiq Wiki](https://github.com/mperham/sidekiq/wiki/Active-Job#active-job-introductio://github.com/mperham/sidekiq/wiki/Active-Job#active-job-introduction):

> Note that more advanced Sidekiq features (`sidekiq_options`) cannot be controlled or configured via ActiveJob, e.g. saving backtraces.

The time has come to take advantage of powerful sidekiq gems and options, thus we have to switch from ActiveJob to native Sidekiq.

# ActiveJob's Free Perks
ActiveJob provided certain features automatically such as using [GlobalID](http://guides.rubyonrails.org/active_job_basics.html#globalid) and setting up [Callbacks](http://guides.rubyonrails.org/active_job_basics.html#callbacks), amongst others. With a native Sidekiq approach we lose those _free_ perks.

The biggest thing we missed was the callbacks, specifically `around_perform`. We had several modules that were mixed in to our job classes, with the single responsibility of augmenting the class with callbacks.

For example:

```ruby
module JobMetrics
  extend ActiveSupport::Concern

  included do
    around_perform do |_job, block|
      MetricsLogger.timing(metrics_logger_key) { block.call }
    end

    def metrics_logger_key
      @metrics_logger_key ||= signature.underscore.tr("/", ".")
    end
  end
end
```

This module is wrapping the actual job's `#perform` in a `MetricsLogger.timing`. In a future post, I might go into further details about `MetricsLogger`, but at its core it records a key/value and sends it off to a log aggregator. The benefit we get from this module is the ability to know timing metrics for jobs based on an identifying signature.

Moving away from ActiveJob, we need another way to accomplish the same thing (_contained callbacks_) with just Sidekiq.

# Contained Callbacks
The goal is to have contained callbacks, which is just a separate module that can be included on jobs that define the required callback. This approach means that little has to change while removing ActiveJob, and we can reuse all our existing contained callbacks.

## Prepend a Proxy
I found out that to make use of `ActiveSupport::Callbacks` you have to modify the executed method, which in our case would be the job's `#perform`.

```ruby
...
  def perform
    run_callbacks :perform do
      # Actual perform's content here
    end
  end
...

```

I didn't want to modify the `#perform` method definitions for all the jobs. So I came up with the solution of using `prepend` to slot a proxy in front of the jobs' `#perform`.

```ruby
module SidekiqCallbacks
  extend ActiveSupport::Concern

  def perform(*args)
    run_callbacks :perform do
      super(*args)
    end
  end
end
```

This module then can be prepended into the Sidekiq job classes and the callbacks will be executed -- if they are present. The next task is to support the `around_perform` callback.

## Support Setting and Running Callbacks
```ruby
require "active_support/callbacks"

# Following approach used by ActiveJob
# https://github.com/rails/rails/blob/93c9534c9871d4adad4bc33b5edc355672b59c61/activejob/lib/active_job/callbacks.rb
module SidekiqCallbacks
  extend ActiveSupport::Concern

  def perform(*args)
    if respond_to?(:run_callbacks)
      run_callbacks :perform do
        super(*args)
      end
    else
      super(*args)
    end
  end

  module ClassMethods
    def around_perform(*filters, &blk)
      set_callback(:perform, :around, *filters, &blk)
    end
  end
end
```

Now `SidekiqCallbacks` defines the ability to add callbacks, and they will be executed before `#perform` if defined.

## Wrapping it up

The last thing I want to do is to encapsulate this Sidekiq callback logic in its own module that defines the actual callback (i.e., `JobMetrics`). To do this, we need to further modify `SidekiqCallbacks`.

```ruby
require "active_support/callbacks"

# Following approach used by ActiveJob
# https://github.com/rails/rails/blob/93c9534c9871d4adad4bc33b5edc355672b59c61/activejob/lib/active_job/callbacks.rb
module SidekiqCallbacks
  extend ActiveSupport::Concern

  def self.prepended(base)
    base.include(ActiveSupport::Callbacks)

    # Check to see if we already have any callbacks for :perform
    # Prevents overwriting callbacks if we already included this module (and defined callbacks)
    base.define_callbacks :perform unless base.respond_to?(:_perform_callbacks) && base._perform_callbacks.present?

    class << base
      prepend ClassMethods
    end
  end

  def perform(*args)
    if respond_to?(:run_callbacks)
      run_callbacks :perform do
        super(*args)
      end
    else
      super(*args)
    end
  end

  module ClassMethods
    def around_perform(*filters, &blk)
      set_callback(:perform, :around, *filters, &blk)
    end
  end
end
```

We had to include the `self.prepended` so that the job class will have access to the defined methods through the contained callback module. The main thing to note here is that we are including `ActiveSupport::Callbacks` on the base object that is prepending this module. We also have to ensure that the callbacks are only defined once (this is where in my [last post](/lets-pry-into-ruby-objects/) I was using `pry` figure why not all my callbacks were defined).

```ruby
module JobMetrics
  extend ActiveSupport::Concern

  included do
    prepend SidekiqCallbacks

    around_perform do |_job, block|
      MetricsLogger.timing(metrics_logger_key) { block.call }
    end

    def metrics_logger_key
      @metrics_logger_key ||= signature.underscore.tr("/", ".")
    end
  end
end
```

Finally, we can see how `JobMetrics` has a new `prepend SidekiqCallbacks` and that pulls in all the required `ActiveSupport::Callback` logic that allows for callbacks to be defined and executed.

# The Win
With this approach, the benefit is that the callback implementation is completely contained within the `JobMetrics` module. The `SidekiqCallbacks` module provides the missing ActiveJob callback support for `around_perform`. It is also possible to add the missing ActiveJob callbacks using this approach.

In the ending, the concrete job classes just `include` the contained callback module (i.e., `JobMetrics`). `SidekiqCallbacks` is designed to accommodate multiple contained callback modules being included on a single concrete job class.
