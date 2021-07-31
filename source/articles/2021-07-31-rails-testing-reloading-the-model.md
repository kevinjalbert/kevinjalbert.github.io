---
title: "Rails Testing: Reload the Model"

description: "A beginner in Rails might find themselves testing a model and not seeing the attributes reflecting the changes they would expect to see. Read about why this problem happens and how you can resolve it by reloading the model."

tags:
- rails
- testing

pull_image: "/images/2021-07-31-rails-testing-reloading-the-model/reload-stapler.jpg"
pull_image_attribution: 'Photo of my stapler'
---

Throughout my time using Rails, I've had the pleasure of working with people who are new to Ruby on Rails. This post is a quick one that outlines a testing issue that comes up every now and then.

To keep things short, let's jump right into the code!

## The Setup

```ruby
class Task < ApplicationRecord;
  # Has a bolean database column`archive`
end

class ArchiverService
  def self.call
    Task.update_all(archive: true)
  end
end
```

We have an ActiveRecord model and a service class that updates a value on the model. This is very much a contrived example to illustrate the problem.

```ruby
require "test_helper"

class ArchiverServiceTest < ActiveSupport::TestCase
  test "archives task" do
    task = Task.create(archive: false)

    ArchiverService.call

    assert(task.archive) # fails!
  end
end
```

This test fails.

## Reloading a Stale Model

The problem here is that the `task` object in the test isn't the same as the one being updated in the `ArchiverService`. When a model is instantiated, its attributes are cached. If a value is updated and persisted in the database, the changes aren't propagated to other instances of that model.

**The solution here is to add in a `task.reload` after the `ArchiverService.call`, as we want the task's values to be _refreshed_ with what the database has at that point**. If you want to read more into the `#reload` method, you can look at its [docs and source](https://github.com/rails/rails/blob/v6.1.4/activerecord/lib/active_record/persistence.rb#L752-L814). It's worth noting that the documentation states the following:

> Reloads the record from the database.
>
>...
>
> Reloading is commonly used in test suites to test something is actually written to the database, or when some action modifies the corresponding row in the database but not the object in memory

So be aware of this situation and recall that you do have access to `#reload` if you need to freshen up your model's attributes from the database. Rails even provide the ability to `#reload_association` if your model has them ([see docs here](https://guides.rubyonrails.org/v6.1.4/association_basics.html#methods-added-by-belongs-to-association)).
