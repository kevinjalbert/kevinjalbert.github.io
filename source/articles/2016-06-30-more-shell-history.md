---
title: "More Shell History"

description: "Developers who use the terminal on a daily basis have a wealth of knowledge stored in their shell's history. It is not uncommon to need a lengthy command you used a while back. Thankfully shells provide a built in history and the functionality to _reverse search_ through it via ctrl-r."

tags:
- shell
- terminal
---

Developers who use the terminal on a daily basis have a wealth of knowledge stored in their shell's history. It is not uncommon to need a lengthy command you used a while back. Thankfully shells provide a built in history and the functionality to _reverse search_ through it via `ctrl-r`.

# Increasing History
First thing regardless of what shell try these commands and make note of their values:

```bash
echo $HISTSIZE
echo $SAVEHIST # or $HISTFILESIZE for bash
echo $HISTFILE
```

Across both zsh and bash these three environment variables determine the location and size of your shell history ([zsh guide on setting history up](http://zsh.sourceforge.net/Guide/zshguide02.html#l17)):

 * `HISTSIZE` indicates how many commands from your history file are loaded into the shell's memory
 * `SAVEHIST`/`HISTFILESIZE` indicates how many commands your history file can hold (you want this equal or larger than `HISTSIZE`)
 * `HISTFILE` indicates the history file itself which houses your previous commands

Its possible you might have already set some configurations related to the shell's history, or maybe a plugin has set it for you like [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh/blob/master/lib/history.zsh#L2-L7). You should be aware of your history file and its size at the very least. This would also be a great opportunity to change it if you have not yet.

In the default zsh configuration only `HISTSIZE` is set, and it is tiny at only 30. No history file it set, which means no history is persisted. Default bash configuration has defaults history file and sizes of 500. Both of these are both small with respect to the amount of commands one might use.

Recall that the effective reverse search (`ctrl-r`) is based off of what is in your history. You don't really want to lose anything right? So set something high!

```bash
# In your ~/.bashrc
export HISTSIZE=100000
export HISTFILESIZE=100000

# In your ~/.zshrc
export HISTSIZE=100000
export HISTFILESIZE=100000
export HISTFILE=~/.zhistory # Don't forget to to set this also
```

From what I've witnessed the major downside to a large history is pretty negligible. When the shell starts it'll read in your history file and store an amount defined by `$HISTSIZE` in memory. More history simply means slower shell startup, although it is not that significant. In addition there might be some shell plugins which reach into your history, these can also cause slow downs (i.e., [zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search) significantly slows down with a large history).

# Cleaning History
Now we have a larger history, which by itself is a huge win. Now we want a _cleaner_ history if possible. The main benefit of a cleaner history is that stepping through your history with UP and DOWN keys will not show duplicates.

```bash
# In your ~/.bashrc
export HISTCONTROL=ignoredups

# In your ~/.zshrc
setopt HIST_FIND_NO_DUPS
```

If you wanted you could go even further and actually prevent duplicates from being saved in your history file with the following:

```bash
# In your ~/.bashrc
export HISTCONTROL=erasedups

# In your ~/.zshrc
setopt HIST_IGNORE_ALL_DUPS
```

# Sharing History
If you end up using multiple shells at a time (i.e., opening multiple zsh or bash), you might want to _share history_ between them. By default the history files are written when the shell closes. With the following you can allow the shells to write and read from the history file after each command:

```bash
# In your ~/.bashrc
shopt -s histappend
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# In your ~/.zshrc
setopt inc_append_history
setopt share_history
```

# Putting it Together -- TL;DR
If you want more history use the following:

```bash
# In your ~/.bashrc
export HISTSIZE=100000
export HISTFILESIZE=100000

export HISTCONTROL=ignoredups

shopt -s histappend
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# In your ~/.zshrc
export HISTSIZE=100000
export HISTFILESIZE=100000
export HISTFILE=~/.zhistory

setopt HIST_FIND_NO_DUPS

setopt inc_append_history
setopt share_history
```
