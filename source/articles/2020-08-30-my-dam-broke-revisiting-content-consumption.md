---
title: "My Dam Broke - Revisiting Content Consumption"

description: "In this post I revisit the topic of content consumption, adding new criteria to my selection process. I also discuss using a new tool (spoiler...it's Notion) to hold the content."

tags:
- process
- learning
- notion

pull_image: "/images/2020-08-30-my-dam-broke-revisiting-content-consumption/dam.jpg"
pull_image_attribution: '[Dam Flood](https://flickr.com/photos/oldonliner/2708116493 "Dam Flood") by [OldOnliner](https://flickr.com/people/oldonliner) is licensed under [CC BY-NC-ND](https://creativecommons.org/licenses/by-nc-nd/2.0/)'
---

I've previously talked about [managing your content consumption](/consuming-content-and-managing-the-flood) using metaphors such as a dam, the flow of water, a reservoir, and a spillway. I highly recommend reading through if you are looking for some techniques to tame information overload. In case you don't want to read the above article, the main point is to focus on high-quality sources and don't consume everything.

Spoiler alert! Even though I wrote the above article, I have to revisit the topic as my metaphorical dam is broken. I'm finding myself facing the flood with 300+ articles in the reservoir. In this article, I will revisit content consumption management.

# System Check

I took a look at my content consumption from a system's perspective. There are four factors at play that determine the backlog of content to consume.

1. The pace at which I can consume content from my reservoir
2. The flow of content from sources making it to my dam
3. The effectiveness of my dam (i.e., the filter)
4. The effective removal of content that is no longer valuable.

Improving the pace at which I can consume content is tricky as it depends a lot on the amount of free time I can devote to it. I decided to focus on the other three factors instead as a way to distil the content down to the most valuable.

## Reducing the Flow

> The flow of content from sources making it to my dam

The _flow of water_ was the analogy I used in my dam metaphor for the rate of content coming in. This is tunable and can be controlled. I had advocated highly for the use of newsletters as they are narrow in focus and are filtered for good calibre pieces.

I want to keep tabs on where the good pieces of content are coming from. The importance and value of consumed content will change over time based on projects and interests. This means that I can remove specific content sources if they are underdelivering in value.

This is something I have done organically (i.e., _"I'll unsubscribe from this newsletter as I don't care about YYYY much anymore"_), but I want to put more of an objective system in place. To do this, I want to track the volume and perceived value gain from my content sources. I'll then routinely be able to revisit and see what is feeding into my content consumption pipeline and what is not.

## Effectiveness of Dam

> The effectiveness of my dam (i.e., the filter)

My goal of consuming content is to extract information and turn that into knowledge, ultimately being able to use that to produce results. With that in mind, the following are three guiding principles I've decided to use before committing to consuming a piece of content:

1. Is the information valuable in the long-term?
  - Prioritizing long-term knowledge will lead to [compounding knowledge](https://fs.blog/2019/02/compounding-knowledge/).
2. Is the information relevant to immediate projects?
  - Short-term knowledge is needed for the current situation.
3. Is the information uniquely valuable?
  - There are diminishing returns from consuming more content on the same topic.

Overall, I want to maximize the effectiveness and efficiency of knowledge extraction. The first two principles I'm carrying over from the previous system of content consumption. The third principle is new and should help improve the effectiveness of my dam.

Essentially I want the content to make it through the dam filter if `(content is long-term || content is relevant) && content is unique`.

Either of the first two principles must be true for the content to be of any value. It is worth noting that having both being true is the best scenario -- the information is relevant and long-term knowledge. The relevancy principle is important to have as I want to make sure that I'm not losing short-term gains on the projects and problems I'm working on.

### Filtering Examples

An example of something that would be filtered out is an article on _upgrading from Rails 5.x to 6.x_. I wouldn't consider this long-term knowledge as eventually, Rails will progress past these versions. There is no relevance for this article based on my current projects, and thus it should be filtered out. If afterwards I now have a project that would have benefited from this information, not all is lost as I would just _seek_ it, embracing _Just In Time_ learning.

Another example would be pieces of content around _empathy in code reviews_. This is great long-term knowledge, as well as relevant to my work. The problem is, I've already consumed something like this and have extracted and internalized the knowledge. This fails the third principle of being uniquely valuable, and thus I would filter these out. If at a later date, I'm doing a presentation or article on empathy in code reviews, I would employ _Just In Time_ learning to find all relevant information.

## Effectiveness of Spillway

> The effective removal of content that is no longer valuable.

Right before consuming a piece of content from the reservoir, I'll revisit the three principles. A piece of content may have lost relevancy, or is no longer going to provide unique value. This is a quick way of removing content.

With hopefully a smaller number of content sitting in the reservoir, this mechanism will be enough. In the event that the reservoir is overflowing, you can quickly sweep through everything and reevaluate. The key is to be ruthless, as important information will likely find its way back to you.

# Notion: The New System

I've previously used a mixture of applications to store consumable content. The main application I have used for articles is [Instapaper](https://www.instapaper.com). The new system demands more metadata and so I've made the switch to entirely use [Notion [Referral]](https://www.notion.so/?r=6b8d609eb50943419db4d87c67fa558e). I'll continue to use separate applications for podcasts and books, but they'll likely have _entries_ within Notion.

## The Reservoir

Everything is in a single database within Notion, these are the following fields.

- **Name**
  - A default text field that holds the name of the piece of content.
- **Type** (e.g., article, video, podcast, book, twitter thread, etc...)
  - A select field that specifies what medium the content resides in.
- **Origin** (e.g., XXXX Newsletter, XXXX Podcast, friend, etc...)
  - A select field that specifies how I discovered the piece of content.
- **URL**
  - A URL field that holds the link to the content, which in some cases might be blank depending on the content's type.
- **Criteria** (Long-Term, Relevant, and Unique)
  - A multi-select field that indicates the criterion that holds true for the piece of content
- **Value** (None, Low, Medium, and High)
  - A select field that indicates the value gained after consuming the piece of content.
- **Created At**
  - A timestamp field of when the piece of content was added.

These fields address the three principles within the _Criteria_ field, as well as metadata on how to reduce the flow of content via the _Origin_ and _Value_ fields.

Within desktop usage, I make use of the [Save to Notion](https://chrome.google.com/webstore/detail/save-to-notion/ldmmifpegigmeammaeckplhnjbbpccmm) extension as I can fill in more of the metadata from the browser. Within mobile usage, saving content takes another step as I have to go into Notion and add the metadata. For the most part, I try to make use of my desktop when adding content to the Notion database.

# Iterate and Evolve

I'll keep making changes and iterate on my content consumption system, hopefully making it better each time. The goal is still to turn pieces of content into information that I can use as knowledge.

The next thing I'm planning to tackle is the actual consumption part of the system and having a process for knowledge retention.
