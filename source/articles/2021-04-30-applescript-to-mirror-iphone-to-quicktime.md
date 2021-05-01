---
title: "AppleScript to Mirror iPhone to QuickTime"

description: "I automated seven manual steps to mirror my iPhone to QuickTime using AppleScript. Read about some of the challenges I encountered and see the finalized script being trigged by Alfred."

tags:
- ios
- tools
- alfred
- applescript

pull_image: "/images/2021-04-30-applescript-to-mirror-iphone-to-quicktime/mirror-alfred-script.png"
pull_image_attribution: 'Photo of the AppleScript and Alfred Workflow to mirror my iPhone to QuickTime'
---

Like many, I'm guilty of playing mobile games on my iPhone. For the games that have controller support, I'll stream the video on a larger screen. As mentioned in my [previous article](/how-i-keep-active-at-home), I'll sometimes play on my exercise bike. In this situation, I'll *mirror* my iOS device through QuickTime so that I can play on a larger screen with a controller.

# Manual Steps

There are a number of steps that I have to complete to mirror my iPhone to QuickTime:

1. Enable [KeepingYouAwake](https://keepingyouawake.app/) (so monitor doesn't go to sleep with no inputs)
2. Open QuickTime
3. Make a new *Movie Recording*
4. Select my iPhone for video input
5. Select my iPhone for audio input
6. Drag the volume slider to 100%.
7. Maximize Quicktime window

# Sweet Automation

This GIF demonstrates the automation that covers all seven manual steps. I launch it using [Alfred](https://www.alfredapp.com/).

![](/images/2021-04-30-applescript-to-mirror-iphone-to-quicktime/mirror-ios-alfred.gif)

# The Code

I may be biased, but the source code is organized quite well in my opinion. The first eight lines cover all necessary customization needs as they are just function calls. If you need to, you can always dive into the functions themselves. The following is the code hosted on a [Public Gist](https://gist.github.com/kevinjalbert/d7661a6a34c1d66dccf701f64eb09be4).

<script src="https://gist.github.com/kevinjalbert/d7661a6a34c1d66dccf701f64eb09be4.js"></script>

# Challenges

## Selecting a video input

I had to select my iPhone for the video/audio inputs in QuickTime using AppleScript. A quick search turned up this [Stack Overflow question](https://stackoverflow.com/q/45228743/583592). It turns out that you _should_ be able to do the following:

```applescript
tell application "QuickTime Player"
    set newMovieRecording to new movie recording
    tell newMovieRecording
        set current camera of newMovieRecording to "Kevin's iPhone"
        set current microphone of newMovieRecording to "Kevin's iPhone"
    end tell
end tell
```

Unfortunately, it doesn't work as you get hit with `Can’t make "Kevin's iPhone" into type video recording device`. This would have made things _much easier_.

Instead, we have to click the button to open the inputs list and then make the selections via AppleScript. This wasn't too bad initially, as it was just iterating the list of menu items and clicking the one which matched my device's name.

## Same name for audio/video inputs

After I was able to select the video input, the next problem is selecting the audio input. The problem now is that the audio and video input share the same name and are within the same list. I would have to _skip_ the first one (video input) to select the audio input. This wasn't too hard but was just another hurdle to get over. Ideally, the list of inputs would have been separated by video/audio, or somehow have a different key to reference them by.

## Inputs menu was slow to close

I had noticed earlier that when the inputs menu was opened it would stay open for 7-8 seconds before making the menu item selection. I wasn't too concerned at the time, but after the whole automation was done it took just under 20 seconds to mirror my device.

It took a lot of digging but I found a [Stack Overflow answer](https://apple.stackexchange.com/a/400163/228446) that provided the solution.

```applescript
on openInputMenu()
	ignoring application responses
		tell application "System Events" to tell process "QuickTime Player"
			click button 2 of window 1
			delay 1
		end tell
	end ignoring
	do shell script "killall 'System Events'"
end openDeviceMenu
```

This function for opening the menu is explicitly telling it to ignore the application responses (i.e., don't wait for feedback). A manual delay of a second is injected to give time for the menu to open up. It also kills the `System Events`, which ends up forcing the script to continue execution to future actions. I'll be honest, I'm not 100% on the specifics but it worked -- the menu opens and the selections are made in just over a second now.
