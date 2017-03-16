---
title: "Keep on Learning, but don't Forget to Remember"

description: "As developers we are constantly learning tips, tricks and new ways to accomplish our work. We continue to accumulate these tips daily, but at the same time we potentially forget the less used but relevant ones. A system is presented that ensures that these tips are remembered."

tags:
- self-improvement
- shell
---

Learning is a way of life for a developer. Frequently we are exposed to techniques and tips such as: keybindings, shell commands, utilities, new functions/methods, new applications. While learning, we want to keep on remembering the previous techniques and tips that we've learned so that we can keep them _fresh_ and on our tool belt. It is not uncommon to forget some learned knowledge if you don't use it often.

I would like to present my own problem and solution surrounding this idea.

## Problem: Customization of vim/zsh
Vim and zsh are my editor and shell of choice, both decisions I made early in my career. I have since spent countless hours using both and each are indispensable to my development process. As typical of any developer I am always looking for ways to improve my process. Near the beginning of my career I discovered that both [vim](http://vimawesome.com/) and [zsh](https://github.com/unixorn/awesome-zsh-plugins) have thriving plugin communities.

I saw that there were [popular](https://github.com/spf13/spf13-vim) vim [distributions](https://github.com/carlhuda/janus) that come pre-packaged with opinionated set of keybindings, plugins and themes. I originally used one of these and immediately felt overwhelmed with the added functionality. I eventually came to terms with the error of my ways, and went back to vanilla vim. Learning from my mistake I decided to slowly incorporate features I felt were useful as I came to need them.

I continue to stumble upon new plugins that simplifies tasks. I add custom keybindings to perform certain motions. I create custom vim functions. While observing colleagues I take mental notes of vim motions that I have yet to take advantage of. I occasionally look through my setup and notice features and keybindings that I have not used in a while. Sometimes I remove them, but other times I'll keep it and make a try and use it.

My use of zsh is nearly an identical story to that of my use with vim. In either case I routinely accumulate and pruning tips that I find useful. My largest gripe is _forgetting_ about new tips that I want to make part of my normal tool set. In most cases these have yet to become habit and common knowledge to me through repetitive exposure and use.

## Solution
I decided to write my accumulation of tips down as one-liners in `tips.txt` files, while using directories under `~/.tips` for categorization:

```
~/.tips❯ tree
.
├── ruby
│   └── rspec
│       └── tips.txt
├── vim
│   ├── plugins
│   │   ├── ctrlp
│   │   │   └── tips.txt
│   │   └── nerdtree
│   │       └── tips.txt
│   └── vanilla
│       └── tips.txt
└── zsh
    └── tips.txt
```

Ultimately my goal is to be presented with a random tip when I open a new shell. To accomplish this the following code snippet is placed near the start of my `.zshrc` (also works in a `.bashrc`):

```
# Displays a random tip from the .tips directory when opening the shell
# Requires gshuf (brew install coreutils)
(
  TIP_PATH=$(find ~/.tips -type f -name tips.txt | gshuf -n1)    # Pick a random tips.txt file
  TIP_TILE=${TIP_PATH#"$HOME/.tips/"}                            # i.e., ~/.tips/vim/vanilla/tips.txt  --->  vim/vanilla/tips.txt
  echo "From ${TIP_TILE%.txt}:"                                  # i.e., "From vim/vanilla/tips:"
  gshuf -n1 < "$TIP_PATH"                                        # Displays a random line from the tip file
)
```

Now throughout the day when I open many new shells, I am presented with a random recorded tip:

```
From vim/plugins/nerdtree/tips:
`<f2>` toggles nerdtree open/close
~/.tips❯
```

```
From zsh/tips:
`j` allows you to jump to marked directories (via `jump`)
~/.tips❯
```

## Don't Forget to Remember
As I continue to learn new things I'll be added them to the appropriate `tips.txt` within my `.tips` directory. If I am presented with a tip that is no longer relevant I can simply remove it. Overall this seems like a great solution for recollecting tips.
