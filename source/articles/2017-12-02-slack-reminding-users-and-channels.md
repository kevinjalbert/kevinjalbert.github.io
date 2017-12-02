---
title: "Slack Reminding Users and Channels"

description: "Slack Reminders are powerful, maybe even more so than you originally thought?! In my experience, I noticed that colleagues of mine didn't fully use reminders to their fullest extent."

tags:
- communication
- collaboration
- productivity

pull_image: "/images/2017-12-02-slack-reminding-users-and-channels/slack-reminders.jpg"
---

![](/images/2017-12-02-slack-reminding-users-and-channels/slack-reminders.jpg)
_Screeshot of Slack's Reminder Help_

[Slack](https://slack.com/) has taken over communication for workplace environments, at least within tech circles surrounding me. I realize there are many competitors, and I have even used some of them in the past, but to me Slack is my preferred choice. If you haven't given Slack a try, I highly recommend it! At [theScore](http://company.thescore.com/) we heavily use Slack.

This post will be short and focused on [Slack Reminders](https://get.slack.help/hc/en-us/articles/208423427). From what I've experienced with coworkers, they only knew of and used a small subset of Slack Reminder's feature set. This post is going to demonstrate what you can do with Slack Reminders, mainly assigning reminders to users and channels.


# Reminding Myself

A common use case for reminders -- you want some notification in the future to remind you about something.

```
/remind me to work on blog post in 30 minutes
```

![](/images/2017-12-02-slack-reminding-users-and-channels/slack-remind-me.jpg)

This is the feature that most people know of with Slack Reminders.

# Reminding a User

It's not an uncommon task that you'd want to remind a colleague about a future task.

```
/remind @aaron.romeo deploy your changes before the weekend on friday morning
```

![](/images/2017-12-02-slack-reminding-users-and-channels/slack-remind-user.jpg)

In this example, [@aaron.romeo](http://www.aaronromeo.com/) would receive a reminder at the specified time. Aaron doesn't actually receive any indication that he has just been assigned a reminder. The only way he can get any insight that he has a new reminder is to either wait until the specified time, or to look at his own list of reminders and see it there. You just have to be aware of this detail depending on how you plan to use reminders.

Going back to our example, Aaron checks his reminders in Slack and he sees the newly assigned task, although there is no indication of who assigned it to him. Slack, if you are listening, I would like to be able to see who assigned the reminder.

![](/images/2017-12-02-slack-reminding-users-and-channels/slack-remind-target-list.jpg)

Regardless, when the reminder does trigger, Aaron can interact with it. In this case he'll mark it as completed.

![](/images/2017-12-02-slack-reminding-users-and-channels/slack-remind-target-trigger.jpg)

I received confirmation that he has seen and acted on the reminder I assigned him.

![](/images/2017-12-02-slack-reminding-users-and-channels/slack-remind-target-completed.jpg)

This asynchronous flow is awesome, as it allows you to _know_ that the reminder for that user was acted upon. I tend to use these types of reminders after hours to present information that can wait until the following day. Normally, I end up finding interesting articles that I want to pass on, so these types of reminders work perfectly for me.

# Reminding a Channel

In a similar fashion to assigning a reminder to another user, you can target a channel itself. For example, you might want to remind all the online users within a channel about something.

```
/remind #team-ep-dev :spiral_calendar_pad: @here standup time! every weekday at 10:30am
```

![](/images/2017-12-02-slack-reminding-users-and-channels/slack-remind-channel.jpg)

In this example, the channel `#diet-sup-dev` will receive the message at the specified time. As you can see, I even used the `@here` mention to make sure it gets all the active users' attention. When a channel reminder is set, the reminder is announced on the channel at the specified time.

![](/images/2017-12-02-slack-reminding-users-and-channels/slack-remind-channel-announcement.jpg)

# What are my reminders

Every now and then you might want to do a little housecleaning on your reminders. You have likely clicked the _View Reminders_, or even just executed the following:

```
/remind list
```

This presents a list of the past, present, and future reminders, as well as incomplete reminders, for yourself, along with reminders for other individuals and channels.

![](/images/2017-12-02-slack-reminding-users-and-channels/slack-remind-list.jpg)

It is a nice place to check every now and then to make sure your reminders are being actioned.

# Reminders are cheap

The beauty of Slack Reminders is that they are quick to create and are actionable. You can be in any conversation in Slack and still use the `/remind` command. The ease of making a new reminder means there is no reasons to not use them in your daily workflow.
