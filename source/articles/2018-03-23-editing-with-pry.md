---
title: "Editing with Pry"

description: "Learn to edit within a pry session. Experience the power of multi-line and patch editing."

tags:
- tools
- ruby
- pry

pull_image: "/images/2018-03-23-editing-with-pry/prybar-brush.jpg"
---

![](/images/2018-03-23-editing-with-pry/prybar-brush.jpg)
[Pry Bar & Wire Brush](https://flickr.com/photos/evilpics/16088956283 "Pry Bar & Wire Brush") by [Scott Hart](https://flickr.com/people/evilpics) is licensed under [CC BY-NC-ND](https://creativecommons.org/licenses/by-nc-nd/2.0/)

# Editing with Pry

I've already touched a bit on the power of `pry` in a [previous post back in 2016](/lets-pry-into-ruby-objects/). I want to revisit `pry` to expand on a new functionality that I have since started using -- its ability to edit.

## More than One Line?

In my personal experiences, I've constructed some _long_ one-liners while in `irb` or `pry`. These interactive sessions do not provide a great experience for multi line commands, as you are restricted to editing only one line at a time.

Fortunately, in `pry`, there is the `edit` method. This opens up a temporary file (`pry`'s input buffer) with a more capable editor for your task. You can configure the editor by executing the `Pry.config.editor = "vim"` statement, although your environment variable `EDITOR` is used by default. If you want, you can even use a GUI editor like [Atom](https://atom.io/) (you'll need to use `atom --wait` for this to work). If you have a specific preference, it make sense to add this configuration in your `.pryrc` so it is configured when `pry` loads up.

By default, `edit` will open the last executed statement issued in your session. If you want to edit with a blank canvas, then you can use the `edit -t` open a temporary buffer. You can even get fancy and re-edit older inputs using `edit --in <input-number>` (i.e., `edit --in -2` -- the second last input).

Using a full editor is great for those more complex statements. Now you can break up statements into multiple lines to make it easier to comprehend and create. In the event you were _slightly_ wrong, you can simply `edit` again and fix up your statement. This is great for iterativly building longer statements. It is a common style in Ruby to use indentation when using blocks and defining classes/methods/modules, so take advantage of `edit`.

The following demonstrates `pry`'s multi-line editing functionality.

<script src="https://asciinema.org/a/KjOsTASz7MMzrJV2lSxi6SWdM.js" id="asciicast-KjOsTASz7MMzrJV2lSxi6SWdM" async></script>

## Patching Objects

The `edit` method has one more amazing trick up its sleeve -- _patch editing_. `pry` now gives you the ability to modify existing object method definitions at runtime. To quote the help text for the `edit --patch`:

> _Instead of editing the object's file, try to edit in a tempfile and apply as a monkey patch_

As the patch is only for the `pry` session, there is a greater sense of exploring and less worry surrounding the commitment of the edit.

Some caveats that I've hit with this approach is that you can only patch `<class>#<method>` (instance method) or `<class>.<method>` (class method). You might want to edit the class itself, but you'll hit `NotImplementedError: Cannot yet patch #<Pry::WrappedModule:0x007fcc32afecd0> objects!`. Unfortunately, I've not yet found a nice way to get around this (so let me know if you have a way!). I know that you can modify the file itself (i.e., `edit app/models/model.rb`) but that'll actually write to the file -- I would want it done as a patch.

The following demonstrates `pry`'s patch editing functionality.

<script src="https://asciinema.org/a/0zvuYLvnQXHkZ9DpFZl4l3Sxe.js" id="asciicast-0zvuYLvnQXHkZ9DpFZl4l3Sxe" async></script>
