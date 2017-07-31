---
title: "Knowledge and Screencast Culture"

description: "As a developer, I routinely share my knowledge and experiences, however I find that I repeat myself with different individuals. To overcome this, I present a knowledge repository using screencasts for persisted and asynchronous knowledge transfer."

tags:
- communication
- learning
- culture

pull_image: "/images/2017-07-30-knowledge-and-screencast-culture/movie-camera.jpg"
---

![](/images/2017-07-30-knowledge-and-screencast-culture/movie-camera.jpg)
_[Vintage Filmo Auto Master 8mm Movie Camera](https://flic.kr/p/jxJiU9) by [Joe Haupt](https://www.flickr.com/photos/51764518@N02/), on Flickr_

# Leaking Knowledge

I try my best to teach and impart knowledge to my peers. This is actually one reason why I blog -- to record and teach others from my experiences. While working at theScore, I attempt to [share my bag of tricks](/share-your-bag-of-tricks/) to the best of my ability. I found during my tenure that my colleagues would occasionally:

 * ask what application/tool I just used
 * ask what hotkey/shortcut I just pressed
 * ask me how something works
 * ask me to explain a subject in deeper depth
 * comment on something they just learned from me

I like to share information, tips and tricks. I came up with a rather simple idea and recently put it into practice at theScore. The whole point of this is to not just _leak_ knowledge but to directly share it.

# Sharing and Don't Repeat Yourself

There are those moments when a colleague of mine got value out of something I showed and/or explained to them. I like to capitalize on these moments, as I figured there are other people who would gain similar value if they were also there. Unfortunately, it's not often that I am surrounded by _everyone_ when these moments happen (we're all busy doing our own things).

I've noticed that I would be sharing similar tips when I pair or talk with another coworker. In retrospect, I'm repeating myself while slowly spreading enlightenment. As a developer I can see the pattern I'm following, and by my nature I want to automate or DRY (Don't Repeat Yourself) things up. To overcome this hurdle I decided to come up with a more direct and permanent solution to disseminate my experience across the organization.

# Knowledge Repository

I approach most things from a developer's mindset. I love using GitHub and that is the platform theScore uses for its day to day operations on the engineering side. I created a _knowledge_ repository with the following in its README:

> ## Knowledge

> We are always learning new things to help us work more efficiently and effectively. To help share this knowledge, we informally tell our team, or certain individuals. Eventually, we might have a presentation to a wider audience, which often is still a subset of our engineering department. In many cases, the information shared using these deliver mechanisms are not reviewable, and might not reach everyone who may benefit from it.

> Doing formal presentation can be nerve racking for the presenter, and time consuming for everyone. The idea for this repository is to make everything as informal and async as possible. The goal is to take advantage of screenrecording/screencasting technologies for delivery and storage of information along with GitHub's pull requests to facilitate discussion.

> ## What can be shared?

> Anything! This repository helps promote individuals to share even the smallest tidbit of knowledge that they feel is worth sharing. It could be even a 30 seconds editor trick. Without having any restrictions, the hope is that the friction to share something to a wider audience is minimal, also to help encourage sharing what one might not feel is important enough to have a formal presentation for.

My idea was have a communal place to share and consume knowlege in an asynchronous environment. The README is treated as a living document and will adjust and improve over time.

I am continuously learning new things, and others have plenty to teach. This approach will create an environment for learning for not only myself, but for everyone.

# Screencast All the Things

As you might have read in the README snippet, the preferred medium to use is screenrecording/screencasting technologies for delivery and storage. So in essence, you would create a screencast for anything that could provide value to someone and that you don't want to repeat. There are broad criteria of what to screencast, but in that respect I think it'll work out quite well in the long run.

There is quite an art to doing screencasts well, and I am just getting my feet wet. I'm still working on my presentation delivery as I generally don't do much preperation before recording. As for tools I'm currently using:

* [Monosnap](https://monosnap.com) for the screenrecording software (for MacOS and Windows)
* [KeyCastr](https://github.com/keycastr/keycastr) for visualizing my keystrokes (for MacOS)

At theScore I download the recorded video and upload it to our internal Google Drive and link that in the GitHub Pull Request. I am tempted to just leave them on Monosnap's built-in hosting service if there is no sensitive information within the video. To demonstrate my setup I've recorded a [quick screencast](https://monosnap.com/file/y53Rg1cvLJpT214tHz7erWDM9HgOik).

# Screencast Culture

The _knowledge_ repository is still a new concept at theScore, although I have high hopes for it. The more that people contribute to it, the more useful it'll become. With a wide range of topics and data within it, there are bound to be new learning materials for each individual. The challenge is getting people to be aware of it as well as contribute to it. I'm still working out how best to approach this challenge.
