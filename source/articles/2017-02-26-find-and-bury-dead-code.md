---
title: "Find and Bury Dead Code"

description: "Dead code has no reason to be in a project. Dead code wastes a developer’s time and energy. Going from this it makes sense to remove the dead code and put it rest with a delete keystroke. The main problem is how to identify dead code in a living project?"

tags:
- software
- software quality
- ruby
---

Dead code has no reason to be in a project. When you know it’s there, it simply nags at you to be removed. Sometimes you aren’t even sure that you have dead code. It might just be the case that every line of your codebase is being executed, which if true is great! The other scenario is that there is some dead code wasting developers’ time as they maintain it and work with it.
Going from this it makes sense to remove the dead code and put it rest with a delete keystroke. The main problem is how to identify dead code in a living project?

# Finding Dead Code

In smaller projects, it’s possible to simply see and know what is dead code just from the usage and familiarity you might have with the project. Within larger projects, identifying dead code is not as straight forward. Luckily, we have tools and systems that can aid us. For the most part, we will be looking at this problem from a dynamic language perspective, primarily Ruby.

## Static Analysis Tools

Static analysis tools do not run the application and only examine the source code itself. A general property of these tools is the speed and ease of use, although they come at a price of precision (i.e., missing and incorrect results). I’ll will first present a Ruby specific tool called **_debride_** and then a language agnostic tool called **_unused_**:

[**_debride_**](https://github.com/seattlerb/debride) -- This tool analyzes your Ruby source code and detects uncalled or dead methods. It knows of Ruby on Rails method definitions, as they are not defined in your codebase. In addition, you can provide a whitelist of methods that you know should not be flagged by the tool. This is a specific tool that is tailored to work on Ruby and Rails projects.

[**_unused_**](https://github.com/joshuaclayton/unused) -- This tool is language agnostic. It first requires a [_ctags_](http://ctags.sourceforge.net/) file for your project, containing all the project class/method definitions and their locations. With this, _unused_ is able to scan through your project using [_ag_](https://github.com/ggreer/the_silver_searcher) for statements calling these definitions. Throughout the search, if no usage of the class/method definition is found, then that code is probably unused. In addition, there is a configuration file for further customization to reduce false positives.

With both of these static analysis tools, there is a precision issue of whether or not the detected code is actually used during the execution of your project. This does not strum up immediate confidence in the results and often requires deeper investigation. Another large concern when dealing with dynamic language is class/method defined at runtime or methods that are invoked via meta programming.

## Dynamic Analysis Tools

Dynamic analysis tools, unlike their static counterparts, actually need to run the source code. A general property of these tools is that they provide richer and more accurate results, although at the cost of performance (i.e., slower due to measuring at runtime). I’ll present first a Ruby specific tool called **_coverband_** and then a language agnostic tool called **_scythe_**:

[**_coverband_**](https://github.com/danmayer/coverband) -- The approach that _coverband_ uses could be applied to other languages, although it is a Ruby specific implementation. This tool borrows the results format of test suite coverage (i.e., how much code is exercised by your test suite), however it measures code coverage during the runtime of your application. A nice use case that _coverband_ accounts for is multiple instances of your application, it uses a _redis_ instance to hold the coverage results. There is some performance cost for using _coverband_, as it records each line executed. If you are measuring a web application, the tool allows you to instrument a percentage of your requests. The coverage information keeps tracks of the number of times each line is hit, and this can indicate hot spots in your application.

[**_scythe_**](https://github.com/michaelfeathers/scythe) — The approach that _scythe_ uses is language agnostic. The basic idea is to place probes within your source code that when triggered, record the date and time to a file matching the probe’s  name. At its heart, _scythe_ is a command-line utility that reports on these files, giving you an indication of how long since the probe was last called. Currently, there are probe implementations for Java, Python and Ruby. Due to the simple contract (files which are updated when probes are triggered), it is not difficult to make _scythe_ work for other languages. The overhead using the probes is minimal and can be placed anywhere in your source code. Unfortunately, we have to use a manual process in placing and inspecting the probes.

Both of the above tools took different approaches for dead code identification. In either case, the underlying source code must be executed, and usually there is setup required for the tool to work in conjunction with the running application.

# Burying the Dead

Now that we know that there is a class of tools for detecting dead code, the next set of questions revolve around removing the dead code.

> The tool indicates this code is dead. Can we remove it?

Recall that static vs. dynamic analysis can inspire different levels of confidence. Tools like _scythe_ or _coverband_ actually determine whether the source code in question was executed in a real environment. The problem is whether or not the tool collected enough data during execution to ensure the code in question could have been ran. It is hard to know whether or not flagged dead code is just code that is rarely ran, but still alive.

With sufficient time, it should be possible to make the decision to remove the dead code. As with any change, be observant to any signals that could indicate that the removal was of live code. Given the complex scope of usage, it can be difficult to detect dead code if there are third parties using your codebase. A side bonus of removing dead code, is that any associated tests can be removed -- effectively speeding up your test suite.

# Moving on

By removing dead code the scale of the source code shrinks ever so slightly. There is little to no point in having extra code in your project if it does not add value. There is possible arguments that if it works, there is no need to change it. I would counter that by saying that keeping dead code around is lugging around a mental burden that developers have to deal with. Dead code wastes a developer’s time and energy. Imagine having to upgrade a dependency and making changes in dead code -- what a waste.

> Dead code wastes a developer’s time and energy.

Do be aware that there is some initial time investment in getting a system in place and learning how to identify dead code in your specific projects. In the long run, however, it is bound to save headaches in a long running project.

-----

# TL;DR

* Dead code is code that is never exercised during the execution of the application.
* Two types of tools exist for finding dead code: Static and Dynamic analysis tools
  * Dead code static analysis tools observe the source code and attempt to deduce methods that are never used.
  * Dead code dynamic analysis tools instrument the running state of the source code and record what is executed.
* Only remove dead code when you are confident that it is no longer used (deeper investigation and/or let dynamic analysis tools run for longer).
* Less code relieves mental burden, and reduces time wasted while working in a codebase.
