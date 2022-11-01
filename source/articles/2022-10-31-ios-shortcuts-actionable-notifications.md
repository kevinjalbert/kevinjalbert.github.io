---
title: "iOS Shortcuts: Actionable Notifications"

description: "Sometimes, you need a notification to do something when you tap on it like opening an app or running a shortcut. Unfortunately, the native 'Show Notification' in iOS Shortcuts is non-actionable and therefore lacking. Read about how to take advantage of actionable notifications in iOS Shortcuts."

tags:
- iOS
- tools

pull_image: "/images/2022-10-31-ios-shortcuts-actionable-notifications/notifications.jpg"
pull_image_attribution: 'Two actionable notifications (via Pushcut and Toolbox Pro) on my iOS device.'
---

# Simple Notifications

The native _'Show Notification'_ in [iOS Shortcuts](https://support.apple.com/en-ca/guide/shortcuts/welcome/ios) produces a non-actionable notification. It doesn't allow for any customization to _open_ anything, so it is purely a notification to show you information.

![](/images/2022-10-31-ios-shortcuts-actionable-notifications/native-notification.jpeg)

There might be times when you need more customization and power with your notifications. This is where we can take advantage of third-party actions from different Apps.

# Powerful Notifications

On the left, we have [Pushcut](https://www.pushcut.io/), a free option that lets you customize three actionable notifications from within their application before you have to pay for a monthly subscription (or a hefty one-time cost -- $55 USD). On the right, we have [Toolbox Pro](https://toolboxpro.app/) which has their 'Show Notification' action locked behind a $6 USD one-time in-app purchase.

<div style="display: flex">
  <img src="/images/2022-10-31-ios-shortcuts-actionable-notifications/pushcut-notification.jpeg" style="width: 49%; height: 49%"/>
  <img src="/images/2022-10-31-ios-shortcuts-actionable-notifications/toolboxpro-notification.jpeg" style="width: 49%; height: 49%"/>
</div>

I personally have used Toolbox Pro a lot in the past in my shortcuts. I've recently stumbled upon Pushcut and seem like a good option as well (especially if you have any usage of their other triggers/server features).

To note, these aren't the only two applications that allow for these powerful notifications. If you look around I'm sure there are many others that might better suit your needs.

# Actionable Notifications

The beauty of actionable notifications is that they can open URLs. URLs then let you take advantage of URL Schemes. I'm going to pull some quotes from a [previous article](/using-url-scheme-links-in-notion) I wrote that describes them:

> _URL Scheme links_ (also called [_x-callback-url_](https://support.apple.com/en-ca/guide/shortcuts/apdcd7f20a6f/ios)), which are defined by an application. For example, Things has an [excellent article](https://culturedcode.com/things/support/articles/2803573/) on how you can use URL Scheme links to interface with it.

> Each application provides its own URL Scheme, although this [site](http://x-callback-url.com/apps/) does a decent job cataloging URL Schemes of popular applications.

This makes it so you can _tap_ on a notification and have it _open_ an application. An example of this can be seen below, where I go from a notification to the [Just Press Record](https://www.openplanetsoftware.com/just-press-record/) application:

![](/images/2022-10-31-ios-shortcuts-actionable-notifications/actionable-notification.gif)

To go even further, you can have the URL Scheme trigger other iOS Shortcuts using `shortcuts://run-shortcut?name=shortcutname`!
