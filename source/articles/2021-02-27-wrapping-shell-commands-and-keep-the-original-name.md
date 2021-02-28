---
title: "Wrapping Shell Commands and Keep the Original Name"

description: "In this post, I present two ways to wrap a shell command and keep its original name. This allows you to run additional statements before and after the execution of a command that you don't own."

tags:
- tools
- shell
- terminal

pull_image: "/images/2021-02-27-wrapping-shell-commands-and-keep-the-original-name/shell-book.jpg"
pull_image_attribution: '[Shell](https://flickr.com/photos/30403793@N03/9664491018 "Shell") by [snap713](https://flickr.com/people/30403793@N03) is licensed under [CC BY-NC-ND](https://creativecommons.org/licenses/by-nc-nd/2.0/)'
---

I wanted to wrap a shell command (that I had no ownership of) so that I could execute additional statements around the original command. In the following sections, I present two scenarios for wrapping shell commands.

I do want to say there is a possibility that the wrapped command _could_ potentially cause some issues down the road, however, I have not encountered any as of yet with my limited testing.

# Wrapping an Executable

You can create a new function with the name of the executable that you wish to wrap. This works because the function lookup occurs before the executable lookup on your PATH.

```bash
# In .zshrc or .bashrc
ping() {
  echo "before"

  /sbin/ping $@
  local exit_code=$?

  echo "after"

  return $exit_code
}
```

The function itself uses the original executable (`/sbin/ping`) by specifying the full-path along with the original parameters (via `$@`). We grab the _exit code_ (via `$?`) and store it to be returned at the ending. This ensures that the new function still operates as it did before.

```bash
❯ ping google.com -c 1
before
PING google.com (172.217.0.238): 56 data bytes
64 bytes from 172.217.0.238: icmp_seq=0 ttl=115 time=25.484 ms

--- google.com ping statistics ---
1 packets transmitted, 1 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 25.484/25.484/25.484/0.000 ms
after
```

We can see that that the `ping` command still works as expected, but we also now have additional statements around it.

# Wrapping a Function

The approaches for dealing with a function were mostly borrowed from this [Unix StackExchange answer](https://unix.stackexchange.com/questions/102595/is-there-a-hook-like-system-for-shell/102626#102626).

```bash
# Not a function I have defined (i.e., defined in a library I sourced)
function example() {
  echo "inside example function ($@)"
}

# In .zshrc or .bashrc
eval _"$(declare -f example)"
example() {
  echo "before function"

  _example $@
  local exit_code=$?

  echo "after function"

  return $exit_code
}
```

The `eval` is essentially renaming the original function (`example`) to have a leading underscore (`_example)`. A new function is then defined that overrides `example`, and actually uses the original's function (now called `_example`). You define additional statements before and after the wrapped function, in a similar fashion to how it was handled with wrapping an executable. The exit code is also preserved from the wrapped function.

```bash
❯ example 5
before
inside example function 5
after
```

One downside to the above approach is that the _old_ function is still present (`_example`). While the following only works in ZSH, it is possible to directly override the original function by using the original's definition when creating the new function. To note, I do find the former approach simpler.

```bash
# .zshrc
functions[example]='
  (){
    echo "before"

    '$functions[example]';
    } "$@";
  local exit_code=$?

  echo "after"

  return $exit_code'
```
