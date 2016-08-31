---
title: "Git Evolution: How did we get Here?"

teaser: |
  In a large long-lived git repository there is a lot of history behind the current state of things. `git blame` lets you scratch the surface, while `git log` lets you dig deeper. The use of `git evolution` provides a succient and yet comprhensive approach to understanding the evolution of a range of lines within a git repository.

tags:
- ruby
- git
- vim

---

As a developer its not uncommon to want a little more context surrounding the code snippet you are dealing with. You might have found yourself in these situations and reached for `git blame` to get some initial context in why the code is like it is. This only scratches the surface and you might want a more context which `git log` can provide to you. You are mostly interested in how the code evolved to this point, and really want you want is `git evolution`.

I developed [git_evolution](https://github.com/kevinjalbert/git_evolution) to solve a personal problem of mine while spelunking in a git repository trying to find more reasons to why the code might have evolved in this way.

To best describe what and how git evolution can be used the next section (_Example Scenario_) comes directly from `git_evolution`'s [README](https://github.com/kevinjalbert/git_evolution#example-scenario).

## Example Scenario

If we were interesting in the source code evolution that lead to [rails's Array#forty_two](https://github.com/rails/rails/blob/7ba3a48/activesupport/lib/active_support/core_ext/array/access.rb#L70-L75):

```
$ git_evolution --range 70:75 ./rails/activesupport/lib/active_support/core_ext/array/access.rb

Commits:
utenmiki <utenmiki@gmail.com> (Thu Oct 31 23:20:15 2013 +0900) - 3f79d8423078f0671c8aa505ae199608d451663d
Add Rdoc document for Array#forty_two

Jeremy Kemper <jeremy@bitsweat.net> (Sat Mar 21 03:26:09 2009 -0700) - 83fd1ae122cf1ee4ea2c52e0bd963462163516ca
Convert array extension modules to class reopens

David Heinemeier Hansson <david@loudthinking.com> (Fri Nov 21 09:06:46 2008 +0100) - e50530ca3ab5db53ebc74314c54b62b91b932389
Reduced the number of literal aliases to the range that has actually seen personal use. With the massive savings in overhead, I was able to fit Array#forty_two

Pratik Naik <pratiknaik@gmail.com> (Sun Oct 5 22:16:26 2008 +0100) - a2932784bb71e72a78c32819ebd7ed2bed551e3e
Merge docrails

Pratik Naik <pratiknaik@gmail.com> (Mon Jul 28 12:26:59 2008 +0100) - 6e754551254a8cc64e034163f5d0dc155b450388
Merge docrails changes

David Heinemeier Hansson <david@loudthinking.com> (Tue Jun 17 13:37:57 2008 -0500) - 22af62cf486721ee2e45bb720c42ac2f4121faf4
Added Array#second through Array#tenth as aliases for Array#[1] through Array#[9] [DHH]

David Heinemeier Hansson <david@loudthinking.com> (Tue Nov 27 19:42:30 2007 +0000) - 4d177ae0d6d9f60c4000f45fb6f6df27317afbff
Added Array#from and Array#to that behaves just from String#from and String#to [DHH]

--------------------------------------------------------------------------------

Ownership (Commits):
David Heinemeier Hansson <david@loudthinking.com> - 3/7 (42.86%)
Pratik Naik <pratiknaik@gmail.com> - 2/7 (28.57%)
Jeremy Kemper <jeremy@bitsweat.net> - 1/7 (14.29%)
utenmiki <utenmiki@gmail.com> - 1/7 (14.29%)

Ownership (Changes):
David Heinemeier Hansson <david@loudthinking.com> - 53/84 (63.1%)
Pratik Naik <pratiknaik@gmail.com> - 20/84 (23.81%)
Jeremy Kemper <jeremy@bitsweat.net> - 9/84 (10.71%)
utenmiki <utenmiki@gmail.com> - 2/84 (2.38%)
```

`GitEvolution` provides a succinct output of the commits which contains any changes which lead to the current state. Its quick to see that [e50530ca3ab5db53ebc74314c54b62b91b932389](https://github.com/rails/rails/commit/e50530ca3ab5db53ebc74314c54b62b91b932389) was the introduction point for `Array#forty_two`.

In addition we have some _ownership_ information with respect to commits and changes. The ownership information can be used to identify _who_ to follow up with for additional context. In time new metrics and analysis could be attached to the output (i.e., factoring in time for ownership, types of changes, identifying file modifications such as movement or renames, etc...)

## The Other (Hard) Way

If we were to identify the commit which introduced `Array#forty_two` we have two main options `git blame` and `git log`:

### Using `git blame`
I highly advise against this approach as it involves a lot of manual work. You essentially use `git blame` to identify the previous commit which effects a line of concern within the area you are looking in.

```
$ git blame --follow ./activesupport/lib/active_support/core_ext/array/access.rb

...
83fd1ae1 (Jeremy Kemper            2009-03-21 03:26:09 -0700 70)   # Equal to <tt>self[41]</tt>. Also known as accessing "the reddit".
3f79d842 (utenmiki                 2013-10-31 23:20:15 +0900 71)   #
3f79d842 (utenmiki                 2013-10-31 23:20:15 +0900 72)   #   (1..42).to_a.forty_two # => 42
83fd1ae1 (Jeremy Kemper            2009-03-21 03:26:09 -0700 73)   def forty_two
83fd1ae1 (Jeremy Kemper            2009-03-21 03:26:09 -0700 74)     self[41]
4d177ae0 (David Heinemeier Hansson 2007-11-27 19:42:30 +0000 75)   end
...
```

You can then use a similar command to blame the parent git revision at that point.

```
$ git blame --follow 83fd1ae1^ -- ./activesupport/lib/active_support/core_ext/array/access.rb

...
e50530ca (David Heinemeier Hansson 2008-11-21 09:06:46 +0100 46)         # Equal to <tt>self[41]</tt>. Also known as accessing "the reddit".
e50530ca (David Heinemeier Hansson 2008-11-21 09:06:46 +0100 47)         def forty_two
e50530ca (David Heinemeier Hansson 2008-11-21 09:06:46 +0100 48)           self[41]
22af62cf (David Heinemeier Hansson 2008-06-17 13:37:57 -0500 49)         end
...
```

All the while you occasionally want to inspect the commit in more detail using `git show <commit-sha>`. Eventually you will end up where you want to be.

```
$ git show e50530ca

commit e50530ca3ab5db53ebc74314c54b62b91b932389
Author: David Heinemeier Hansson <david@loudthinking.com>
Date:   Fri Nov 21 09:06:46 2008 +0100

    Reduced the number of literal aliases to the range that has actually seen personal use. With the massive savings in overhead, I was able to fit Array#forty_two
```

### Using `git log`
The following `git log` command presents the entire file history (26 commits):

```
$ git log --follow ./activesupport/lib/active_support/core_ext/array/access.rb
```

This works, but it is a lot more information to sift through.

A better approach (which is what `GitEvolution` uses under the hood) presents the file history for only the concerned portion (7 commits):

```
$ git log -L70,75:./activesupport/lib/active_support/core_ext/array/access.rb --follow ./activesupport/lib/active_support/core_ext/array/access.rb
```

The output isn't succinct, nor does it have ownership information. The command is also more verbose.

## Advance Usage
I personally use Vim for all my editing needs, especially while editing code. As most of the projects I'm working in are version controlled with Git I made a [Vim function](https://github.com/kevinjalbert/dotfiles/blob/eaca550/vim/vim/functions.vim#L1-L16) that allows me to visually select and call `git_evolution` using `ge` on the selected lines. This opens the output in a new buffer which I can then look through and yank commit SHAs if needed.

## The Future
Similar to what I mentioned in my [last post about `port_map`](https://kevinjalbert.com/port-mapping-development-servers/), `git_evolution` is a RubyGem, which is effectively tied to a specific Ruby version. When dealing with multiple Ruby version projects using [rvm](https://rvm.io/)/[rbenv](http://rbenv.org/) sometimes `git_evolution` is not installed. It is a slight detour to install `git_evolution` for the current Ruby version when I switch to a new Ruby version. Ideally `git_evolution` would not be tied to Ruby, and instead is a transportable executable (for example one written in Bash or Go).

I do want to expand on the _ownership_ aspect of `git_evolution` as I think it'll help quicker identify _who_ could be contacted for additional context. Currently it is simply looking at commits and change totals. Ideally there would be a better algorithm to determine ownership of selected lines.
