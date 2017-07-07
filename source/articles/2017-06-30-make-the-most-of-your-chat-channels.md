---
title: "Make the most of your Chat Channels"

description: "Persisted chat channels communication platform, which by its nature, has little guidance in how you organize channels. To ensure that everyone is making the most of channels, I'll provided some tips and suggestions based on my experiences."

tags:
- communication
- learning
- productivity

pull_image: "/images/2017-06-30-make-the-most-of-your-chat-channels/communication-tower.jpg"
---

![](/images/2017-06-30-make-the-most-of-your-chat-channels/communication-tower.jpg)
_[Communication Tower](https://flic.kr/p/finMno) by [Cocoy Pusung](https://www.flickr.com/photos/95876508@N02/), on Flickr_

Organizations tend to use some instant messaging platform in addition to email. Ideally, the chosen platform permeates throughout the ranks of the organization instead of having fractured communication between members. The real-time and group collaborative nature of these messaging platforms are quite appealing.

I have personally used a couple of messaging platform so far (i.e., Hipchat, Gitter, Discord, Slack). Overall, they all offer the concept of channels. Channels are simply persisted chat _rooms_ in which members can communicate asynchronously. Topics and names of channels are left up to the members who use them.

My goal is to outline some steps to better foster an effective use of channels in your messaging platform of choice. I am currently using Slack at theScore, and so the context of this post will be within Slack.

# The Cleanse

> Macaitis recommends that if no one has used a channel for sixty days, it’s best to archive it. -- [Former Slack CMO, Bill Macaitis, on How Slack Uses Slack](https://expand.openviewpartners.com/former-slack-cmo-bill-macaitis-on-how-slack-uses-slack-868ffb495b71)

An organization that uses chat channels for communication will accrue an abundance of such. Some of these channels are used more frequently than others. To keep things slightly under control, you should routinely clean the channels. As to _who_ should be doing this, I would say everyone should try to keep their communication platform clean. There are a few benefits to this:

1. Keeps a more narrow focus within the organization
2. Easier for users to keep a handle on their channels
3. Newcomers feel less overwhelmed at the number of channels
4. Less ambiguity on where conversations/information should be put

Archiving channels doesn't have to be perfect, although there will be clear choices. If the need of the channel arises again, it can be recreated/unarchived as needed.

# Types of Channels

Channels tend to fall under specific categories that define their behaviour or purpose. For example, [Slack provides a guideline](https://slack.global.ssl.fastly.net/5ccb/pdfs/admins_guide.pdf) on what these channel types are:

## Global

> i.e., #general, #announcements, #everyone

A global channel is one that _everyone_ is apart of. Normally this would be a general channel, however productivity can be limited depending on the number of members -- it's more of a social channel. A common use case for using a global channel is for organizational announcements.

## Location

> i.e., #toronto, #ontario, #canada

An organization might be spread across many locations. These channels offer a way to group conversations that pertain to specific locations. How to name these channels depends on how your organization is structured geographically -- it might be based on cities, regions, or even offices within a city.

## Team

> i.e., #engineering, #engineering-ios, #sales, #designers

These channels are rather important in facilitating communication within teams. Realistically you would have high-level groups such as _#engineering_ that all your engineers are apart of. It would also be ideal to create _sub-teams_ to accommodate specializations such as _#engineering-android_ and _#engineering-web_. By following this naming convention for teams and sub-teams, the channels are _grouped_ and sorted through the naming convention.

## Project

> i.e., #sports-app, #chat-bot, #squadup

Often projects are underway. To help communication within that project, which might include individuals across different teams, a project channel is useful. As projects come and go, it might be worth archiving channels for projects that are no longer current.

## Topical

> i.e., #soccer, #javascript, #anime

To me, these are the interesting channels! The previously mentioned channels types were more geared towards business communication, and generally are easily formed around the business needs. Topical channels could be on anything that interests a group of people. Generally, these channels are organically formed within an organization.

## Temporary

> i.e., #xmas-party, #offsite-retreat, #brainstorm-session

These channels are short-lived and generally used for time-sensitive events. They have a specific purpose, and rarely offer much value after that purpose is completed. These channels could be deleted or archived when they are no longer needed. Channels are _cheap_ to create, and so people shouldn't be worried about making one-off channels to help them accomplish specific tasks.

# Organizing Channels

As we saw there are many categories of channels. To help with the organization of the multiple channels, a naming convention could be used.

One suggestion is to prefix all team channels with `team-` (i.e., _#team-engineering_). The same could be done with project channels using `project-` (i.e., _#project-esports_). The actual prefix doesn't matter as long as it is unique (enough) and consistent. A benefit is that channels are ordered alphanumerically, making it easier to browse active teams/projects. If you wanted, you could even take the same approach with topics (i.e., _#topic-soccer_).

Another idea is to have a _#meta_ channel where you can talk about improving the use of the platform itself. For example, new topic channels can be posted there, same with renames and such. Ensure everyone is a part of the channel so information travels. If there is support for it, you could also pin/sticky some guidelines on the platform (i.e., link to this article).

# Topical Channels (at theScore)

As previously mentioned, topical channels are the interesting channels that I want to touch on more here. I'll just say that this is coming from an software organization's perspective, as I am a part of theScore engineering team.

Here are a few of our topical channels:

  * _#ping-pong_
  * _#overwatch_
  * _#pokemon-go_
  * _#podcasts_
  * _#board-games_
  * _#food_

While these channels do provide topical information on their specific topics, we didn't really have engineering topic channels.

## Birth of Engineering Topical Channels

We were doing some recent work with [React](https://facebook.github.io/react/) and [GraphQL](http://graphql.org/), and we saw the birth of two engineering topical channels:

  * _#graphql_
  * _#react_

Before this work, we did not _really_ have engineering topical channels. This caused slight inefficiencies in the flow of knowledge through our engineering team. We made these new channels known at the engineering level, and also invited people who are actively working in the areas. This approach injected people who cared about the topic into the channel. As we go about our day and we find something interesting related to one of these topics, it becomes easy to drop that information into the channel. In addition, more specific questions can be asked in these channels as their topic is fairly narrow.

Eventually, you end up seeing people who are not _directly_ working in that topic area, but are still in the channel. To me this suggests people have an interest.

## Educational Value of Topical Communication

These specific topical channels on programming languages/frameworks/concepts are extremely beneficial to individuals, and the organization.

* Provides a place for focused conversations to take place. For example, if someone had a general GraphQL question where do you go to ask it? Possibly in one our engineering channels, or maybe a specific team that is using it? In this case, having a dedicated topical channel for _#graphql_ would be beneficial.
* Promotes people to widen their interests, as they can simply join a channel and _slowly_ absorb information. For example, if I was interested in _#machine-learning_, I could join the channel and occasionally I'll see people post links to articles, conference talks, and just general conversation on the topic.

There is great educational value in these channels, especially in larger organizations where there are many teams and projects. These channels offer a place to share findings and communication to prevent knowledge silos.

## Effective Slack Plan

Now at theScore, this is our plan in improving our usage of Slack channels:

  1. Archive channels with no activity in the last 60 days
  2. Rename team channels with the `team-` prefix
  3. Rename project channels with the `proj-` prefix
  4. Create a 2-level hierarchy for teams (i.e., _#eng_, #eng-ios)
  5. Create engineering topical channels (i.e., _#rails_, _#android_, _#swift_)
  6. Create a _#meta_ channel (along with a note to some channel conventions)

With routine maintenance, we will keep our Slack channels focused and organized. Hopefully we will see the benefit to education/knowledge sharing with the increased organization of our chat channels.

