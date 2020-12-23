---
title: "Using URL Scheme Links in Notion"

description: "URL Schemes provide powerful ways to integrate applications together in the Apple Ecosystem. Notion, unfortunately, doesn't allow these URL Scheme links, as they are not 'valid' URLs. We can work around this by using a URL shortener to do some redirection."

tags:
- ios
- tools
- notion

pull_image: "/images/2020-12-22-using-url-scheme-links-in-notion/train-coupling.jpg"
pull_image_attribution: '[Sprat and Winkle 008](https://flickr.com/photos/david_e_smith/3566697122 "Sprat and Winkle 008") by [Dave_S.](https://flickr.com/people/david_e_smith) is licensed under [CC BY](https://creativecommons.org/licenses/by/2.0/)'
---

# Context -- the Integrations from Notion

I want to have the ability to link from [Notion [Referral]](https://www.notion.so/?r=6b8d609eb50943419db4d87c67fa558e) to other applications in the Apple ecosystem (e.g., [Things](https://culturedcode.com/things/)). If the application itself doesn't offer the integration, you can usually _hack_ something together using _URL Scheme links_ (also called [_x-callback-url_](https://support.apple.com/en-ca/guide/shortcuts/apdcd7f20a6f/ios)), which are defined by an application. For example, Things has an [excellent article](https://culturedcode.com/things/support/articles/2803573/) on how you can use URL Scheme links to interface with it.

# Problem -- the Invalid URL

Unfortunately, Notion doesn't recognize URL Scheme links (e.g., show _today_ in Things using `things:///show?id=today`) as valid URLs. Even if you try to edit an existing URL in Notion, it won't work.

This has come up as an issue in the [Notion subreddit](https://www.reddit.com/r/Notion) [numerous](https://www.reddit.com/r/Notion/comments/azfnef/urlscheme_plz/) [times](https://www.reddit.com/r/Notion/comments/gcx4nw/links_to_other_apps_xcallbackurl/).

# Solution -- the URL Shortner

By using a URL shortener service (in this case [TinyURL](https://tinyurl.com/)), we can create valid URLs that Notion will let us use. These URLs will open the browser and the redirection will then trigger the URL Scheme.

For a full demo of how this all works, you can watch the following short video I recorded.

<iframe class="youtube-embed" src="https://www.youtube.com/embed/cQvTnq9m_gg" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

To make the generation of these TinyURLs easier, I created an [iOS Shortcut](https://support.apple.com/en-ca/guide/shortcuts/welcome/ios) that simplifies it by using the TinyURL's API. You can grab the shortcut [here](https://www.icloud.com/shortcuts/ab01776c15a442938fe18f1e5f786586), or just recreate it yourself using the following template:

<div style="display: flex">
  <img src="/images/2020-12-22-using-url-scheme-links-in-notion/shortcut.jpeg" style="width: 49%; height: 100%"/>
</div>

# Future -- the Endless Possibilities

I do hope that Notion eventually _allows_ for URL Scheme links to be used without any URL redirection needed. For the time being, however, this workaround does the trick.

With iOS Shortcuts, there are countless possibilities available to you. You can initiate _anything_ from a URL link in Notion now.

Imagine using this technique in Notion databases -- having a URL column that does something on your device when you open it.

Creating a crude integration starting from Notion leading into another iOS Applications is entirely doable, for example:

  - Open Things to specific project pages
  - Link to an external artifact (e.g., Email from [Spark](https://sparkmailapp.com/), Note from [Bear](https://bear.app/), etc...)
  - A [Shortcut that kicks off a daily review](/daily-review-using-ios-shortcuts-and-scriptable).
  - A Shortcut that fires off an HTTP request that triggers an external API.

Each application provides its own URL Scheme, although this [site](http://x-callback-url.com/apps/) does a decent job cataloging URL Schemes of popular applications.

The possibilities are truly endless.
