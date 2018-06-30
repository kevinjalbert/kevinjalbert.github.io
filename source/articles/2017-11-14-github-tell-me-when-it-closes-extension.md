---
title: "GitHub: Tell Me When It Closes Extension"

description: "My first foray into making and publishing a browser extension. Let me showcase a quick extension which adds a button on GitHub's pull request and issue pages that links to tellmewhenitcloses.com populated with data."

tags:
- github
- tools

pull_image: "/images/2017-11-14-github-tell-me-when-it-closes-extension/screenshot.jpg"
pull_image_attribution: '[Screenshot of GitHub: Tell Me When It Closes Extension](https://github.com/kevinjalbert/github-tell-me-when-it-closes-extension)'
---

[Tell Me When It Closes](https://tellmewhenitcloses.com/) is an amazing service by [thoughtbot](https://thoughtbot.com/). Often I'll find an issue or pull request on GitHub for a tool I use and I just want to know _when_ it closes what the result was. I don't care for the back-and-forth conversations between people when if I were to subscribe, so Tell Me When It Closes is the perfect service for me.

The issue I ran into was the limited ways to integrate this into my workflow. Looking at the ways you can [subscribe to issues and pull requests](https://tellmewhenitcloses.com/subscribing), it's a bookmarklet that runs JavaScript. I don't use the bookmark bar in my chrome browser (or browser bookmarks), so that solution wasn't ideal.

My old workflow for subscribing to an issue on Tell Me When It Closes was:

1. Cmd + L (move keyboard cursor to address bar)
2. Cmd + C (copy URL)
3. Cmd + T (open new tab)
4. Type tellmewhenitcloses.com (autocompletes after a few characters)
5. Enter (opens tellmewhenitcloses.com)
6. Cmd + V (paste in issue URL)
7. Enter (subscribe to issue)

To many manual steps for me.

# Simplify and Extend

I want a way to simplify the steps to subscribe to an issue. I figured I could manipulate the webpage with JavaScript and add a button which, when, clicked would navigate to the subscription page with the URL filled in.

I looked into making a browser extension, originally for Google Chrome. Upon further investigation, I found that I could target more browsers without much extra effort. I decided to use [EmailThis/extension-boilerplate](https://github.com/EmailThis/extension-boilerplate) so that I could build an extension for Chrome, Opera & Firefox.

The end result is a button which appears in the _notifications_ section of an issue or pull request page. When you click the button, it'll open the tellmewhenitcloses.com with the appropriate URL pre-filled.

![](/images/2017-11-14-github-tell-me-when-it-closes-extension/button.jpg)

Now my workflow for subscribing to an issue on Tell Me When It Closes is:

1. Click _Tell Me When It Closes_ button (using trackpad or [Vimium](https://chrome.google.com/webstore/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb))
2. Enter (subscribe to issue)

# Links

* [GitHub Repository](https://github.com/kevinjalbert/github-tell-me-when-it-closes-extension)
* [Chrome Extension](https://chrome.google.com/webstore/detail/github-tell-me-when-it-cl/mfaeeelmjfbblmkbalffbhfpkhhnjalp)
* [Firefox Add-on](https://addons.mozilla.org/en-US/firefox/addon/github-tell-me-when-it-closes/)
* [Opera Add-on](https://addons.opera.com/en/extensions/details/github-tell-me-when-it-closes)
