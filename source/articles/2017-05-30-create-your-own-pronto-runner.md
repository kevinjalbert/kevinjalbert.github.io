---
title: "Create your own Pronto Runner"

description: "Pronto runners provides an automatic mechanism to find offenses in code reviews. Learn the essentials of pronto runners so that you can build your own."

tags:
- ruby
- pronto
- code review

pull_image: "/images/2017-05-30-create-your-own-pronto-runner/robot.jpg"
pull_image_attribution: 'By Vanillase (Own work) [CC BY-SA 3.0](http://creativecommons.org/licenses/by-sa/3.0), via [Wikimedia Commons](https://commons.wikimedia.org/wiki/File:ASIMO_Conducting_Pose_on_4.14.2008.jpg)'
---

# What is Pronto?

[Pronto](https://github.com/prontolabs/pronto) is a tool that provides an automated code review over new changes in a git branch. It is typically used in continuous integration as a way to provide feedback on a pull/merge request. It is configurable in how it provides feedback, through the use of _formatters_. For example, pronto on GitHub could [comment directly on the offending line](https://github.com/prontolabs/pronto/blob/master/lib/pronto/formatter/github_pull_request_formatter.rb), use [pull request status checks](https://github.com/prontolabs/pronto/blob/master/lib/pronto/formatter/github_status_formatter.rb), or even the recent [pull request review](https://github.com/prontolabs/pronto/blob/master/lib/pronto/formatter/github_pull_request_review_formatter.rb).

Pronto uses the concept of _runners_ to indicate what pronto will use to look for offenses during a code review. Generally, runners act as wrappers around existing tools. There are a number of [open source runners](https://github.com/prontolabs/pronto#runners) available, and for the most part they will provide what you need. In some cases you'll want something different, which does not _yet_ exist as a runner. This is where you can create a new runner to fill the gap.

# What is a Runner's Job?

Pronto runners are responsible for parsing out offenses and matching them with lines from a git patch. These offenses normally are the result of a tool that the runner is using (i.e., a linter). The end goal is that the runner sends messages containing the patch line change and the offense to pronto. There are two methods that I've seen when approaching a pronto runner, and are dictated by the following constraints:

1. The tool can be run on individual files.
2. The tool needs be run with the context of the whole code base.

The second option could be used regardless, although when the size of your codebase increases the number of files that have to be processed would grow as well. Ideally, you would want the runner to be as quick as possible, so running the tool over the least amount of files would help accomplish that. In addition, there would be less error noise produced from non-changed files.

In my experience, when creating [pronto-stylelint](https://github.com/kevinjalbert/pronto-stylelint) and [pronto-flow](https://github.com/kevinjalbert/pronto-flow), I used existing pronto runners as my base. I would recommend the same when starting a new runner. Pick one as your base (which follows the approach you need) and modify as necessary. Again, most pronto runners are fairly straight forward, and usually consist of one file.

# Examining a Runner

Let's take a look at [pronto-rubocop](https://github.com/prontolabs/pronto-rubocop/blob/v0.8.1/lib/pronto/rubocop.rb) and make a few notes:

* The class inherits from `Pronto::Runner`, which provides the patch information along with [other methods](https://github.com/prontolabs/pronto/blob/v0.8.2/lib/pronto/runner.rb) that you can use within your runner.
* `#initialize` is setting up any custom configurations, as well as creating the `Rubocop::Runner` instance.
* `#run` is the [entry point of the runner](https://github.com/prontolabs/pronto/blob/v0.8.2/lib/pronto/runners.rb#L20) -- this is where all your logic can start to come into play.
* In pronto-rubocop, `#run` is selecting all the patch information that pronto provides it, and only processing (i.e., run rubocop and send messages) those which are valid (i.e., ruby file that has a change).
* The `#inspect` method processes each patch with rubocop. The reported offenses from rubocop get matched up with the patch file/line. When a match is found then `#new_message` is called.
* The output of a pronto runner is to create instances of `Pronto::Message`, which requires [specific data inputs](https://github.com/prontolabs/pronto/blob/master/lib/pronto/message.rb#L7-L19).

The following is a stripped down and commented version of pronto-rubocop:

```ruby
require 'pronto'
require 'rubocop'

module Pronto
  class Rubocop < Runner
    // Required `#run` method -- entry point
    def run
      return [] unless @patches

      // Loop over all patches passed in from pronto and only select valid ones
      // to inspect, process and possibly create a message from.
      @patches.select { |patch| valid_patch?(patch) }
        .map { |patch| inspect(patch) }
        .flatten.compact
    end

    def valid_patch?(patch)
      return false if patch.additions < 1

      // Return boolean value to determine if patch is valid for this runner.
      // i.e., whether the file type/path should be included by the runner.
    end

    def inspect(patch)
      // Process the file for the patch and acquire the generated offenses.
      processed_source = processed_source_for(patch)
      offences = @inspector.send(:inspect_file, processed_source).first

      // Filter the offenses to only those which match up to a line from the
      // patch. If so then create a message with said information.
      offences.sort.reject(&:disabled?).map do |offence|
        patch.added_lines
          .select { |line| line.new_lineno == offence.line }
          .map { |line| new_message(offence, line) }
      end
    end

    def new_message(offence, line)
      path = line.patch.delta.new_file[:path]
      level = offence.severity.name // Symbol of offence.

      // Required construct to have pronto receive the messages.
      // The `line` here is the line extracted from the @patch.
      Message.new(path, line, level, offence.message, nil, self.class)
    end

    def processed_source_for(patch)
      // Rubocop processing of file from patch.
    end
  end
end
```

# Building a Runner

As previously mentioned, most pronto runners are simply wrappers for an existing tool and the whole runner itself is quite small. Given that you inherit from `Pronto::Runner`, the only method you need to implement is `#run`. There is a lot of flexibility in what your runner can do.

Together let's build a runner that flags lines that contain one of the [seven dirty words](https://en.wikipedia.org/wiki/Seven_dirty_words). I decided to use [pronto-stylelint](https://github.com/kevinjalbert/pronto-stylelint) as my base, which I then pulled out everything except the essentials:

```ruby
require 'pronto'
require 'shellwords'

module Pronto
  class DirtyWords < Runner
    DIRTY_WORDS = ['shit', 'piss', 'fuck', 'cunt', 'cocksucker', 'motherfucker', 'tits']

    def run
      return [] if !@patches || @patches.count.zero?

      @patches
        .select { |patch| patch.additions > 0 }
        .map { |patch| inspect(patch) }
        .flatten.compact
    end

    private

    def git_repo_path
      @git_repo_path ||= Rugged::Repository.discover(File.expand_path(Dir.pwd)).workdir
    end

    def inspect(patch)
      offending_line_numbers(patch).map do |line_number|
        patch
          .added_lines
          .select { |line| line.new_lineno == line_number }
          .map { |line| new_message('Avoid using one of the seven dirty words', line) }
      end
    end

    def new_message(offence, line)
      path = line.patch.delta.new_file[:path]
      level = :warning

      Message.new(path, line, level, offence, nil, self.class)
    end

    def offending_line_numbers(patch)
      line_numbers = []

      Dir.chdir(git_repo_path) do
        escaped_file_path = Shellwords.escape(patch.new_file_full_path.to_s)

        File.foreach(escaped_file_path).with_index do |line, line_num|
          line_numbers << line_num + 1 if DIRTY_WORDS.any? { |word| line.downcase.include?(word) }
        end

        line_numbers
      end
    end
  end
end
```

The `#offending_line_numbers` methods is where the check for a _dirty word_ occurs. When an offending line is found, we flag the line number for that file to be used in `#new_message`. Overall, it is not that hard to put together a simple pronto runner. To look at the end result of this pronto runner, it is open sourced at [pronto-dirty_words](https://github.com/kevinjalbert/pronto-dirty_words). Never forget it is always possible to add configuration files and external tools to a runner.

# Pronto all the things

To this date, I have created two useful pronto runners (_dirty words_ was more of a demo for this post). I have personally been using pronto for several years, and I will continue to use it. The ecosystem of runners continues to grow. I hope that this post helps others in creating new runners that will benefit everyone. Keep an eye out for tools that could be wrapped in a pronto runner -- maybe you can help add to the set of runners!
