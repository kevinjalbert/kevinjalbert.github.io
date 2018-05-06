---
title: "iTerm2 Mouseless Copy"

description: "Learn how to keep your hands on the keyboard, and accomplish mouseless selection and copying in iTerm2. We explore the find and copy approach, along with iTerm2's copy mode."

tags:
- tools
- iterm2
- productivity

pull_image: "/images/2018-05-06-iterm2-mouseless-copy/keyboard-with-mouse.jpg"
---

![](/images/2018-05-06-iterm2-mouseless-copy/keyboard-with-mouse.jpg)
[3D printed mouse](https://flickr.com/photos/creative_tools/8573767153 "3D printed mouse") by [Creative Tools](https://flickr.com/people/creative_tools) is licensed under [CC BY](https://creativecommons.org/licenses/by/2.0/)

# iTerm2 Mouseless Copy

Where possible, I try to avoid using the mouse. I heavily use [Vim](https://www.vim.org/) while editing which allows for keyboard navigation. I have taken such a liking to the Vim keyboard-bindings that I even use  [Vimium (a Google Chrome extension)](https://chrome.google.com/webstore/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb?hl=en) for keyboard-driven navigation in my browser (for as much as I can). In addition, I use [BetterSnapTool](https://itunes.apple.com/ca/app/bettersnaptool/id417375580) for MacOS, which allows me to move/resize windows around solely from my keyboard.

One optimization within my terminal that I have been avoiding is [tmux](https://github.com/tmux/tmux) -- it is unnecessarily complicated for what I need. For the most part, I am able to use [iTerm2](https://www.iterm2.com/) to open tabs, split panes and navigate around. To be honest, I don't really need the session keeping functionality that tmux or [screen](http://www.gnu.org/software/screen/) provided. The big gain I was missing from tmux was the famed [copy mode](https://minimul.com/increased-developer-productivity-with-tmux-part-8.html).

A quick snippet from [iTerm2's documentation of highlights](https://www.iterm2.com/documentation-highlights.html) for text selection:

> - You can use the mouse.
> - You can use the find feature's "mouseless copy" feature.
> - You can use Copy Mode.

The first one we're not interested in as it's the _standard_ way to select and copy text. We will cover others two in the sections that follow.

## Find and Copy

So one approach to copying anything within the iTerm2's session is to use the default _search_. It is an interesting approach, to say the least:

![](/images/2018-05-06-iterm2-mouseless-copy/search-copy.gif)

Essentially, you initiate the search with _cmd+f_ and you can use the _enter_ and _tab_ to move your selection around and to control how much of the text you want in your selection. It works in a pinch, but if you mess up the amount of text in your selection, you basically have to restart the process. In addition, I found the _shift+tab_ command cycled the selected search result, leading to some confusion.

To be honest, I don't use this search copying approach very often. I find it difficult to get right, as you cannot really afford any mistakes. The following is a summary of this approach:

- Searching for some text using _cmd+f_.
- Use _enter_ to move to the next search result.
- Use _shift+enter_ to move to the previous search result.
- Navigate until you are on the desired location.
- Use _tab_ to expand your search to the next word.
- Use _shift+tab_ to expand your search to the previous word.
  - Although it moves to the previous search result if one exists.
- When your search term is selected, use _cmd+c_ to copy the selection.
- Use _esc_ to exit search, and now you have the selection in your clipboard.

## Copy Mode

This iTerm2 mode attempts to emulate as much of the tmux copy mode as possible, allowing you to make text selections using the keyboard. It is a _mode_ very much like Vim's _insert_ and _normal_ modes. It is important to note that the session within the pane will stop updating when you enter copy mode.

![](/images/2018-05-06-iterm2-mouseless-copy/copy-mode.gif)

I highly recommend reading the [documentation on iTerm2's copy mode](https://www.iterm2.com/documentation-copymode.html) as it completely covers the keyboard shortcuts and features. Copy mode, in my opinion, is the superior of the two approaches for mouseless copying. I highly recommend giving it a shot the next time you reach for your mouse. The following is a quick summary of copy mode:

- Enter copy mode with _cmd+shift+c_.
- Basic Vim keybinding, many keystrokes can active different actions.
  - _v_ to select by character.
  - _shift+v_ to select by line.
  - _ctrl+v_ for rectangular selection.
  - _ctrl+space_ to stop selecting.
  - _y_ to yank/copy the selection (also exits copy mode).
  - _q_ to exit copy mode.
- Can chain off of iTerm2's search feature.
