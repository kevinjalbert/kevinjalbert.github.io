---
title: "Introducing notion-scripts"

description: "Building off of my previous Notion work using notion-py, I continue to adjust Notion to fit my needs. In this article, I want to explain how I've been taking my integrations with Notion to the next level."

tags:
- notion
- productivity
- tools

pull_image: "/images/2019-08-29-introducing-notion-scripts/code.png"
pull_image_attribution: "Source code snippets of [`notion-scripts`](https://github.com/kevinjalbert/notion-scripts/blob/3f999d1444d11128c946c5ba364e599b8fa1e72f/notionscripts/notion_api.py#L14-L48) and [`notion-heroku`](https://github.com/kevinjalbert/notion-heroku/blob/26d3712a2869b699cbcbf7691807dc9b2a5bc4dd/src/api.py#L10-L44)"
---

My [Notion [Referral]](https://www.notion.so/?r=6b8d609eb50943419db4d87c67fa558e) journey started with the creation of my [highly-tailored weekly template](/my-weekly-notion-setup/). I then made my first integration, [`alfred-notion`](https://github.com/kevinjalbert/alfred-notion), an [Alfred](https://www.alfredapp.com) workflow that allows me to issue quick commands to interact with Notion. Recently, I created [`notion-heroku`](https://github.com/kevinjalbert/notion-heroku), a web application that integrates Notion and [Google Assistant](https://assistant.google.com/) via [IFTTT](https://ifttt.com).

# Laying the Foundation

At this point, both of my Notion integrations share similarities with how I utilize [`notion-py`](https://github.com/jamalex/notion-py). I decided to lay down some foundational work that will accelerate and open additional capabilities in my existing and future projects with respect to Notion. The initial culmination of this work is [`notion-scripts`](https://github.com/kevinjalbert/notion-scripts), a Python package. I've extracted the commonalities between my two projects in an effort to [DRY (don't repeat yourself)](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself) the code up for better reuse.

My gameplan for `notion-scripts` is that it holds all the higher-level interactions that I do with Notion (i.e., add a task, find current day, update task status, etc...), as well as the underlying Notion API interactions via `notion-py`. Ultimately, my other applications shouldn't have to interact with `notion-py` anymore. If there is an opportunity for some functionality to live in more than one project, it will end up in `notion-scripts`.

# Background/Reactive Tasks for Notion

I've always wanted a way to run certain _processes_ reactively in Notion. I took what I have for `notion-heroku` and added the capabilities to run [recurring scheduled tasks](https://github.com/kevinjalbert/notion-heroku/blob/26d3712a2869b699cbcbf7691807dc9b2a5bc4dd/src/api.py#L11-L26).

Using recurring scheduled tasks, I added the ability to record task status changes reactively. My goal is so that when using Notion on my mobile device, task transitions will record automatically as this functionality is running on a server.

![](/images/2019-08-29-introducing-notion-scripts/recorded-transitions.png)

As mentioned earlier, I plan to continue to build on top of the work I've done so far. With respect to the transitions of a task, I'm hoping to add the ability to track the total time a task spent in each status. I'd also like to add email capabilities, so that I can get a daily/weekly email summary of tasks that are stale/stuck/new/completed.

_Note: I know that `notion-py` has callbacks for [subscribing to updates](https://github.com/jamalex/notion-py#example-subscribing-to-updates). For my use case, I have not yet explored this and instead went with polling to watch for changes. For `notion-heroku`, it would require a more substantial change, and the current design is stateless (i.e., run task, look at Notion, react) as Notion holds all the state itself. I might revisit this subject if need be._

# What's Next?

Having `notion-scripts` will help in some regard with the following ideas, as they will touch all my integrations and then some.

 - Having an interval notification on the desktop that tells me what my current task is.
 - Sending myself daily/weekly email reports of tasks/wins/lights from my template.
 - An approach to help with time blocking of tasks with my Google Calendar.

Don't forget to subscribe to the blog as I'll likely have a post with new changes. If you are interested in following the developments, you can also follow my projects on GitHub.
