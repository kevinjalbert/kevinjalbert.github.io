---
title: "Bluetooth Connection/Battery Script for macOS"

description: "Using AppleScript to simplify connecting bluetooth earphones to macOS."

tags:
- hardware
- bluetooth
- macOS

pull_image: "/images/2017-04-09-bluetooth-connection-battery-script-for-macos/beatsx.jpg"
pull_image_attribution: 'My BeatsX Earphones'
---

I recently purchased a pair of [BeatsX Earphones](http://www.apple.com/ca/shop/product/MLYE2LL/A/beatsx-earphones-black) as I wanted to stop dealing with wired earbuds. For some reason, the wired connections always stopped working properly after a number of months. I supect it is just the stress on the wire while in my pocket during my commute.

When arriving at work, or really anytime I am transitioning from iPhone to MacBook Pro, I have to manually connect my BeatsX to the MacBook Pro. I wanted to automate this process, down to a simple command. If the BeatsX are in range and on they would initiate the connection process to my machine. In addition, it would be nice to have a way to monitor the battery level using a similar process.

Looking around, I couldn't find any way through a command-line interface to do what I wanted. I eventually figured out that I could use macOS's [AppleScript](https://en.wikipedia.org/wiki/AppleScript) to automate the menu navigation.

The following script will attempt to connect to the desired device (i.e., BeatsX by name). If it is already connected then it will retrieve the battery level.

```applescript
activate application "SystemUIServer"
set deviceName to "Kevin Jalbert's BeatsX"

tell application "System Events"
  tell process "SystemUIServer"
    set bluetoothMenu to (menu bar item 1 of menu bar 1 whose description contains "bluetooth")
    tell bluetoothMenu
      click

      set deviceMenuItem to (menu item deviceName of menu 1)
      tell deviceMenuItem
        click

        if exists menu item "Connect" of menu 1 then
          click menu item "Connect" of menu 1
          return "Connecting..."
        else
          set batteryLevelMenuItem to (menu item 3 of menu 1)
          tell batteryLevelMenuItem
            set batteryLevelText to title of batteryLevelMenuItem
          end tell

          key code 53 -- esc key

          return batteryLevelText
        end if
      end tell
    end tell
  end tell
end tell
```

This on its own is a nice win and works as desired. Now, I'm a heavy user of [Alfred](https://www.alfredapp.com/) and I quickly threw together a workflow that uses this script. I now get a notification during connection, and repeated invokations will display the battery level.

![](/images/2017-04-09-bluetooth-connection-battery-script-for-macos/alfred-workflow.gif)
_My BeatsX Alfred workflow_
