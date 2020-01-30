---
title: "Testing the Use of Rails Caching"

description: "There is a strong test culture for Rubyist using Rails. Caching can be rewarding in performance, yet can introduce cache complexities. Read about how I approach testing low-level caching."

tags:
- rails
- testing

pull_image: "/images/2020-01-30-testing-the-use-of-rails-caching/post-office-boxes.jpg"
pull_image_attribution: '[59/365 - 11/25/09](https://flickr.com/photos/vpickering/4134811904 "59/365 - 11/25/09") by [vpickering](https://flickr.com/people/vpickering) is licensed under [CC BY-NC-ND](https://creativecommons.org/licenses/by-nc-nd/2.0/)'
---

I was doing some performance work within a Rails application where expensive (computationally) data was being generated on each request. It was quick to implement the low-level caching that wrapped the expensive data generation. In this particular case, I wanted to ensure that the caching logic was valid as there were numerous conditions at play. I normally wouldn't test caching if the cache key was something trivial (or automatic like using `ActiveRecord#cache_key`).

> There are only two hard things in Computer Science: cache invalidation and naming things.
>
> -- Phil Karlton ([source](https://martinfowler.com/bliki/TwoHardThings.html))

# Peering into the Cache

This Rails application had the `cache_store` set to `:memory_store` in the test environment. We wanted to make sure that our tests were still going through the same code paths as would happen in production.

```ruby
# config/environments/test.rb:
Rails.application.configure do
  config.cache_store = :memory_store
end
```

The inner data structure of `ActiveSupport::Cache::MemoryStore` is not publically accessible.

```
[1] pry(main)> Rails.cache.write('my-cache-key', 'my-value')
=> true
[2] pry(main)> Rails.cache
=> <#ActiveSupport::Cache::MemoryStore entries=1, size=260, options={}>
[3] pry(main)> ls Rails.cache
ActiveSupport::ToJsonWithActiveSupportEncoder#methods: to_json
ActiveSupport::Dependencies::ZeitwerkIntegration::RequireDependency#methods: require_dependency
ActiveSupport::Cache::Store#methods: delete  exist?  fetch  fetch_multi  logger  logger=  mute  options  read  read_multi  silence  silence!  silence?  write  write_multi
ActiveSupport::Cache::MemoryStore#methods: cleanup  clear  decrement  delete_matched  increment  inspect  prune  pruning?  synchronize
instance variables: @cache_size  @data  @key_access  @max_prune_time  @max_size  @monitor  @options  @pruning
class variables: @@logger
```

The _raw_ data is held in the instance variable `@data`. We can _reach in_ and grab that to perform some inspections:


```
[4] pry(main)> Rails.cache.instance_variable_get(:@data)
=> {"my-cache-key"=>#<ActiveSupport::Cache::Entry:0x00007f8ade4da858 @created_at=1580064434.3177679, @expires_in=nil, @value="my-value", @version=nil>}
```

The caveat of this approach is clear, as we're reaching into the private space of the Rails cache.

# Creating the Helper

I wanted to make it easier for myself and others to test Rails caching in this project. Creating a test helper is ideal as all the tests can reach for the built utilities when testing code related to caching.

We'll create a new test helper, that can be included in our `test/test_helper.rb`:

```ruby
# test/support/rails_cache_helper.rb:
module RailsCacheHelper
  def with_clean_caching
    Rails.cache.clear
    yield

  ensure
    Rails.cache.clear
  end

  def cache_has_value?(value)
    cache_data.values.map(&:value).any?(value)
  end

  def key_for_cached_value(value)
    cache_data.values.each do |key, entry|
      return key if entry&.value == value
    end
  end

  private

  def cache_data
    Rails.cache.instance_variable_get(:@data)
  end
end
```

This helper gives us three utilities:

1. The `with_clean_caching` method, which purges the cache before and after the _block_ is executed. It is worth noting that the `:memory_store` is only purged at the end of the test suite.
2. The `cache_has_value?(value)` method, which returns a _boolean_ if the cache has the specified _value_.
3. The `key_for_cached_value(value)` method, which returns the _key_ that can be used to look up the specified _value_.

With these new methods, it was much easier to test the caching code. There was no need to do any fancy stubbing and/or using mock objects.

Note: there are more features that can be expanded upon in this helper:

  - Working with the meta-data on cache entries (e.g., `expires_in`).
  - Custom assertions (e.g., `assert_cached(value)`).

# Testing Rails Caching

Now I was able to test the caching specifically. I wrapped my tests in `with_clean_caching` as these tests were specific about using caching. I could have also approached this by making it so the cache is purged before each test (e.g., `setup()`, `before(:each)`), but I didn't opt for that right now.

The following is a contrived example, but you could imagine that the _cache key_ is generated much deeper in the application code. This makes it difficult to _get_ the cache key to then inspect and make assertions about the cached data.

Using `RailsCacheHelper` (that we created above), we can make use of `#cache_has_value?` and `#key_for_cached_value` to make assertions based on the returned value without needing to know the _cache key_.

```ruby
# test/caching_test.rb
class CachingTest < ActiveSupport::TestCase
  test 'caching works' do
    with_clean_caching do
      # bunch of test setup ...

      result = Caching.expensive_call(some_object, data_structure, request_data)

      assert(cache_has_value?(result))
    end
  end

  test 'caching is not used if request header specifies caching=false' do
    with_clean_caching do
      # bunch of test setup, and adding caching=false in request_data ...

      result = Caching.expensive_call(some_object, data_structure, request_data)

      assert(cache_has_value?(result))
    end
  end

  test 'cache varies correctly based on object' do
    with_clean_caching do
      # bunch of test setup ...

      original_result = Caching.expensive_call(some_object, data_structure, request_data)
      original_key = key_for_cached_value(original_result)

      # setup different_object

      changed_object_result = Caching.expensive_call(different_object, data_structure, request_data)
      changed_object_key = key_for_cached_value(changed_object_result)

      rufute_equal(original_key, changed_object_key)
    end
  end

  test 'cache varies correctly based on data structure' do
    with_clean_caching do
      # pretty much same as the last test but varying the data structure
    end
  end

  test 'cache varies correctly based on request data' do
    with_clean_caching do
      # pretty much same as the last test but varying the request_data
    end
  end
end
```

Note that this approach worked for me, however, there are many different ways to test Rails caching. For example, this [StackOverflow answer](https://stackoverflow.com/a/9603083/583592) suggests making an `InspectableMemoryStore` which subclasses `ActiveSupport::Cache::MemoryStore`.
