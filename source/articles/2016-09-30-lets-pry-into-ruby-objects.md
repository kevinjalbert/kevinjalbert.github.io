---
title: "Let's pry into Ruby Objects"

description: "When you are knee deep in Ruby and dealing with objects that you never created it's sometimes a little daunting to trace everything back and figure it all out. Luckly there are a couple techniques in Ruby that can aid you. In particular, pry is an extreamly powerful tool that you should have in your toolbox."

tags:
- pry
- ruby
- rails
---

## Where is my `pry`bar?
You are probably already familiar with `irb`, an _interactive Ruby_ shell. It is pretty powerful and can help you poke around Ruby. In Rails, you might have had access to `byebug` and used it for debugging purposes. This is great and is standard with Rails projects. I do, however, recommend looking at `pry`, which is just a bit more powerful in what it can do. We're just going to scratch the surface here.

```
gem install pry
```

The `pry` [wiki](https://github.com/pry/pry/wiki) is quite detailed with a lot of accompanying resources.

## Adventure Time! Using `pry` to Open Objects
We'll use a shortened example that I recently encountered. I was pretty deep in Rails and was dealing with `ActiveSupport::Callbacks::CallbackChain` (lets not ask why ;P). I wanted to verify if we have any `around_perform` _callbacks_ set on a particular class. With my trusty `pry`, I can inspect what I'm working with in more detail.

```
pry(main)> RandomClass_perform_callbacks
=> #<ActiveSupport::Callbacks::CallbackChain:0x007fdcdddb5b20 @callbacks=nil, @chain=[], @config={:scope=>[:kind]}, @mutex=#<Thread::Mutex:0x007fdcdddb53c8>, @name=:perform>
```

At this point we have `ActiveSupport::Callbacks` included in our `RandomClass`. We also have an empty callback chain.

I eventually included in a module `MagicCallbacks` which defines our `around_perform` upon being included. If we were to re-inspect the class, we would see that we have a callback present.

```
pry(main)> RandomClass.include(MagicCallbacks)
=> RandomClass

pry(main)> RandomClass._perform_callbacks
=> #<ActiveSupport::Callbacks::CallbackChain:0x007fdce2a22b70
 @callbacks=nil,
 @chain=
  [#<ActiveSupport::Callbacks::Callback:0x007fdce2a22cd8
    @chain_config={:scope=>[:kind]},
    @filter=#<Proc:0x007fdce2a22eb8@/Users/jalbert/Projects/example-rails/app/models/concerns/magic_callbacks.rb:7>,
    @if=[],
    @key=70293335906140,
    @kind=:around,
    @name=:perform,
    @unless=[]>],
 @config={:scope=>[:kind]},
 @mutex=#<Thread::Mutex:0x007fdce2a22b20>,
 @name=:perform>
```

We can now see that we have a callback within the `@chain` array! Back to the problem at hand, I was interested in programmatically determining if the class had any callbacks defined.

As I was working with an unfamiliar object, I reached for my trusty `pry`. I can use `ls` on _any_ object and see a listing of methods and where they come from.

```
pry(main)> ls RandomClass._perform_callbacks
Enumerable#methods:
  all?     chunk        collect_concat  detect      each_cons   each_with_index   exclude?  find_index  grep      include?  lazy   max      min     minmax_by  partition  reverse_each  slice_before  sort_by  take_while  to_json                                 to_set
  any?     chunk_while  count           drop        each_entry  each_with_object  find      first       grep_v    index_by  many?  max_by   min_by  none?      reduce     select        slice_when    sum      to_a        to_json_with_active_support_encoder     zip
  as_json  collect      cycle           drop_while  each_slice  entries           find_all  flat_map    group_by  inject    map    member?  minmax  one?       reject     slice_after   sort          take     to_h        to_json_without_active_support_encoder
ActiveSupport::Callbacks::CallbackChain#methods: append  clear  compile  config  delete  each  empty?  index  insert  name  prepend
instance variables: @callbacks  @chain  @config  @mutex  @name
```

There is a lot of information here, but the key points to take away are:

* Classes/Module/Variables headers are shown in the order of `#ancestors`.
  * Sent messages travel up from the bottom to the top until something can `#respond_to?` it
* Method and variable names are listed under their owner.
  * This can quickly help you identify methods of interest.
* If a method is redefined in a lower level, it is only shown on the lowest level.
  * For example, a parent class and child class define same method.

You can also modify the `ls` commnd with modifiers which you can learn more with `ls -h`.

So we can see here that we have an `#empty?` defined under `ActiveSupport::Callbacks::CallbackChain#methods`. This sounds great, and my first thoughts is I can use `#empty?`. My only concern is what it's _actually_ checking. Again, `pry` to the rescue with `show-source`.

```
pry(main)> show-source ActiveSupport::Callbacks::CallbackChain#empty?

From: /Users/jalbert/.rvm/gems/ruby-2.3.0/gems/activesupport-4.2.7.1/lib/active_support/callbacks.rb @ line 529:
Owner: ActiveSupport::Callbacks::CallbackChain
Visibility: public
Number of lines: 1

def empty?;       @chain.empty?; end
```

So we can see the implementation of `#empty?` is a one-liner, where it's just calling `@chain.empty?`. Sounds legit, but let's go further to verify this.

```
pry(main)> show-source ActiveSupport::Callbacks::CallbackChain

From: /Users/jalbert/.rvm/gems/ruby-2.3.0/gems/activesupport-4.2.7.1/lib/active_support/callbacks.rb @ line 512:
Class name: ActiveSupport::Callbacks::CallbackChain
Number of lines: 80

class CallbackChain #:nodoc:#
  include Enumerable

  attr_reader :name, :config

  def initialize(name, config)
    @name = name
    @config = {
      :scope => [ :kind ]
    }.merge!(config)
    @chain = []
    @callbacks = nil
    @mutex = Mutex.new
  end
  ...
  def append(*callbacks)
    callbacks.each { |c| append_one(c) }
  end
  ...
  def append_one(callback)
    @callbacks = nil
    remove_duplicates(callback)
    @chain.push(callback)
  end
end
```

Yep! Just what I wanted to see. `@chain` is just an array to which all the callbacks are appended. So now we can do our check for any callbacks on our class by using `!RandomClass._perform_callbacks.empty?`.

```
pry(main)> RandomClass._perform_callbacks.empty?
=> false
```

A colleague of mine suggested the use of `#present?` instead a negative conditional with `#empty?`. This is a fair point -- I personally like to avoid negatives in my conditionals. Again, I want to verify it all works as expected with this change.

```
pry(main)> show-source ActiveSupport::Callbacks::CallbackChain#present?

From: /Users/jalbert/.rvm/gems/ruby-2.3.0/gems/activesupport-4.2.7.1/lib/active_support/core_ext/object/blank.rb @ line 23:
Owner: Object
Visibility: public
Number of lines: 3

def present?
  !blank?
end
```

I can see that `#present?` calls `!blank?`. Now let's now follow `#blank?`.

```
pry(main)> show-source ActiveSupport::Callbacks::CallbackChain#blank?

From: /Users/jalbert/.rvm/gems/ruby-2.3.0/gems/activesupport-4.2.7.1/lib/active_support/core_ext/object/blank.rb @ line 16:
Owner: Object
Visibility: public
Number of lines: 3

def blank?
  respond_to?(:empty?) ? !!empty? : !self
end
```

Yep! That works like I suspected it would -- that method chain winds up calling `ActiveSupport::Callbacks::CallbackChain#empty?` in the ending.

# Wrapping up

So if you are not using `pry`, I highly recommend it. I _barely_ scratched the surface on what it can do for you. It is a powerful tool that can help in debugging and further digging around your codebase.
