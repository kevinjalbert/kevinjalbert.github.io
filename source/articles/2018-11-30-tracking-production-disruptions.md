---
title: "Tracking Production Disruptions"

description: "When operating software in a production environment it is expected to have some unplanned disruptions over time. While the primary task is to resolve the disruption so that the impact is minimized, it is still very much important to track the disruption itself. Disruption reports provide transparency to others, accountability in the actionable tasks, a place for discussion, categorical data, and also a summary of the event."

tags:
- communication
- process
- tools

pull_image: "/images/2018-11-30-tracking-production-disruptions/stack.jpg"
pull_image_attribution: '[stack](https://flickr.com/photos/striatic/443918201 "stack") by [striatic](https://flickr.com/people/striatic) is licensed under [CC BY](https://creativecommons.org/licenses/by/2.0/)'
---

Let us first iron out what constitutes a _disruption_:

> Any unexpected degradation or interruption of a service that in any method affects users ability to the service.

When operating a production service, it is simply a matter of time till a disruptions _happens_. No matter the safeguards you've put in place, there is always the expected scenarios. There are many ways to prepare and to ensure that your services are as robust as possible, but that is a task left to you the reader. In this post I'll be talking about what to do _after_ you've handled a production disruption.

# Why Track?

A disruption can be a chaotic event, lasting from a few minutes to multiple hours. The main purpose of tracking these disruptions is to have a better understanding of:

- what led to the issue.
- what could have been done to prevent the issue from happening?
- flaws in monitoring in detecting when the issue started.
- learnings and processes when dealing with a similar issue in the future.

I highly encourage disseminating the learnings around all aspects of a disruption to the rest of the team and organization. A tracked disruption can be used in a post-mortem. The ultimate goal is by educating everyone it will lead to more resilient services and better processes during the inevitable future disruptions.

In addition, with tracked disruptions, it becomes easy to perform basic analysis of the frequency and length of disruptions.

Without any tracking, it becomes a huge failure if the same disruption happens again over and over.

# Tracking

One thing to note is that the following is from experience that I have working at [theScore](http://company.thescore.com/), along with reading various sources online. Let us touch on what to track, where to track, and how to track.

## What to Track?

The more information you have the better you'll understand the disruption if you weren't immediately involved in it. Additionally, in most cases, multiple people are involved and so not everyone had the same exposure to the entire event. The following is a list and description of what we track at theScore for disruptions.

- **Service(s)**: name of service(s) that were interrupted.
- **Disruption Meta-Information**: at-a-glance information about the disruption.
   - **Type**: what type of disruption (i.e., Infrastructure, Critical Bug, Data Provider, etc...).
   - **Start Time**: when the disruption started (not necessarily when it was discovered).
   - **Detection Time**: when the disruption was detected by users/support/team.
   - **End Time**: when the disruption was resolved (action items may extend past this time).
   - **Length**: the total time the disruption was active (based on start/end times).
   - **Time to Detection**: time to detect the disruption (based on start/detection times).
   - **People Involved**: list of individuals involved in handling the disruption.
- **Summary**: a high-level summary of the disruption (root cause and impact).
- **Timeline**: a table of events which constructs the timeline of the disruption.
  - **Timestamp**: approximate time of this event.
  - **Party Involved**: who/what was involved with this event (i.e., servers, people, services).
  - **Description**: what happened at this event.
- **Retrospective**: a reflection of the disruption used for learnings.
  - **Good**: what went well (i.e., process, safeguards, etc...).
  - **Bad**: what went poorly (i.e., process, cascading failures, etc...).
  - **Lessons**: what was learned (i.e., flaws in the process, missing monitoring, etc...).
  - **Action Items**: assigned items to be completed in a timely fashion related to the disruption.
- **Supporting Documentation**: additional information (i.e., Slack Logs, Bug Reports, Screenshots, etc...).

## Where to Track?

To be honest, the none of this matters matter if you aren't tracking disruptions to any capacity, just do it! Even if you have all your disruptions in a single text file, it's better than nothing. Let's get realistic though, we can do much better. For starters, you could opt for a spreadsheet or a basic database, maybe even a heavier integrated service like [VictorOps](https://victorops.com/).

At theScore, we use a GitHub repository where each _issue_ is a disruption report. We record the aforementioned data points in each issue's description. We decided to use GitHub as it:

- Has great markdown support to provide rich information (i.e., font-styles, links, images, tables).
- Gives us closer integration with our code if we want to link to resources in other repositories.
- Has built-in support for comments on an issue to better facilitate discussions.
- Has labels and open/close states for issues, which layers in additional categorization and grouping.
- Has an API to interface with (for automation and analysis).

For us, our action items become [GitHub tasks](https://help.github.com/articles/about-task-lists/) with a mentioned individual or team. Issues are to be closed when all action items are resolved, and after sufficient discussion/retrospection has been carried out.

## How to Track?

After a disruption, within a few days, it should be tracked. Waiting too long to track a disruption will result in fuzzy/shallow details. There much special in building up the report, although from personal experience it is good for people to jot notes down immediately after a disruption. I also find it effective to create a specific channel or chatroom in your team's messaging application when dealing with disruptions as all the communication is located in one area.

PagerDuty has some fantastic material on a [post-mortem process](https://response.pagerduty.com/after/post_mortem_process/) and even a [post-mortem template](https://response.pagerduty.com/after/post_mortem_template/). They also document [defined roles during a disruption](https://response.pagerduty.com/before/different_roles/), in which the _Scribe_ is a critical role for tracking purposes.

A disruption report can be a single person's responsibility, although it usually helps to reach out to the people involved for clarifying details.

# Making Sense of the Data

With all these disruptions tracked, what can we do with them? Hopefully, all the action items and retrospection have led to large gains. Additionally, there is a lot of value in the data itself, it is simply a matter of finding the signals you want to pay attention too. For example:

- The frequency of disruptions (per service).
  - What services to focus on improving resilience.
- Distribution of when disruptions happen.
  - When to be prepared (i.e., weekend/evenings) for possible on-call resolution.
- Time to detection over time.
  - Are the improvements being made to monitoring helping out?
- etc...

Find aspects that your organization cares about and measure them.

# Improving the Process

Never stop and periodically revisit the process to make adjustments. What works for one team, might not work for others. Even though tracking a disruption can be seen as _additional_ work, it will pay itself off in time.
