---
title: "Share Highlighted Articles"

description: "We are ever consuming articles on the web. In most cases, the articles that interest me are highly technical and informative. Just like a book, you would highlight the important passages for future recollection. In this post, I present my use of the Highly highlighting service to record, retrieve, and share highlights."

tags:
- tools
- learning
- communication

pull_image: "/images/2017-10-31-share-highlighted-articles/book-highlighter.jpg"
---

![](/images/2017-10-31-share-highlighted-articles/book-highlighter.jpg)
_[IB English](https://flickr.com/photos/quinnanya/3242150010 "IB English") by [quinn.anya](https://flickr.com/people/quinnanya) is licensed under [CC BY-SA](https://creativecommons.org/licenses/by-sa/2.0/)_

Here is yet another post on the topic of sharing knowledge to accompany my previous posts: _[Share Your Bag of Tricks](/share-your-bag-of-tricks/)_ and _[Knowledge and Screencast Culture](/knowledge-and-screencast-culture/)_. I've recently made another change to my day-to-day workflow that accommodates sharing knowledge -- highlighting articles.

# Information Recollection

In the software development world, I'm consuming a decent amount of articles from various sources. This is in a way how I keep up with the new changes in the landscape, which in its self could be an interesting short article on its own. I heavily use [Pocket](https://getpocket.com) to stash articles I find throughout the day and I then slowly consume them at my own leisure. I had it such that if I _favourite_ an article in Pocket then, through [Zapier](https://zapier.com) it will be saved in [Evernote](https://evernote.com). Evernote is my go-to note-taking and information recollection solution.

This approach works well, although I want to _distil_ and _reinforce_ the materials I'm consuming. My hypothesis is that I'll have more succinct notes within Evernote and thus able to take advantage of more narrow focus search efforts. I have settled on using a highlighting service to accomplish for marking important passages that end up being searchable in Evernote.

# Highlighting Services

I reviewed four highlighting services to find the best one that fits my needs. I quickly passed over [Diigo](https://diigo.com) and [Lumio](https://www.lumioapp.com), as they just didn't appeal to me. These next two were my serious contenders that I evaluated.

## [Liner](https://getliner.com)

Liner is a solid option for highlighting. The chrome extension works very well and is boiled down to the fundamentals: highlighting and comments. It offers a Pocket integration, which is nice, although not really needed. The ability to export highlights to Evernote is excellent, and as an off the shelf solution does what I need. The iOS application also is well done and works as expected. The sharing feature provides a link which renders the full article with highlightings in it, simple and effective -- [example Liner shared link](http://lnr.li/PbYky).

Even though there is a subscription at $5/month or $50/year, it is not really necessary. You get folder support along with, more colours and advance search. The colours I couldn't really care for, and the search will be covered by Evernote. Folders are also unimportant to me. Overall this means I don't have to pay for this service.

I really like Liner, and it almost made my pick. It satisfies all my needs, although it became my second choice as the next service Highly has a very neat _social_ feature.

## [Highly](https://www.highly.co)

Highly is very similar to Liner in terms of highlighting. It is, even more, streamline as it only offers highlights and drops comments. The main benefit I noticed with Highly is the [Highlight Layer](https://medium.com/highlight-to-share/the-highlight-layer-45b9a8e86476), which when you browse articles provides a social aspect to highlighting. This is pretty awesome as I can see a summary of new articles assuming someone has marked it up before me. In addition, the interface of the extension I would argue is slightly better than Liner. Highly also offers a Pocket integration like Liner. The iOS application for highlighting is also quite nice and offers a great user experience.

![Highlight Layer](/images/2017-10-31-share-highlighted-articles/highlight-layer.jpg)

I was pleasantly surprised with the highlighting experience, considering I didn't think you could improve much with highlighting. As you'll see, the highlighting will automatically expand to fill the words in case you didn't select them from the beginning or end:

![Smart Highlighting by Highly](/images/2017-10-31-share-highlighted-articles/highly-smart-highlighting.gif)

In contrast to how Liner displays the whole page with highlights when you share a link, Highly provides a summary page -- [example Highly shared link](https://www.highly.co/hl/FJrJO5TzhZt7d3). You can always drop into the context of the whole page, but this only works if you have the extension installed otherwise you get a prompt to install it.

Highly does offer a subscription as well for $2/month or $20/year, but all you get is private highlights. To me, that doesn't matter since I want everything to be public, and out in the open for others to benefit from.

The Evernote storage is non-existent in Highly... although I did counter this with a hacked together Zapier integration. That I'll cover in the next section.

Highly's excellent highlighting experience along with the social aspect sold me on it. Liner is a great contender and I am going to keep my eyes on it to see what they come up with in the future. Even though Highly didn't offer an Evernote solution, I was able to hack a more favourable one using Zapier.

# Evernote Notes with Highly and Zapier

As mentioned I want Evernote integration with the highlighting service I use, and with Highly it wasn't there. I was pleased with the rest of Highly that I was willing to make it work.

First thing I was looking at was the RSS feed that Highly provides, figuring I could tie this with Zapier. Turns out that there already existed a [Highly highlights in Evernote on IFTTT](https://ifttt.com/applets/iTCzjXUP-highly-highlights-in-evernote) already. The main issue is that the RSS feed has one item for each highlight. So you cannot aggregate all the highlights for a completed articled into one note. This wasn't going to do it for me.

You can email a Highly link, so I was going to just email them into Evernote. While this worked, there were a couple of issues:

1. Evernote's free account only allows 5 emails per month. I was not a paying customer and wasn't planning on taking the additional cost at the moment.
2. The email is heavily branded with Highly, as it is meant to be a link sent to someone other than yourself.
3. The title of the email was generic and uninformative -- _kevinjalbert sent you a highlight._

![Highly Share Email To Evernote](/images/2017-10-31-share-highlighted-articles/email-to-evernote.jpg)

Fortunately, with Zapier, you can chain multiple actions together (limit of 3 with a free account). Zapier allows for some powerful workflows, especially since you can use JavaScript or Python to manipulate data within the flow.

![Zapier Highly To Evernote Flow](/images/2017-10-31-share-highlighted-articles/zapier-highly-flow.jpg)

I use a Zapier inbound email trigger, that triggers when I email the share link from Highly. I then feed the HTML formatted email into a JavaScript function where I can clean up the `inputData.rawBody` and `inputData.htmlBody` and return an object for the next step.

```js
var titleRegex = /kevinjalbert's highlights\s+(.*)/g;
var linkRegex = /(https:\/\/www.highly.co\/hl\/.*)/g;
var timeRegex = /(.* Summary • .* Story)/g;

var htmlBody = inputData.htmlBody;

// Remove html, head, and body
htmlBody = htmlBody.substring(htmlBody.indexOf("<body") + 5);
htmlBody = htmlBody.substring(0, htmlBody.lastIndexOf("</body>"));

// Remove profile and divider
var before = htmlBody.substring(0, htmlBody.indexOf('<div class="main">'));
var after = htmlBody.substring(htmlBody.indexOf('<div class="article-meta'));
htmlBody = before + after;

// Remove redundant text
htmlBody = htmlBody.replace("kevinjalbert's highlights", "");

// Remove footer
htmlBody = htmlBody.substring(0, htmlBody.lastIndexOf('<div class="footer"'));

// Add wrapping div
htmlBody = "<div" + htmlBody + "</div>";

// Clean up nbsp
htmlBody = htmlBody.replace(/<div class="split-15" height="15" style="font-size:15px;line-height:15px;height:15px;overflow:hidden;background:transparent">&nbsp;<\/div>/g, '<div class="split-5" height="5" style="font-size:5px;line-height:5px;height:5px;overflow:hidden;background:transparent"><br /><\/div>');

return {
  articleTitle: titleRegex.exec(inputData.rawBody)[1],
  highlyLink: linkRegex.exec(inputData.rawBody)[1],
  timeSummary: timeRegex.exec(inputData.rawBody)[1],
  evernoteFormattedBody: htmlBody
}
```

Cleaning up the HTML body was an interesting task to make it conform to Evernote's [ENML](https://dev.evernote.com/doc/articles/enml.php) format. The code is a hack and brittle, but it works. I also extract the title so that I can ensure that the note's title is properly reflecting in Evernote. The final step is to put all this together into the Evernote action template.

![Zapier Create Evernote Note Template](/images/2017-10-31-share-highlighted-articles/zapier-create-evernote-note.jpg)

With the Zapier flow, I now get a succinct note with the highlightings for an article. It triggers instantly when I send the email from Highly.

![Zapier Formatted Email To Evernote](/images/2017-10-31-share-highlighted-articles/zapier-formatted-to-evernote.jpg)

# Highlighting Workflow

Now armed with my highlighter I can mark the good parts that I feel are most important when consuming articles online. With the ability to share summary links, I can better ensure that the take aways from the article surfaces easier. Finally, with my Evernote Zapier integration, I know that my highlighted information is always a few keystrokes away.

My goal is to highlight every article that lands in my Pocket. With Highly's social aspects I hope that my highlights help future readers. In a similar fashion, I am always pleased when I see that someone else has already highlighted an article for the key points.

Make sure to check out my highlights and [follow me on Highly](https://www.highly.co/by/kevinjalbert)
