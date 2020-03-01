---
title: "Moving from RSS Feeds to Email"

description: "Read about how I moved away from RSS Feeds to emails to consume content. I take advantage of newsletters and IFTTT to ensure that everything moved over to email."

tags:
- process
- ifttt

pull_image: "/images/2020-02-29-moving-from-rss-to-email/mailboxes.jpg"
pull_image_attribution: '[mails](https://flickr.com/photos/94444025@N07/32748161052 "mails") by [SKR_RGR](https://flickr.com/people/94444025@N07) is licensed under [CC BY-NC](https://creativecommons.org/licenses/by-nc/2.0/)'
---

I've briefly mentioned using RSS to email in [Consuming Content and Managing the Flood](/consuming-content-and-managing-the-flood/). In this post, I want to further describe this approach and how I've effectively moved away from RSS Feeds towards emails.

# RSS Readers

Back in the day, Google Reader was one of the most popular RSS reading services. I ended up using it and thoroughly enjoyed it. I was heavily invested in using RSS feeds and piped all the content I wanted through it.

Eventually, Google Reader was shut down and I made the move to [Feedly](https://feedly.com). I was not 100% happy with that service and decided to try a new approach with respect to consuming content from sites with RSS feeds.

# RSS Reader to Email (via Newsletters)

My goal was to see how I could achieve the same content consumption but without using RSS readers. My idea was to see if I could consolidate the services that I used daily.

I noticed that a lot of the content I was following via RSS had email newsletters. Newsletters worked out well for me, as they contained generally the same information. This also fit in with the whole _Inbox Zero_ movement, as I treated my email inbox as a list of _actionable items_ that I needed to address. I could work through these emails at my own pace, and if needed I could defer an item by pushing it into [Instapaper](https://www.instapaper.com).

Unfortunately, there were still some RSS feeds that didn't have an email newsletter option. In most cases, these feeds were for different content (e.g., screencasts, comics, music).

# RSS Reader to Email (via IFTTT)

I've been a big fan of [IFTTT](https://ifttt.com/) since it came out. Once again, I reached for this tool to help me with migrating the remaining RSS feeds to email.

The approach is quite simple as we're taking advantage of the [New Feed Item Trigger from the RSS Feed Service](https://ifttt.com/feed) and the [Send me an email using the Email Service](https://ifttt.com/email). When setting up a new applet, you just have to put in the RSS feed URL and that's pretty much it.

![](/images/2020-02-29-moving-from-rss-to-email/ifttt-applets.png)

The applets check and execute within seconds of when a new RSS item arrives. This results in rich-text emails being sent containing the content of the feed item.

![](/images/2020-02-29-moving-from-rss-to-email/email.png)

## Alternatives to IFTTT

I did find other alternatives to IFTTT that would accomplish the same end goal of getting RSS feed items into my email inbox.

- [Zapier](https://zapier.com/) - you will have to pay if you want more tasks (> 100) and zaps (> 5).
- [Blogtrottr](https://blogtrottr.com/) - has ads incorporated in the emails unless you pay.
- [Feedrabbit](https://feedrabbit.com/) - only allowed 10 subscriptions before you have to pay.

Overall, I found IFTTT to be a scalable and free solution that fits my needs.
