---
title: "Getting Non-HomeKit Devices Working in HomeKit"

description: "Read about how I got my non-HomeKit devices working in HomeKit using Homebridge. This makes it easy to use Siri (via an Apple Watch) to control my smart devices."

tags:
- iOS
- HomeKit
- Homebridge

pull_image: "/images/2022-11-30-getting-non-homekit-devices-working-in-homekit/homebridge.png"
pull_image_attribution: 'My Homebridge UI with the current installed plugins for my smart devices'
---

## Google Home as my Hub

All my smart home devices end up connecting via [Google Home](https://home.google.com/welcome/). It was an easy entry point at the time via the inexpensive Google Home devices, and it turned out that voice activation was the _key_ to usability.

Even being an Apple household, we never got into [HomeKit](https://www.apple.com/ca/home-app/accessories/). I figured that switching to HomePods was a bit too costly... and also some of my smart devices didn't connect to HomeKit.

## Apple Watch and HomeKit

I've recently connected a smart switch for the lamp in my youngest son's room. When my wife puts him down she'll be laying with him, and wants an easy way to turn his lamp off (as it is across the room), I know... first-world problems. If she has her phone she can use that, but often she just has her Apple Watch.

I looked around, and it seemed to like controlling devices via HomeKit would be an ideal solution, and [with WatchOS it is possible](https://support.apple.com/en-ca/guide/watch/apddad023a05/watchos). Now to connect my non-HomeKit devices somehow...

# Exploring Homebridge

A quick investigation led me to [Homebridge](https://homebridge.io/).

> Homebridge allows you to integrate with smart home devices that do not natively support HomeKit. There are over 2,000 Homebridge plugins supporting thousands of different smart accessories.

With my _recently new_ [Unraid server](https://unraid.net/), I was able to spin up a [Homebridge Docker container](https://github.com/oznu/docker-homebridge) and had the majority of my devices working quickly!

## Tweaks and Cameras

Homebridge lets you install plugins to then act as the bridge between said devices and HomeKit.

As of now, I'm currently using the following plugins:

  - [Homebridge TPLink Smarthome](https://github.com/plasticrake/homebridge-tplink-smarthome)
    - My [Kasa](https://www.kasasmart.com) outlets/switches/lights.
    - Worked out of the box and just auto-discovered existing devices on the network.
  - [Homebridge YoLink](https://github.com/dkerr64/homebridge-yolink)
    - My [YoLink](https://shop.yosmart.com/) door/water/motion sensors.
    - Worked out of the box after inputting the required credentials.
  - [Homebridge Nest Cam](https://github.com/Brandawg93/homebridge-nest-cam)
    - My [Nest Hello Doorbell](https://store.google.com/ca/product/nest_doorbell) (older model)
      - After getting past the authentication (as I haven't migrated my Nest account to Google) this worked. The one _addition_ I did in the `config.json` was specifying `"ffmpegCodec": "copy"` to avoid encoding the stream on my server (fewer resources).
  - [Homebridge Camera FFmpeg](https://github.com/Sunoo/homebridge-camera-ffmpeg)
    - My [Wyze Cameras](https://www.wyze.com/) to keep an eye on the kids at night
    - This one was a bit more involved...
      - I used [`docker-wyze-bridge`](https://github.com/mrlt8/docker-wyze-bridge) to first expose an RTSP (Real Time Streaming Protocol) stream for the Wyze cameras.
      - I then was able to specify the RTSP and Snapshot URLs in the `homebridge-camera-ffmpeg` settings.
      - The last thing was to specify `copy` under `Advanced > Video Codec`, again to avoid encoding.

# The Aftermath

After all was said and done, everything works as expected. We're able to use our non-HomeKit devices in HomeKit and leverage it on our Apple Devices.

##  Benefits

  - Smart devices are exposed in HomeKit.
  - Better iOS/WatchOS/macOS integration due to `Home` app.
  - Siri's capabilities are so nice given I use an iPhone and Apple Watch.
  - The Google Home application continues to function as a Hub.

## Frustrations

  - Smart device names when changed on the source application don't reflect in HomeKit.
  - If the Homebridge service has an issue then nothing works via HomeKit.
  - Another place to put automations (granted options are nice, but having automations spread across different systems is harder to keep track of.)

## Next Steps

I did stumble across [Home Assistant](https://www.home-assistant.io/), which looks like an even more powerful automation system. This might be something I poke around with, as there is also a [HomeKit Integration](https://www.home-assistant.io/integrations/homekit/) for this (amongst many others). One thing at a time though, too much change can be hard to cope with.
