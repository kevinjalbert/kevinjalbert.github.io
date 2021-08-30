---
title: "Stub Sleeps in Tests"

description: "A quick tip - when working with a code base that has sleep/delays in it, where you want to stub them out."

tags:
- testing
- ruby

pull_image: "/images/2021-08-29-stub-sleeps-in-tests/hammer-clock.jpg"
pull_image_attribution: '[Book,Clock and Hammer](https://flickr.com/photos/91261194@N06/45404836131 "Book,Clock and Hammer") by [focusonmore.com](https://flickr.com/people/91261194@N06) is licensed under [CC BY](https://creativecommons.org/licenses/by/2.0/)'
---

I'm doing another short post here on testing code. I've observed that sometimes sleeps/delays find their way into production. A quick example of this would be for a retry loop (e.g., HTTP requests). When testing the code concerning these areas, you are taking on the duration of the sleep in your test suite which is slow and undesirable.

To combat the added delay in sleeps during tests, my recommendation is to stub/mock out the sleep method. Depending on the language, there are many ways to handle this. With Ruby using [Minitest](https://github.com/seattlerb/minitest) and [Mocha](https://github.com/freerange/mocha), you would do the following:

```ruby
# Class that sleeps for five 1 second iterations, building an array of [0..4]
class SleepyObject
  def self.do_work
    results = []

    5.times do |index|
      results << index
      sleep(1)
    end

    results
  end
end

# Minitest and Mocha are needed for testing/stubbing
require 'minitest/autorun'
require 'mocha'
require 'mocha/minitest'

# Test class
class SleepyObjectTest < Minitest::Test

  # Takes 5 seconds to run
  def test_with_sleeps
    assert(0..4, SleepyObject.do_work)
  end

  # Takes pretty much 0 seconds to run
  # We are also asserting that five calls to `sleep` do happen
  def test_without_sleeps
    SleepyObject.expects(:sleep).times(5)
    assert(0..4, SleepyObject.do_work)
  end
end
```

When we run the above code, we see the following:

```
Run options: -v --seed 14433

# Running:

SleepyObjectTest#test_with_sleeps = 5.02 s = .
SleepyObjectTest#test_without_sleeps = 0.00 s = .

Finished in 5.018095s, 0.3986 runs/s, 0.5978 assertions/s.

2 runs, 3 assertions, 0 failures, 0 errors, 0 skips
```

The tests using stubs execute quickly, and we still retain the ability to _assert_ that _sleeps_ are happening. This is a _win-win_ in my books.

It can be a bit difficult to _figure out_ what tests in your test suite that is affected by sleep durations. As the test creator, you'll likely have a good idea of any sleep/delays in your test execution as you run them in isolation during development. I did find the following [article](https://dev.to/joeyschoblaska/make-your-specs-faster-with-sleep-study-1ff) that presents a novel approach to identify which tests have sleeps in their execution path.
