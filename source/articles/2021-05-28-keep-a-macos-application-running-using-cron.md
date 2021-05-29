---
title: "Keep a macOS Application Running using cron"

description: "Read how I use cron to keep the RescueTime Application running. I was frustrated at RescueTime crashing and not recording data for a whole week."

tags:
- macos
- tools
- cron

pull_image: "/images/2021-05-28-keep-a-macos-application-running-using-cron/rescuetime-email.png"
pull_image_attribution: "Screenshot of RescueTime email notifying me it hasn't been running."
---

I have used [RescueTime (Referral Link)](https://www.rescuetime.com/ref/31263) for many years at this point. It always disappoints me when I get the email saying that no data was recorded in RescueTime for the last week (see image above article title). For reasons unannounced to me, the macOS menu bar application had stopped running. I use the [Bartender for macOS](https://www.macbartender.com/) to hide certain menu bar applications (as they offer little visual value) -- RescueTime is hidden from my view and I never noticed it wasn't running.

I needed a way to ensure that the application was kept running if it crashed.

## Launch Application in Background using `cron`

I know of `cron` and how it can run scripts periodically -- I figured this would be the tool to save me here.

I quickly put together the following (add this using `crontab -e`):

```
*/5 * * * * open --hide --background /Applications/RescueTime.app
```

Using [crontab.guru](https://crontab.guru/#*/5_*_*_*_*) we can see that this will run the `open` for ResuceTime command every 5 minutes. The `--hide` and `--background` ensure that the application doesn't open in an obtrusive manner (i.e., think applications with a GUI).

This worked for me -- it opened RescueTime if it was closed out. I even tested this with other applications and it _mostly_ worked as expected. The _hide and background_ flags didn't work for some applications (e.g., Evernote always appears in the forefront for whatever reason).

Done deal then right? Wrong. I noticed every now and then a keystroke or two wouldn't register. When I looked at the time it was always on the minute the `cron` would trigger... If I had to take a guess, the `open` was causing focus to switch briefly and would interrupt keystrokes on the current application I was in.

I could decrease the frequency that the command would run or...

## Only `open` if Application isn't Running

My next approach was to only _open_ the application if it wasn't already running. This will prevent the `open` from triggering multiple times during the day.

```
# Scroll to see full command (it is one line due to fitting in the crontab)
*/5 * * * * app=Rescuetime; ps aux | grep -v grep | grep -ci $app > /dev/null || open --hide --background /Applications/$app.app
```

If we break this down:

- `app=Rescuetime;` sets a variable of what application we're trying to keep open.
- `ps aux | grep -v grep | grep -ci $app > /dev/null` lists all running processes, excluding the `grep` process, and finally counting the found lines while `grep`ing for the application's name. This ends up being a 0 or 1. The STDOUT output is directed to the void so that it doesn't create new `mail` entries.
- `||` will conditionally run the next statement if the previous was falsey (i.e., no application was found running)
- `open --hide --background /Applications/$app.app` opens the specified application

Now this works as expected! I no longer have to worry about RescueTime not running. I might do this for other menubar applications that I like to have active, but are hidden.

I haven't tried this on Linux but I suspect you could do something similar (assuming there is an equivalent to `open`).
