---
title: "Automating Slack Statuses for Meetings and Focus Time"

description: "Slack statuses can be a powerful communication tool for setting up expectations on response times. Using Zapier we look at how we can automate Slack statuses for meetings and focus times."

tags:
- communication
- productivity
- tools

pull_image: "/images/2018-10-30-automating-slack-statuses-for-meetings-and-focus-times/headphones-busy.jpg"
pull_image_attribution: '[(79/365) Busy](https://flickr.com/photos/34233222@N05/3777507641 "(79/365) Busy") by [Finding Josephine](https://flickr.com/people/34233222@N05) is licensed under [CC BY](https://creativecommons.org/licenses/by/2.0/)'
---

I use Slack statuses to communicate my _availability to respond_ to messages and to set up _expectations of my focus for a conversation_. In an office setting, colleagues are able to see whether I'm at my desk or not, and that conveys to a certain degree how responsive I might be to messages. I work remotely a few times each week, and on those days my colleagues have even less visibility on whether I would be available or in a meeting.

I've come up with a solution for two places where I can automate my Slack status to better communicate expectations and context. Hopefully, these changes will lead to fewer distractions and less ticked off colleagues.

# Automating Slack Status for Meetings

I want to increase transparency in my response times (and set expectations for my colleagues) by updating my Slack status if I'm in a meeting. With Slack's recent feature to [auto-expire statuses](https://www.theverge.com/2018/8/30/17802308/slack-auto-expiring-status-updates-feature-change), a clean solution using [Zapier](https://zapier.com/) was possible.

The following three steps will outline the _Zap_ I use to automatically update my Slack status with a meeting status.

## Google Calendar - Event Start Trigger

![](/images/2018-10-30-automating-slack-statuses-for-meetings-and-focus-times/meeting-google-calendar-step.jpg)

I use the _Google Calendar Event Start_ as our trigger, specifying the calendar where all my meetings are set within. I also set the _Time Before_ value to 16 minutes as I'm not subscribed to a high premium plan.

## Zapier - Delay Until Action

![](/images/2018-10-30-automating-slack-statuses-for-meetings-and-focus-times/meeting-delay-step.jpg)

I want to delay the next step (setting the status) until the actual event starts. This is needed due to how the previous step works, as it might trigger up to 16 minutes earlier than the meeting start time.

## Slack - Set Status Action

![](/images/2018-10-30-automating-slack-statuses-for-meetings-and-focus-times/meeting-slack-step.jpg)

I update the Slack status with information on when I will be done my meeting, as well as provide a clear status emoji. With the expiration time field, the status is cleared after the meeting is completed.

## Possible Issue Due to Multi-Step Zap

I have been a user of Zapier for a while, and somehow I have the ability to make _3-step Zaps_ with the free plan. It is possible to cut the _Delay Until_ step, but there is a possibility of the _Set Status_ step running a maximum of 16 minutes earlier than the event's start time.

You could possibly mitigate this with some clever status text (i.e., "Meeting from 3:15 to 3:45"). At worse you have a meeting status _slightly_ before your meeting, which might not be a bad idea as you might be busy preparing or in-transit to a meeting room.

# Automating Slack Status For Focus Time

Another place I automate Slack statuses is for focus time. While at work, there are times I need a deep focus time (i.e., being in the _zone_). I use [PomoDoneApp](https://pomodoneapp.com/) as my [Pomodoro](https://francescocirillo.com/pages/pomodoro-technique) application of choice. Fortunately for me, it also interfaces with Zapier.

The goal here is for colleagues to know that I'm busy and might not get back to their messages until I have a break from my deep work.

## PomoDoneApp - New Timer Started Trigger

With PomoDoneApp, Zapier will trigger whenever a timer begins. There is nothing to configure here, so the setup is straight forward for this step.

## Slack - Set Status Action

![](/images/2018-10-30-automating-slack-statuses-for-meetings-and-focus-times/pomodone-slack-step.jpg)

At this step, I'm just setting the appropriate status (i.e., focusing) to indicate that I'm in deep work. As per the Pomodoro technique, after the timer is up I'm free for a small break. The status expiration helps accommodate this workflow easily.

# Slack Statuses While Working Remotely

So, as I mentioned earlier, I occasionally work remotely. This presents an interesting problem of conveying two statuses simultaneously. My workaround isn't pretty but it works... I simply change my Slack name to "Kevin Jalbert (WFH)" to indicate that I'm working from home that day. This move frees up my actual Slack status to be automated throughout the day.
