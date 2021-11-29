---
title: "Global Hotkeys using the Hyper Key"

description: "Set up a hyper key and global hotkeys to quickly perform actions regardless of where you are. This will save you keystrokes and/or time spent moving the mouse cursor."

tags:
- productivity
- MacOS

pull_image: "/images/2021-11-28-global-hotkeys-using-the-hyper-key/alfred-shortcuts.png"
pull_image_attribution: "My Alfred Workflow that holds my global hotkeys to open applications, also showing the hyper key setup via Karabiner-Elements."
---
My keyboard sees a lot of use, and where possible I try not to reach for the mouse/trackpad. I find I can work more efficiently by keeping my hands on the keyboard, which is a great thing as a developer.

My primary usage of the hyper key is to open/hide applications with global hotkeys. The hyper key is great because no application expects you to hold all modifier keys at the same time, which sets it up perfectly for a global hotkey.

## Setup

This does require a bit of setup to make it work, but the payoff is pretty nice as you'll be saving keystrokes and/or mouse/trackpad movements.

This is tailored to a MacOS system...although I wouldn't be surprised if you could find alternatives for a Linux or Windows environment.

## The Hyper Key

> A Hyper Key is a magical key that automatically presses all the standard modifiers (ctrl+shift+cmd+opt).
>
> -- [BetterTouchTool's documentation on the hyper key](https://docs.folivora.ai/docs/1004_hyper_key.html)

I first heard about the _hyper key_ from an [article Steve Losh wrote](https://stevelosh.com/blog/2012/10/a-modern-space-cadet/#s14-hyper) which touched on the subject. This inspired me to look at how I could use this new modifier key.

I personally use Karabiner-Elements to enable a hyper key, but any of the following should do the trick.

  - [Karabiner-Elements](https://karabiner-elements.pqrs.org/)
  - [BetterTouchTool](https://www.folivora.ai/)
  - [Hyperkey App](https://hyperkey.app/)
  - [Hammerspoon](https://kalis.me/setup-hyper-key-hammerspoon-macos/)

## Global Hotkeys in Alfred

I use [Alfred](https://www.alfredapp.com/) extensively. I made a new workflow that has multiple hotkey triggers that use the hyper key in combination with a single character. This allows the hotkey triggers to perform an action.

The one thing that you _need_ to do is ensure that the trigger's behaviour is set to _"Pass through modifier keys (Fastest)"_ (as illustrated in the following image), otherwise, there will be a slight delay in the action being performed.

![](/images/2021-11-28-global-hotkeys-using-the-hyper-key/alfred-trigger-config.png)

I have several combinations which open/hide various applications:

  - `hyper + space` -- Opens [iTerm2](https://iterm2.com/)
  - `hyper + o` -- Opens [Obsidian](https://obsidian.md/)
  - `hyper + c` -- Opens [VS Code](https://code.visualstudio.com/)
  - `hyper + s` -- Opens [Spark](https://sparkmailapp.com/)
  - `hyper + b` -- Opens [Google Chrome](https://www.google.com/chrome/)

## Global Hotkeys in other Applications

Hyper key shortcuts work well to access other applications in a global context. I even use them to open the quick add modal for [GoodTask](https://goodtaskapp.com/) via `hyper + '`. Another example of where I use it is with [Hammerspoon](http://www.hammerspoon.org/) via `hyper + \` to open _[anycomplete](https://github.com/nathancahill/Anycomplete)_ to help with spelling complicated words.

When you have the hyper key, anything can be globally reachable via a simple key combination!
