---
title: "Daily Review Using iOS Shortcuts and Scriptable"

description: "Read how I orchestrate my daily review that consists of multiple applications using iOS Shortcuts. I create a notification-based workflow as a workaround to Shortcut's time limit when switching between applications."

tags:
- ios
- process
- productivity

pull_image: "/images/2020-09-28-daily-review-using-ios-shortcuts-and-scriptable/phone.jpg"
pull_image_attribution: 'Photo of my iPhone 11 showing the Shortcuts widget and Scriptable application'
---

Doing daily and weekly reviews are generally considered a good habit, as it can help with organizing life and making sure you focus on the important things. Reviews are tailored to the individual and depend a lot on the individual's goals and systems.

# My Frustrations Doing Daily Reviews

Doing daily reviews for me has raised some frustrations:

1. I have several steps in my daily review, which I haven't properly formalized.
2. I sometimes don't have a solid block of time to process each step of my review.
3. I like using my laptop that resides in my home office, which has caused me to delay/miss reviews if I cannot make time to get to my laptop.

# Using my iPhone for Daily Reviews

Upon looking at the frustrations, I came up with a better solution that uses my iPhone for my daily reviews. I always have my iPhone near me, and the individual steps of my review use applications that are web-based or within the Apple ecosystem. I'm giving up a physical keyboard by using my iPhone, but I'm willing to make that trade-off for accessibility.

When iOS 12 was released, it came with _Shortcuts_. This was a new feature that allowed you to string together a bunch of tasks to create workflows. The Shortcuts functionality is my best bet in creating a formalized process that allows me to work through various applications as part of my daily review.

# iOS Shortcuts and its Limitations

My strategy includes a _Review_ Shortcuts folder that contains the individual steps of my review process. I'll have a single shortcut which then orchestrates my review using all those individual steps. I take advantage of the `Wait to return` scripting action, which allows me to interact with an application (e.g., _Things_) and then continue to the next step when I return to the Shortcuts application.

<div style="display: flex">
  <img src="/images/2020-09-28-daily-review-using-ios-shortcuts-and-scriptable/review-folder.png" style="width: 33%; height: 100%"/>
  <img src="/images/2020-09-28-daily-review-using-ios-shortcuts-and-scriptable/review-shortcut.png" style="width: 33%; height: 100%"/>
  <img src="/images/2020-09-28-daily-review-using-ios-shortcuts-and-scriptable/things-shortcut.png" style="width: 33%; height: 100%"/>
</div>

This worked out well when I was creating the workflow, but I hit a limitation in iOS Shortcuts. A running shortcut will only stay active for a short period of time when you are away from the Shortcuts application. From my experience, this is around 3 minutes. This means that if one step of my daily review takes longer than 3 minutes, the whole thing breaks down.

# Actionable Notifications via Scriptable

To be honest, I was a bit disheartened with the time limitation in Shortcuts. I looked around for another solution. Instead of using the `Wait to return` scripting action, I could use actionable notifications to open a URL that triggers the shortcut via the `shortcuts://run-shortcut?name=shortcutname` URL scheme. Unfortunately, iOS Shortcuts does not have that capability when creating notifications as they can only show text.

I did some searching online and found [Scriptable](https://scriptable.app/), a powerful iOS automation application that uses JavaScript. With this, I could create notifications that, when interacted with, could open a specified URL.

## Putting it Together

I'll try my best to explain how I used iOS Shortcuts and Scriptables together to make everything work, as this just got a bit more complicated.

The _Daily Review_ shortcut grabs the text of each shortcut of my review process (within the _Review_ folder) and turns it into a single string separated by commas. This string looks like `Things,Journal,Habits,Drafts` and we pass that into a Scriptable action.

Our individual steps of the review process are still fairly simple shortcuts, although now they take the _Shortcut Input_ and push that into the same Scriptable action as mentioned above.

It is worth noting that there are a few other small things happening in these shortcuts, but I've omitted them for the sake of brevity.

<div style="display: flex">
  <img src="/images/2020-09-28-daily-review-using-ios-shortcuts-and-scriptable/revised-review-shortcut.jpeg" style="width: 49%; height: 100%"/>
  <img src="/images/2020-09-28-daily-review-using-ios-shortcuts-and-scriptable/revised-things-shortcut.png" style="width: 49%; height: 100%"/>
</div>

My approach pushes all state of _where I am in the review process_ into the shortcut input, which is the string of shortcut steps to run. To see how we connect these shortcuts together, we'll look at the Scriptable code that uses that string of shortcut steps.

```js
// Variables used by Scriptable.
// These must be at the very top of the file. Do not edit.
// icon-color: deep-green; icon-glyph: user-md;
function createNotification({body, openURL}) {
  const notification = new Notification()
  notification.body = body
  notification.openURL = openURL
  notification.schedule()
}

if (args.shortcutParameter === "") {
  await createNotification({
    body: "Done after this!",
    openURL: "shortcuts://run-shortcut?name=Homescreen"
  })
} else {
  const shortcuts = args.shortcutParameter.split(",")
  const nextShortcut = shortcuts.shift()
  const remainingShortcuts = shortcuts.join(',')

  await createNotification({
    body: `Next step is ${decodeURI(nextShortcut)}`,
    openURL: `shortcuts://run-shortcut?name=${nextShortcut}&input=text&text=${remainingShortcuts}`
  })

  Script.setShortcutOutput(remainingShortcuts)
}

Script.complete()
```

I'll walk through key steps of what happens when we trigger the _Daily Review_ shortcut:

1. Grab all shortcuts from the _Review_ folder and combine them into a single string (e.g., `Things,Journal,Habits,Drafts`).
2. This string is passed as input to the Scriptable action.
3. The script identifies `nextShortcut = "Things"` and `remainingShortcuts = "Journal,Habits,Drafts"`.
4. A notification is created that has the URL of `shortcuts://run-shortcut?name=Things&input=text&text=Journal,Habits,Drafts` that says "Next step is Things".
5. The _Daily Review_ Shortcut has finished running.
6. Tapping the notification will run the `Things` shortcut and pass in the inputs of `Journal,Habits,Drafts`.
7. The Things application is opened, and the shortcut's input is passed along to the same Scriptable action as before.
8. A new notification is created for the next step while removing that step from the string of remaining shortcuts.
9. Eventually all shortcuts are run using steps 6-8, and a "Done after this!" notification finally shows. This will open the user's homescreen.

# Daily Review With No Time Limits

This new approach using Scriptable along with Shortcuts, while complicated, allows me to circumvent the time limit of Shortcuts. The workflow is actually pretty nice as I can move along entirely following notifications as the triggers for the next steps. All the state of the whole process is encoded in the string of shortcuts that have to run. The Review folder approach also makes it easy to add a new step in my review process, should the need arise.

![](2020-09-28-daily-review-using-ios-shortcuts-and-scriptable/demo.gif)

If the above gif isn't doing it for you, you can get a better sense of the whole thing by watching the following video I recorded.

<iframe class="youtube-embed" src="https://www.youtube.com/embed/CjTzhPxfz8Q" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
