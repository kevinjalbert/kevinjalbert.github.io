---
title: "Custom Notion iOS Widget"

description: "Notion has recently released iOS widgets, however, they are limited in functionality. In this article, I present my custom Notion iOS widget that has a unique set of features. This widget is built using iOS Shortcuts, the Scriptable application, and a notion-py server."

tags:
- ios
- tools
- notion

pull_image: "/images/2020-11-28-custom-notion-ios-widget/phone-widget.jpg"
pull_image_attribution: 'Photo of my iPhone 11 showing my custom Notion iOS widget'
---

# The Offical Notion Widget

On [November 22 of 2020, Notion released their iOS widgets](https://www.notion.so/What-s-New-157765353f2c4705bd45474e5ba8b46c#a2dc9af353a746cabaf436fdfaeca4a7). This was a great step forward for the [Notion iOS application](https://apps.apple.com/app/notion-notes-tasks-wikis/id1232780281) as iOS 14 had just released support for widgets in September.

They offered the following three widgets (as quoted from their widget descriptions):

- Page: Get quick access to one of your Notion pages
- Favorites: Get quick access to your Notion favorites
- Recents: Get quick access to recently viewed pages in Notion

# My Unofficial Notion Widget

I've been working on my own custom Notion iOS widget since October before it was known that official widgets were coming out. I was pleasantly surprised that their widgets haven't made my custom widget obsolete, as the functionality is unique.

The following video provides a demo of my widget in action, as well as explaining a bit about how it was made.

<iframe class="youtube-embed" src="https://www.youtube.com/embed/atq6u7Le1JE" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

The following technologies were used to make this all possible:

  - API server using [`notion-py`](https://github.com/jamalex/notion-py)
  - [iOS Shortcuts](https://support.apple.com/en-ca/guide/shortcuts/welcome/ios)
  - [Scriptable](https://scriptable.app/) iOS application

If you are more interested in the technicals or would like to set up your own widget, you can look at the [`ios_widget` tool](https://github.com/kevinjalbert/notion-toolbox/tree/master/ios_widget) within my [`notion-toolbox` GitHub Repository](https://github.com/kevinjalbert/notion-toolbox).

It's worth noting that there are plenty of rough edges in this implementation as of its initial release, and it does require a lot of setup investment. In addition, if/when Notion decides to up their widget game, my custom solution might become obsolete. There are also concerns surrounding the upcoming offical Notion API, as I'm currently using the unofficial one (which can, in theory, break without notice). I'll be curious how I can adapt my widget to use the official API in the future.
