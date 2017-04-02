---
title: "Port Mapping Development Servers"

description: "As a developer its not uncommon to juggle multiple servers that interact with each other during development. Ensuring that each server has the correct port set while working off of localhost is a cumbersome and error prone issue. port_map is a ruby utility that provides a simple and almost automatic solution to this problem."

tags:
- development
- shell
- terminal
- ruby
---

As a developer its not uncommon to juggle multiple servers that interact with each other during development. Ensuring that each server has the correct port set while working off of `localhost` is a cumbersome and error prone issue. [port_map](https://github.com/kevinjalbert/port_map) is a ruby utility that provides a simple and almost automatic solution to this problem.

I developed this utility gem to solve a personal problem of mine while dealing with multiple web servers during development. The next section (_Example Scenario_) comes directly from `port_map`'s [README](https://github.com/kevinjalbert/port_map#example-scenario).

## Example Scenario
You are developing a service that uses multiple web servers. You have two rails applications and one ember application.

| Application | Directory | Command | Local URL |
|-------------|-----------|---------|-----------|
Rails API | `/api/` | `rails server` | http://localhost:3000
Rails Background Jobs | ``/jobs/`` | `rails server --port 3001` | http://localhost:3001
Ember Application | `/ember/` | `ember server` | http://localhost:4200

### The Problem
In each of these applications there is some configuration work required to ensure that they communicate on the correct ports. There are two issues here:

- As we add more web servers we have to avoid clashing on existing ports.
- You have to make sure that you correctly start each server with the right port number.

### `port_map` to the Rescue!
We're going to transform this unwieldy scenario into an organized and easy to manage one using `port_map`.

| Application | Directory | Command | Local URL |
|-------------|-----------|---------|-----------|
Rails API | `/api/` | `port_map rails server` | http://api.dev
Rails Background Jobs | ``/jobs/`` | `port_map rails server` | http://jobs.dev
Ember Application | `/ember/` | `port_map ember server` | http://ember.dev

The domain names can be configured with environment variables, but by default they are based on the directory's name.

You can close and restart each web server multiple times and they will continue to use the same domain names. `port_map` provides an easy way to logically name each web server, as well as remove the need of specifying ports.

## Putting it to the Test
I have been using `port_map` for a little over 6 months (as of writing this), and it has served me quite well. The beauty of `port_map` is that it works on any shell command that accepts a `--port <number>` or `-p <number>` flag. I enjoy finding new uses for `port_map` in other web servers like [middleman](https://middlemanapp.com) and [jekyll](https://jekyllrb.com).

There was one issue that I have hit, although its not a deal breaker [kevinjalbert/port_map#7](https://github.com/kevinjalbert/port_map/issues/7), although I suspect I can fix this eventually.

As `port_map` is a wrapper around the command there are interesting issues that can arise. I use [Zsh](http://www.zsh.org/) as my shell along with a bunch of aliases it was necessary for `port_map` to support running commands that contain aliases. I recently moved to [zplug](https://zplug.sh/) as my Zsh plugin framework, where I encountered the following issue [zplug/zplug#209](https://github.com/zplug/zplug/issues/209).

One last inconvenience is that `port_map` is a RubyGem, which is effectively tied to a specific Ruby version. When dealing with multiple Ruby version projects using [rvm](https://rvm.io/)/[rbenv](http://rbenv.org/) sometimes `port_map` is not installed. It is a slight detour to install `port_map` for the current Ruby version when I switch to a new Ruby version. Ideally `port_map` would not be tied to Ruby, and instead is a transportable executable (for example one written in Bash or Go).

## The Future
I will continue to use `port_map` until I can spend some time to dig deeper into [Vagrant](https://www.vagrantup.com/) and [Docker](https://www.docker.com/). These two technologies isolate and containerize environments (web services). I can see the benefits in such technologies as they are not dependant on the host environment, which in my case is my laptop.

