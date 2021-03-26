---
title: "Defined Methods in Rake Tasks; You're Gonna Have a Bad Time"

description: "Do you define methods within your Rake tasks? You might want to reconsider that, or you're gonna have a bad time down the road. Walkthrough an example which illustrates a tricky gotcha and solutions to avoiding it."

tags:
- ruby
- rake
- rails
---

Rake tasks provide a nice way to handle common tasks surrounding a ruby project. Within Rails projects they are nearly unavoidable and even have their own directory from which they are autoloaded. Eventually a project will grow in size and complexity to warrant multiple _task_ files for better separation of concerns. This alone is nothing to be worried about, but it's when you start using methods in your task files that _you're gonna have a bad time_.

Let's setup a dummy Rails project that has a task file that calculates and saves blog metrics.

```ruby
# lib/tasks/blog_metrics_task.rake
desc 'Calculate and save blog metrics'
task :blog_metrics do
  metrics = calculate_blog_metrics
  save(metrics)
end

def calculate_blog_metrics
  puts "Calculating blog metrics"
end

def save(metrics)
  puts "Saving blog metrics"
end
```

When we run our task it does exactly what we wanted and expected it to do.

```
$ rake blog_metrics
Calculating blog metrics
Saving blog Metrics
```

No problem! Now lets fast-forward in time to when we want to add another task that creates a new blog post.

```ruby
# lib/tasks/create_blog_post_task.rake
desc 'Create and save a new blog post'
task :create_blog_post do
  blog_post = generate_default_blog_post
  save(blog_post)
end

def generate_default_blog_post
  puts "Generating a default blog post"
end

def save(blog_post)
  puts "Saving default blog post"
end
```

When we run our new task it does exactly what we wanted and expected it to do.

```
$ rake create_blog_post
Generating a default blog post
Saving default blog post
```

Another success! Now here is where things get interesting. Let's go back and run the first _correctly working_ task.

```
$ rake blog_metrics
Calculating blog metrics
Saving default blog post
```

Woah... it's the `#save` that was defined in the other task file -- `create_blog_post_task.rake`.

This is kind of shocking and might have caught you off guard. Rails automatically loads all rake tasks (i.e., requires their file) when executing any rake task. The _gotcha_ here is that the defined methods in the loaded tasks files end up defined on the global namespace. These defined methods are therefore accessible across rake files, so it is _possible_ for methods to clash and be redefined if their signatures match.

To better illustrate the order of events:

1. `rake blog_metrics`
2. _Rails autoloads all rake tasks in alphanumeric order_
3. `lib/tasks/blog_metrics_task.rake` _is loaded and defines_ `#calculate_blog_metrics` _and_ `#save`
4. `lib/tasks/create_blog_post_task.rake` _is loaded and defines_ `# generate_default_blog_post` _and **redefines**_ `#save`
5. `blog_metrics` _task is executed using last defined `#save`, which was defined in the other task file_

No worries right? Rake provides a 'namespace' DSL. So we can modify our tasks to use this.

```ruby
namespace :blog_metrics do
  desc 'Calculate and save blog metrics'
  task :run do
    metrics = calculate_blog_metrics
    save(metrics)
  end

  def calculate_blog_metrics
    puts "Calculating blog metrics"
  end

  def save(metrics)
    puts "Saving blog metrics"
  end
end
```

We should be in the clear now.

```
$ rake blog_metrics:run
Calculating blog metrics
Saving default blog post
```

Nope! The namespace DSL does nothing for the defined methods. So we still have the same problem.

There are a couple of solutions to this problem:

1. Rename the methods, and ensure all future methods are uniquely named
2. Inline the contents of the defined methods
3. Extract the methods into a module/class and use that
4. Move the methods inside the task

# Solution #1 - Uniquely Named Methods
It is possible to simply ensure that we uniquely name our methods so that they do not clash and end up redefining each other.

```ruby
# lib/tasks/blog_metrics_task.rake
desc 'Calculate and save blog metrics'
task :blog_metrics do
  metrics = calculate_blog_metrics
  save_blog_metrics(metrics)
end

def calculate_blog_metrics
  puts "Calculating blog metrics"
end

def save_blog_metrics(metrics)
  puts "Saving blog metrics"
end
```

```ruby
# lib/tasks/create_blog_post_task.rake
desc 'Create and save a new blog post'
task :create_blog_post do
  blog_post = generate_default_blog_post
  save_default_blog_post(blog_post)
end

def generate_default_blog_post
  puts "Generating a default blog post"
end

def save_default_blog_post(blog_post)
  puts "Saving defualt blog post"
end
```

This works and is a quick fix, although it is not exactly sustainable and requires you to be conscientious when naming new methods.

# Solution #2 - Inline Method Contents

To ensure that method redefinition doesn't occur we can simply remove the methods and inline their content.

```ruby
# lib/tasks/blog_metrics_task.rake
desc 'Calculate and save blog metrics'
task :blog_metrics do
  puts "Calculating blog metrics"
  metrics = # Inline calculating work

  puts "Saving blog metrics"
  # Inline saving work
end
```

```ruby
# lib/tasks/create_blog_post_task.rake
desc 'Create and save a new blog post'
task :create_blog_post do
  puts "Generating a default blog post"
  blog_post = # Inline blog post generation work

  puts "Saving default blog post"
  # Inline saving work
end
```

This is also a quick fix, and might be optimal depending on the size, complexity, and reuse of the method's content.

# Solution #3 - Extract Methods into Module/Class

Removing the methods from the rake files themselves is another valid solution. The methods can be extracted into their own class or module and used within the task files.

```ruby
# lib/blog_metric_calculator.rb
class BlogMetricCalculator
  def metrics
    puts "Calculating blog metrics"
  end

  def save(metrics)
    puts "Saving blog metrics"
  end
end

# lib/tasks/blog_metrics_task.rake
require 'lib/blog_metric_calculator'

desc 'Calculate and save blog metrics'
task :blog_metrics do
  calculator = BlogMetricCalculator.new
  calculator.save(calculator.metrics)
end
```

```ruby
# lib/blog_post_creator.rb
module BlogPostCreator
  def self.create_default_blog_post
    puts "Generating a default blog post"
  end

  def self.save(post)
    puts "Saving default blog post"
  end
end

# lib/tasks/create_blog_post_task.rake
require 'lib/blog_post_creator'

desc 'Create and save a new blog post'
task :create_blog_post do
  blog_post = BlogPostCreator.create_default_blog_post
  BlogPostCreator.save(blog_post)
end
```

This is the preferred method if there is sufficient complexity involved. By extracting the methods you begin to build up a set of related concerns within a module/class. By having an external entity outside of the rake tasks themselves you can now _test_ the defined functionality!

# Solution #4 - Move the methods inside the task

Whilst the rake namespaces do nothing to scope the methods, defining them within the task block will isolate them from each other.

```
# lib/tasks/blog_metrics.rake
desc 'Calculate and save blog metrics'
task :create_blog_metrics do
  def calculate_metrics
    puts "Calculating blog metrics"
  end

  def save(metrics)
    puts "Saving blog metrics"
  end

  metrics = calculate_metrics
  save(metrics)
end

# lib/tasks/blog_post.rake
desc 'Generate and save a default blog post'
task :create_blog_post do
  def generate_default_blog_post
    puts "Generating a default blog post"
  end

  def save(blog_post)
    puts "Saving default blog post"
  end

  blog_post = generate_default_blog_post
  save(blog_post)
end
```

Now the two `.save` methods are scoped within the task block. This is esentially the same as inlining the code but you get to keep the advantage of meaningful method names. This option is probably the best first step if you don't need to share the method between tasks. Later you can extract it to a Class/Module if you need to use it elsewhere.
