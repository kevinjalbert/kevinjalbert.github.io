---
title: "Integrating Notion with Google Assistant"

description: "I want to share how I integrate my Weekly Notion Setup with Google Assistant. It provides a ubiquitous way to interact with Notion. In particular, this solution opens up new ways to add notes and tasks in Notion via voice commands."

tags:
- notion
- google assistant
- productivity
- tools

pull_image: "/images/2019-07-15-integrating-notion-with-google-assistant/ifttt-and-repo.png"
pull_image_attribution: 'My Google Assistant IFTTT Applets alongside the `notion-heroku` GitHub repository'
---

Building off two of my previous posts ([My Weekly Notion Setup](/my-weekly-notion-setup/) and [Integrating Notion with Alfred](/integrating-notion-with-alfred/)), I decided to further integrate [Notion [Referral]](https://www.notion.so/?r=6b8d609eb50943419db4d87c67fa558e) with [Google Assistant](https://assistant.google.com/).

Google Assistant is never too far away from me. I almost always have my phone within arms reach, and I also have multiple Google devices throughout my house. In the past, I've used other productivity applications in conjunction with Google Assistant (i.e., [Evernote](https://help.evernote.com/hc/en-us/articles/360000930107-How-to-use-Google-Assistant-with-Evernote), and [Todoist](https://get.todoist.help/hc/en-us/articles/115000056165-How-can-I-use-Todoist-with-Google-Assistant-)) to capture notes and tasks. With my recent commitment to Notion, I've been missing this integration.

# The Goal

The 2 main requirements I'm looking for here are:

1. Ability to dictate notes that are appended to my _Notes_ section under the current day.
2. Ability to dictate a new task that gets added to my _Tasks_ database.

I would also like the end solution to be one that is extensible and can grow with my template and use cases.

# The Journey

At the time of writing, no official API has been released for Notion. For a previous project, I was able to create [`alfred-notion`](https://github.com/kevinjalbert/alfred-notion) using an unofficial API client called [`notion-py`](https://github.com/jamalex/notion-py) to much success. To be honest, I suspect the official API to likely be restrictive to some degree, although only time will tell. In either case, using this API client gives me great flexibility in what can be done in Notion.

I've been successful in hooking Google Assistant into other application via the [IFTTT](https://ifttt.com) platform and naturally gravitate to this free solution.

The next piece of this solution is being able to execute custom code based on an action from the Google Assistant trigger on IFTTT. Fortunately, IFTTT has the capabilities to perform HTTP requests in response to a trigger. Thus, my end-goal solution requires a server to run my custom code, which uses `notion-py`.

I decided to reach for [Heroku](https://heroku.com/) as they have a pretty offering that allows you to run an application for free (within limits).

# The Reward

> [Click to watch a video summarizing integration and demonstrating how it works](https://www.youtube.com/watch?v=z8SgCwrci5I)

I've put together [`notion-heroku`](https://github.com/kevinjalbert/notion-heroku), a GitHub repository, a Heroku application that performs Notion actions based on voice requests via [IFTTT Webhooks](https://ifttt.com/maker_webhooks) and [Google Assistant](https://ifttt.com/google_assistant). I've put together easy-to-follow instructions that can help others open up integrations like this for themselves.

> [Click to check out `notion-heroku`](https://github.com/kevinjalbert/notion-heroku)

**NOTE:** [v1.0.0](https://github.com/kevinjalbert/notion-heroku/tree/v1.0.0) is current at the time of publication (July 15, 2019).

# The Future

Running the application on Heroku (or any server to be honest) opens up new opportunities. For example, it would be entirely possible to have something run periodically or on a schedule. I can also continue to iterate and add to and improve the integration with Google Assistant (i.e., new endpoints that run Notion commands on my behalf).
