---
title: "No Excuses: Verifying RSpec Test Doubles"

description: "RSpec 3.0 introduces new verifying doubles that offer the ability to verify received messages against the underlying class/object. Learn how using verifying doubles offer more robust tests with little effort."

tags:
- ruby
- rspec
- testing

notes:
-
  date: 2016-01-23
  type: add
  content: Mention of RSpec 3.2's support for dynamic column methods defined by ActiveRecord in the context of `instance_double`.
---

Tests which utilize external services or interact with the database are typically the culprits of long-running tests. We want to keep our tests quick. It is possible to mock/stub out long running database and/or external services calls. This reduces the time a test suite takes to execute.

## Unsheathe the Double

In Ruby, one approach to mocking is by completely replacing the object of interest with a lightweight [double](http://www.rubydoc.info/gems/rspec-mocks/frames#Test_Doubles) using [RSpec](http://rspec.info/). Proper usage of a *double* can prevent tests from interacting with external services, such as a database (i.e., `ActiveRecord`).

With respect to RSpec, a *double* is created by providing a classname or object, along with a hash of messages and their responses. A *double* can only respond using the provided responses to their defined messages (technically there are other messages that a *double* can respond to, but for our purpose we do not have to worry about them).

```ruby
dog = double('Dog', talk: 'Woof')
dog.talk  #=> "Woof"
dog.walk  #=> Double "Dog" received unexpected message :walk with (no args)
```

In the above example, a `'Dog'` *double* is created that only knows `#talk`. When it receives an unknown message like `#walk` an appropriate exception is raised.

## Double-Edge Double
A *double* aims to abstract away from the concrete concepts that they are *standing in for* (i.e., defined classes/methods/attributes/associations and their implementations). This can simplify tests by only dealing with the immediate concerns in a restricted scope. Using *doubles* has its perks, but a problem can arise if changes occur to the underlying concrete concepts.

Lets examine the following scenario:

> We have an existing class with multiple defined methods. This class and its methods primarily interact with external services. This class and its methods are used within our test suite, in where we have mocked it out using a *double*.
>
>We decided to modify a method definition on the described class. Our tests continue to pass.

Given this scenario we would hope that by modifying the method definition that our existing tests which depend on said method definition to fail. Our tests are using a *double* in which the method definition it has defined is still valid, even when the actual method definition has been altered.

The consequences of not seeing any failing tests can be serious. Even with minor cosmetic changes, that do not alter functionality, it is still a misleading test. Identifying these tests after the fact can be challenging, as they initially appear to be in fine working order.

It is important to always remember to check the usage of *doubles* whose underlying concepts are changed. A gem called [rspec-fire](https://github.com/xaviershay/rspec-fire) was created to alleviate this task. This gem would verify that a *double* is actually mocking an actual method defined on the concrete object. As of [RSpec 3.0](http://rspec.info/blog/2014/05/notable-changes-in-rspec-3), *rspec-fire* is now obsolete as RSpec has a set of new [verifying doubles](https://relishapp.com/rspec/rspec-mocks/v/3-0/docs/verifying-doubles). With the release of [RSpec 3.2](http://rspec.info/blog/2015/02/rspec-3-2-has-been-released), `instance_double` now support dynamic column methods defined by ActiveRecord.

## Dance of the Double

A simple example best illustrates the downside of using the original RSpec *doubles*. In this example we also show how to replace the *double* with the new and improved verifying *doubles*, along with their benefits.

For this example we are not dealing with a database, although the idea is easily extendable. We can imagine that our test is creating actual entries in the database, thus incurring the performance hit.

-----

First we define an `Owner` that has a `Dog`. The `Dog` responds to `#talk`. In addition we have a corresponding test that uses a *double* to mock out the `Dog` which responds to `#talk`.

```ruby
class Owner
  attr_reader :dog

  def initialize(dog)
    @dog = dog
  end
end

class Dog
  def talk
    'Woof'
  end
end

RSpec.describe Owner do
  subject { Owner.new(dog) }
  let(:dog) { double('Dog', talk: 'Fake Woof') }
  it { expect(subject.dog.talk).to eq('Fake Woof') }
end

# 1 example, 0 failures
```

-----

We decide to change `Dog#talk` to `Dog#bark`, but forget to update the test.

```ruby
class Owner
  attr_reader :dog

  def initialize(dog)
    @dog = dog
  end
end

class Dog
  def bark
    'Woof'
  end
end

RSpec.describe Owner do
  subject { Owner.new(dog) }
  let(:dog) { double('Dog', talk: 'Fake Woof') }
  it { expect(subject.dog.talk).to eq('Fake Woof') }
end

# 1 example, 0 failures
```

From our test's perspective everything is still fine, since our *double* still responds to `#talk`. Ideally we would want our test here to fail since it is not accurately matching the interface defined by an actual `Dog` instance.

This is a problem. It is possible to completely *forget* about fixing the test, since it technically passed.

-----

This time we use a verifying *double* that RSpec provides such as an `instance_double`. This ensures that the messages the *double* receives are verified against the interface defined by the concrete object.

```ruby
require 'rspec'

class Owner
  attr_reader :dog

  def initialize(dog)
    @dog = dog
  end
end

class Dog
  def bark
    'Woof'
  end
end

RSpec.describe Owner do
  subject { Owner.new(dog) }
  let(:dog) { instance_double('Dog', talk: 'Fake Woof') }
  it { expect(subject.dog.talk).to eq('Fake Woof') }
end

# Failure/Error: let(:dog) { instance_double('Dog', talk: 'Fake Woof') }
#   Dog does not implement: talk
# 1 example, 1 failure
```

Now we have a failing test! This is what we expect to happen as our *double* is attempting to using an unimplemented method. This feedback allows us to take the corrective action on our tests to ensure that they are not forgotten and invalid.

-----

We now decide to change the number of arguments on `Dog#bark`. Again with the old non-verifying *double* our test would again simply pass. The verifying *doubles* also check that the number of arguments match the defined interface's number of arguments.

```ruby
require 'rspec'

class Owner
  attr_reader :dog

  def initialize(dog)
    @dog = dog
  end
end

class Dog
  def talk(loud)
    loud ? 'Woof' : 'Woof!!'
  end
end

RSpec.describe Owner do
  subject { Owner.new(dog) }
  let(:dog) { instance_double('Dog', talk: 'Fake Woof') }
  it { expect(subject.dog.talk).to eq('Fake Woof') }
end

# Failure/Error: let(:dog) { instance_double('Dog', talk: 'Fake Woof') }
#   Wrong number of arguments. Expected 1, got 0.
# 1 example, 1 failure
```

## Double Development

If the underlying class is loaded `instance_double` will do the verifying on the class. In the situation where the class is not loaded than it acts as a normal *double*.

During development an `instance_double` allows one to develop in isolation if the class you are mocking out does not yet exist. Eventually when the test is more-or-less complete, it is possible to simply *load* the class and the `instance_double` will start to verify on the loaded class.

In addition, during development you can use [`rubocop-rspec`](https://github.com/nevir/rubocop-rspec/blob/master/lib/rubocop/cop/rspec/verified_doubles.rb) to ensure you always verify your *doubles*.

## Concluding Double

**TL;DR -- There are no excuses, verify your RSpec test doubles.**

Verifying your RSpec test *doubles* can, and will, save you from many headaches down the road. In most cases the change required to use verifying *doubles* is relatively easy. The benefits are clear, worthwhile and your test suite will thank you.
