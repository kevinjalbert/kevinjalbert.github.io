---
title: "Digging through Git History for Removed Text"

description: "The text you are looking for isn't in the current revision anymore, and so you'll have to dig through the Git history somehow, looking for when it was removed/introduced. Read about how I approached this from a CLI perspective, using a script to simplify these searches for me."

tags:
- git
- tool

pull_image: "/images/2022-07-31-digging-through-git-history-for-removed-text/digger.jpg"
pull_image_attribution: '[Close up of a modern excavator bucket digging a hole in the ground](https://flickr.com/photos/26344495@N05/50516511398 "Close up of a modern excavator bucket digging a hole in the ground") by [Ivan Radic](https://flickr.com/people/26344495@N05) is licensed under [CC BY](https://creativecommons.org/licenses/by/2.0/)'
---

# Deleted files in Git

Git keeps a history of practically _everything_ for your repository. I cannot state how powerful a tool it is, and has helped me immensely as I try to understand the _why_ of some code.

There are times when I've tried to _find_ something that doesn't exist in the current revision but was in a previous version. I've always struggled with this, and I wanted a _simpler_ and (hopefully) _quicker_ way to conduct this search.

I decided to script my way to a solution that I feel happy about for now.

# Let's go Digging

This script ends up doing the following to search through Git history for matching text:

  1. Search for any commits with any 'additions/removals' of the search query.
  2. For each commit, get the list of files that contain the search query.
  3. For each file, `grep` the `git` patch and print the lines that match the search query (with the match highlighted).

A lot of the `git` commands are leveraging the `--pickaxe-regex -S<query>` flags to search changes with regex powers:

```
-S<string>
  Look for differences that change the number of occurrences of the specified string (i.e. addition/deletion) in a file.

--pickaxe-regex
  Treat the <string> given to -S as an extended POSIX regular expression to match.
```

This would allow for the search query to leverage regular expressions. The following is an example of looking through my [dotfiles repo](https://github.com/kevinjalbert/dotfiles) for ` zgen` (which is something I don't use anymore).

```
❯ git dig "\szgen"
Searching for any commits with any 'additions/removals'
  Matching regex: "\szgen"

commit bd5dc58e9f94b7b62013a1378fbe7d101ccc70ec
Author: Kevin Jalbert <kevin.j.jalbert@gmail.com>
Date:   Fri Jan 6 17:42:44 2017 -0500

    Update zsh.rake to install zplug instead of zgen

FILE -> tasks/zsh.rake
-  desc "Install zgen"
-    section "Installing zgen"

# Plus a few more commits
```

## The git-dig Script

This [GitHub Gist](https://gist.github.com/kevinjalbert/b390e2d22efa1c55a46c52d1f7ff3cde) will be the canonical reference of the `git-dig` script (and will see updates as needed).

```ruby
#!/usr/bin/env ruby

require 'optparse'
require 'open3'

def files_with_search_query(sha, search_query)
  `git show --format="" --name-only #{sha} -i --pickaxe-regex -S #{search_query}`.split("\n")
end

def grep_over_file(sha, file, search_query)
  git_show_cmd = "git show --format='' -p #{sha} -- '#{file}'"
  grep_cmd = "grep -i --color=always -E #{search_query}"
  `#{git_show_cmd} | #{grep_cmd}`
end

def git_pickaxe_search(search_query, options, &block)
  git_log_cmd = "git log --no-merges --format=%h"
  git_log_cmd += " --after=\"#{options[:after]}\"" if options[:after]
  git_log_cmd += " --before=\"#{options[:before]}\"" if options[:before]
  git_log_cmd += " -i --pickaxe-regex -S #{search_query}"

  Open3.popen3(git_log_cmd) do |stdin, stdout, stderr, thread|
    yield(stdout)
  end
end

def git_commit_info(sha)
  `git show --no-patch #{sha}`
end

def find_root_dir
  current_dir = Dir.pwd

  until Dir.exist?([current_dir, ".git"].join(File::SEPARATOR)) do
    parent_dir = File.dirname(current_dir)

    if parent_dir == current_dir
      puts "No .git repo found in path (or parent paths)."
      exit
    end

    current_dir = parent_dir
  end

  current_dir
end

# Handle options
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: git-dig [options] [regex query]"

  opts.on("--after=DATE", "Only searches commits more recent than the specific date.") do |v|
    options[:after] = v
  end

  opts.on("--before=DATE", "Only searches commits older recent than the specific date.") do |v|
    options[:before] = v
  end

  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end
end.parse!

# Get search query
search_query = "\"#{ARGV.first}\""
if search_query == '""' # empty search as it would just be a pair of quotes
  puts "You need to pass a search term as input."
  exit
end

puts "Searching for any commits with any 'additions/removals'"
puts "  Matching regex: #{search_query}"
if options[:after] || options[:before]
  puts "  With search options: #{options}"
end
puts ""

# Get SHAs of all commits which had some 'addition/removal' of the search term
git_pickaxe_search(search_query, options) do |stdout|
  while line = stdout.gets
    exit if line.nil?

    sha = line.strip

    puts git_commit_info(sha)
    puts ""

    # Print diff of files which have search term
    files_with_search_query(sha, search_query).each do |file|
      puts "FILE -> #{file}"
      puts grep_over_file(sha, file, search_query)
      puts ""
    end

    puts "-"*80
    puts ""
  end
end
```

# Alternative Solutions

To note, most Git GUIs have some search functionality in place which can satisfy the majority of this. Using the Git CLI is still a nice thing to be able to leverage though, which is why I went this route.
