---
title: "Using iOS Shortcuts to Open Notion Pages"

description: "Learn how to quickly open Notion pages on your iOS device. See how I work around dynamic page links (e.g., current day/week) to open the correct pages from my Notion Weekly Template."

tags:
- ios
- productivity
- notion

pull_image: "/images/2019-10-30-using-ios-shortcuts-to-open-notion-pages/iphone-home-screen.jpg"
pull_image_attribution: 'My iPhone 11 with Notion and iOS Shortcuts'
---

I recently switched from Android back to iOS for my mobile device. I decided to take a look at [iOS Shortcuts](https://support.apple.com/en-ca/guide/shortcuts/welcome/ios) as I never really got to play with them before. Given my recent obsession with [Notion [Referral]](https://www.notion.so/?r=6b8d609eb50943419db4d87c67fa558e) I decided to see how I can put iOS Shortcuts to use here.

I'm going to walk you through two examples of using iOS Shortcuts to open Notion Pages. The first one uses a normal Notion page, and the second one uses the _current_ day/week pages from my [highly-tailored weekly template](/my-weekly-notion-setup/).

# Open Notion Page from iOS Home Screen

The first thing that you can do is create a shortcut on your home screen that opens to a specific page in Notion. For example, you could have a page holding your todos, shopping list, latest project, etc. In my opinion, this is really useful if you frequently use specific pages in Notion on your mobile device.

## Notion Page Link

We need to get the _Page Link_ from Notion. On iOS, you get this link by clicking the `...` on a page in Notion and then _Copy Link_.

*Note: You can find the current Page Link in the Web interface for Notion as well, although the user interface will be slightly different.*

<div style="display: flex">
  <img src="/images/2019-10-30-using-ios-shortcuts-to-open-notion-pages/notion-page-step1.jpg" style="width: 49%; height: 100%"/>
  <img src="/images/2019-10-30-using-ios-shortcuts-to-open-notion-pages/notion-page-step2.jpg" style="width: 49%; height: 100%"/>
</div>

In your clipboard, you will have a link that looks like the following: `https://www.notion.so/Example-page-721c581be9734ad09480d0cc16f774fd`. If visit this link, your browser will open the Notion web application to that page. Unfortunately, this will open the page in the web application in your browser.

The goal is to open the native Notion application. We can accomplish that using a custom URL Schema that Notion provides for iOS/macOS. **Replacing `https` with `notion` in our link (e.g., `notion://www.notion.so/Example-page-721c581be9734ad09480d0cc16f774fd`) will now open the Notion page in the native Notion application (if opened with Safari).**

## Shortcut to Open Notion Page

Now we can start by creating our iOS Shortcut to open the Notion page. As shown in the images below, our shortcut is just one step to open the `notion://` page link with Safari. Finally, we can add this to the home screen, and now we have a single press shortcut that opens directly to the page we want.

<div style="display: flex">
  <img src="/images/2019-10-30-using-ios-shortcuts-to-open-notion-pages/notion-page-step3.jpg" style="width: 49%; height: 100%"/>
  <img src="/images/2019-10-30-using-ios-shortcuts-to-open-notion-pages/notion-page-step4.jpg" style="width: 49%; height: 100%"/>
</div>

# Open my Current Day/Week Page

> [Click to get iOS Shortcut to Open Current Day Notion Page](https://www.icloud.com/shortcuts/575fc46b4e1b486dab30c4ef42cdf180)

As previously noted, I have a more elaborate Notion setup (more details about [highly-tailored weekly template](/my-weekly-notion-setup/)) where I have unique Notion pages for each day and week. My goal is to have a _'Notion Day'_ and _'Notion Week'_ shortcut on my home screen for quick access. Unfortunately, the page link for the current day and week change daily/weekly, and thus the previous solution doesn't work for me.

## Fetching the Dynamic URLs

I currently have a web application running that exposes an API ([`notion-heroku`](https://github.com/kevinjalbert/notion-heroku)), allowing me to interact with my Notion account through HTTP requests. I've recently [added a feature](https://github.com/kevinjalbert/notion-heroku/pull/3) that exposes the `notion://` page URLs for the current day/week when I make a request.

```sh
❯ curl https://notion-heroku.herokuapp.com/current_links.json -H "api_token: $API_TOKEN" -s | jq
{
  "current_day": "notion://www.notion.so/YHuWdvUQ8nc5gBgkqHexDToWRzGvuP6e",
  "current_week": "notion://www.notion.so/kG7jQamppo4RRGc7voAC7elyGDeg7a70"
}
```

The shortcut isn't too hard to create afterwards and ends up as a three-step shortcut:

1. Make the HTTP network call.
2. Access the value from the JSON response.
3. Open value (Notion page URL) in Safari.

<div style="display: flex">
  <img src="/images/2019-10-30-using-ios-shortcuts-to-open-notion-pages/notion-current-day.jpg" style="width: 49%; height: 100%"/>
</div>

This shortcut works well, but it has two drawbacks. It _always_ has to make the network call to get the page links, it can be slow based on latency and it requires network access.

## Performance and Robustness

To address the drawbacks of the previous shortcut demonstration in the last section, we can cache the response from the `notion-heroku` server. Caching the results for a day then makes it so only the first usage of the shortcut requires a network call and all subsequent usage uses a cached file.

The [new and improved iOS Shortcut](https://www.icloud.com/shortcuts/575fc46b4e1b486dab30c4ef42cdf180) now contains over 25 steps, although it handles caching, cache invalidation, and a notification if the server didn't respond. Using the shortcut when there is a cached value feels faster to me and it even works while in airplane mode.

The following video gives a walkthrough of the shortcuts:

<iframe class="youtube-embed" src="https://www.youtube.com/embed/oGYWF5EpwbQ" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

# The Possibilities with iOS Shortcuts

In my opinion, iOS Shortcuts open up a lot of interesting possibilities. The fact that you are able to make and use API calls is very powerful on its own. I can see myself connecting more stuff to [IFTTT](https://ifttt.com). With respect to Notion, I'll likely continue to expand on my `notion-heroku` server and see what I can do with it.
