---
title: "Making AirPlay work with Chromecast Devices"

description: "Read about how I got my Chromecast devices (i.e., Google Nest Minis) to work with AirPlay and play audio streams."

tags:
- iOS
- Apple
- Google

pull_image: "/images/2023-02-27-making-airplay-work-with-chromecast-devices/airplay-list.png"
pull_image_attribution: "Screenshot of my Google Home speakers showing up under the AirPlay selection list within Apple's Music app in macOS."
---

This is another quick post in which I want to share and praise a new tool/service I've been using.

Continuing from my [previous efforts to get non-apple devices to work with Homekit](/getting-non-homekit-devices-working-in-homekit), I decided to make my Google Nest/Home speakers work with AirPlay.

I'm leveraging the open-source project [philippe44/AirConnect](https://github.com/philippe44/AirConnect) to accomplish this feat. The README file is filled with information that I highly recommend at least skimming. The quick TL;DR on what this does, straight out of the README, is:

> AirConnect can run on any machine that has access to your local network.

> It does not need to be on your main computer.

> It will detect UPnP/Sonos/Chromecast players, create as many virtual AirPlay devices as needed, and act as a bridge/proxy between AirPlay clients (iPhone, iPad, iTunes, MacOS, AirFoil ...) and the real UPnP/Sonos/Chromecast players.

I run AirConnect from my [Unraid server](https://unraid.net/) (using this docker container [`1activegeek/docker-airconnect`](https://github.com/1activegeek/docker-airconnect)) and it was pretty much a _painless_ addition for me. I was quickly able to see new devices appear as compatible AirPlay devices.

There is a [known limitation with AirConnect](https://github.com/philippe44/AirConnect#delay-when-switching-track-or-source), which is that there are a few seconds of delay when switching tracks. Overall, it doesn't bother me too much but it is worth knowing about.
