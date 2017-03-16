---
title: "Faster RSpec Regression Testing"

description: Explore two approaches for testing along with a suggested workflow. The goal is to improve the time spent during regression testing. The described technique can apply to other testing frameworks, assuming they have similar mechanisms to RSpec's it blocks."

tags:
- rspec
- testing

notes:
-
  date: 2016-02-25
  type: add
  content: Mention of RSpec 3.3's support for `aggregate_failures` feature, which combines the best of both testing approaches.
---

## Testing Approaches
  1. *Immediately* on the code that is being developed to help guide development. Generally using a *subset* of the test suite.
  2. *Afterwards* on the complete codebase to ensure no regressions appear. This is always done using the *complete* test suite.

In an ideal environment, the complete test suite is run after every meaningful code change. This approach works for a small project, but it can grow into a time consuming process. Developers may only run a subset of tests that exercise the modified source code. Faster test execution allows for tighter feedback loops between testing and developing.

Eventually the active development stops as the feature is completed. A developer wants to have a high-level of confidence in the code that they wrote before committing the changes. By running the complete test suite, one can have a certain level of assurance that the code to be committed will not cause issues. Ideally this second phase of testing is carried out locally by the developer, but also on a continuous integration server to prevent regressions.

## RSpecing `it` up
RSpec tests are executed using the `it` method. The code within the `it` block is executed after applying context using `let` and `before`, which can be seen as the pre-amble of the test. In other words, for every `it` block the test will execute the required pre-amble before the actual `it` block.

### Many `it` blocks
During development it is useful to use the following technique to understand as much detail of failing tests:

```ruby
  # A trivial example to show the verification of
  # multiple conditions using many 'it' blocks
  RSpec.describe 'test with many it blocks' do
    it { expect('a'.upcase).to eq('A') }
    it { expect('c'.upcase).to eq('B') }
    it { expect('b'.upcase).to eq('C') }
  end
```

```
Failures:

  1) test with many it blocks should eq "B"
     Failure/Error: it { expect('b'.upcase).to eq('B') }

       expected: "B"
            got: "C"

  2) test with many it blocks should eq "C"
     Failure/Error: it { expect('b'.upcase).to eq('C') }

       expected: "C"
            got: "B"
```

The results of the testing present all of the failures. This approach is important during iterative development as fixing one test might cause others to fail.

### Combining `it` blocks
Another approach that can be used with RSpec is to combine the many `it` blocks into one:

```ruby
  # A trivial example to show the verification of
  # multiple conditions using a combined 'it' block
  RSpec.describe 'test with a combined it block' do
    it do
      expect('a'.upcase).to eq('A')
      expect('c'.upcase).to eq('B')
      expect('b'.upcase).to eq('C')
    end
  end
```

```
Failures:

  1) test with a combined it block should eq "B"
     Failure/Error: expect('c'.upcase).to eq('B')

       expected: "B"
            got: "C"
```

This time the results present *only the first* failure, even though two assertions are incorrect. This approach provides less information than the first example. Although there is a different benefit, it runs less examples (tests and their complete pre-amble). This approach leads to quicker test executions, with the loss of the complete listing of failures. Arguably this approach is better suited when a feature is complete and the tests remain present to detect regressions.

## Performance Impact
In the previous section, two styles of using RSpec's `it` blocks were illustrated. The next example showcases both approaches to understand how the testing performance changes. To simulate some pre-amble (i.e., database interactions, setting up objects) sleeps are used when accessing the values from their `let` blocks.

```ruby
require 'rspec'

class AttributeObject
  attr_reader :value1, :value2, :value3, :value4

  def initialize(value1, value2, value3, value4)
    @value1 = value1
    @value2 = value2
    @value3 = value3
    @value4 = value4
  end
end

RSpec.describe 'performance using `it` blocks' do
  subject { AttributeObject.new(value1, value2, value3, value4) }

  let(:value1) { sleep 0.1; 1 }
  let(:value2) { sleep 0.1; 2 }
  let(:value3) { sleep 0.1; 3 }
  let(:value4) { sleep 0.1; 4 }

  context 'slow tests due to many `it` blocks' do
    it { expect(subject.value1).to eq(value1) }
    it { expect(subject.value2).to eq(value2) }
    it { expect(subject.value3).to eq(value3) }
    it { expect(subject.value4).to eq(value4) }
  end

  context 'faster tests due to a combined `it` block' do
    it do
      expect(subject.value1).to eq(value1)
      expect(subject.value2).to eq(value2)
      expect(subject.value3).to eq(value3)
      expect(subject.value4).to eq(value4)
    end
  end
end
```

For this example it is possible to use both testing approaches. There are two criteria that must be satisfied to allow this transformation. For each `it` block:

  * The **pre-amble is the same**. In the example they are all instantiating the `AttributeObject` with the four value arguments.
  * The **contents are not mutating the environment in a different way from each other**. If an `it` block mutates the environment then the many `it` block approach might have unexpected results. In the example each `it` block contains only a single assertion.

```
# Many 'it' blocks
Finished in 1.67 seconds (files took 0.09327 seconds to load)
4 examples, 0 failures

# Combined 'it' block
Finished in 0.41675 seconds (files took 0.09545 seconds to load)
1 example, 0 failures
```

It is clear to see that the combined `it` block executes less examples and therefore requires less time. Both of these approaches are testing the *exact same thing*, however one does so more quickly than the other. There is still the loss of the precise failure reporting per `it` block. It can be argued that it is not a huge loss given the code under test has been developed and the tests are for regressions.

### Larger Scale Test Suite
To better illustrate the benefits of using combined `it` blocks when possible, I have applied this technique to a larger project. The conversion between the two approaches was straight-forward and the results are satisfying. It was possible to consolidated many `it` blocks (300 less test examples), reducing the run time by 38%.

```
# Before
Finished in 3 minutes 6.3 seconds (files took 10.06 seconds to load)
1506 examples, 0 failures

# After
Finished in 1 minute 55.27 seconds (files took 10.11 seconds to load)
1206 examples, 0 failures
```

The results are going to differ between projects and testing styles, although in most cases there will be some performance improvements.

## Suggested Testing Workflow
The following workflow is the one I follow as it provides the best of both worlds:

1. Iteratively develop feature using many `it` blocks for feedback locally
2. Complete feature
3. Convert many `it` blocks into a combined `it` block for regressions
4. Merge feature into master

Eventually some issue may come up and a regression might be found. If more work is involved to fix and understand the issue at hand I might split the combined `it` block to provide more feedback on failures. At this point I would go back to following the workflow from the start.

### Best of Both Worlds with RSpec 3.3 `aggregate_failures`
With [RSpec 3.3](http://rspec.info/blog/2015/06/rspec-3-3-has-been-released/) a new feature `aggregate_failures` was introduced. This feature is specific to RSpec, and offers the best of both worlds with respect to the testing disscused earlier (many `it` blocks vs. single `it` block).

In summary it is possible to wrap the asserts within a combined `it` block with `agregate_failiures`. This allows all the assertions to execute with a single setup similar to the combined `it` block approach, yet any failed asserts are individually reported should they occur similar to the many `it` block approach.

The following is a code snippet from the [RSpec 3.3](http://rspec.info/blog/2015/06/rspec-3-3-has-been-released/) release notes where additional ways of usage are described.

```ruby
RSpec.describe Client do
  it "returns a successful JSON response" do
    response = Client.make_request

    aggregate_failures "testing response" do
      expect(response.status).to eq(200)
      expect(response.headers).to include("Content-Type" => "application/json")
      expect(response.body).to eq('{"message":"Success"}')
    end
  end
end
```
