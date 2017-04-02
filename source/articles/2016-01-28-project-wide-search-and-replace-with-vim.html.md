---
title: "Project-Wide Search and Replace with Vim"

description: "There are many instances where you might want to perform a mass search and replace in Vim. The following are two commands that can help out with such a task."

tags:
- vim
---

There are many instances where you might want to perform a mass search and replace in Vim. The following are two commands that can help out with such a task.

# List of Files
First you need to acquire a list of files in which you want to perform search and replaces on. The following Vim command `args` allows you to store a set of file names to act on later.

    :args `<command which generates a file list>`

Thus we can use the following to store a list of files which match the `'Base::Lol::' .` pattern.

    :args `ag -l 'Base::Lol::' .`

If matches were not found you'll get back something like the following *E79: Cannot expand wildcards*. If at least one match was found the current buffer will change to one of the found files.

# Act on Files
Now that you have the list of files that you want to act on, we are ready to perform our search and replace on them. The following Vim command `argdo` allows us to specify a command to run against each of the files stored from the `args` command.

    :argdo <command to perform on each file stored from args>

In our running example we can replace every instance of the search we performed with a new string. We use the `%s` command to perform this substitution (`%s/<original>/<new>`). The `/g` specifies that this substitution should be applied globally to the file. Finally we have ` | w` which saves the file after the substitution has been applied.

    :argdo %s/Base::Lol::/Lol::Base::/g | w

You are not only restricted to to using substitution here. Other resources indicated using macros.
