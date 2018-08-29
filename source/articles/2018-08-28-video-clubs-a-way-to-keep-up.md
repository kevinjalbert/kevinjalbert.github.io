---
title: "Video Clubs: A Way to Keep Up"

description: "Keeping up in your industry can be hard. Conferences offer industry-leading information and the direction of the community. Attending conferences is expensive in both cost and time. Learn how to start a video club to better consume conference videos in your workplace at a sustainable pace."

tags:
- culture
- learning

pull_image: "/images/2018-08-28-video-clubs-a-way-to-keep-up/projector.jpg"
pull_image_attribution: '[My domestic Laterna Magica, anno 2016](https://flickr.com/photos/137585461@N02/24997621676 "My domestic Laterna Magica, anno 2016") by [Sita Jacobsen](https://flickr.com/people/137585461@N02) is licensed under [CC BY-NC-ND](https://creativecommons.org/licenses/by-nc-nd/2.0/)'
---

As a knowledge worker, a lot of our time is spent thinking about problems and solutions. We rely on pattern matching and experience while working to make the best progress we can. Is there a way to accelerate our learning and keep a pulse on new, upcoming, and innovative solutions? I will be approaching this question from a developer's perspective, although the ideas presented here can be applied to other domains.

Being aware of best practices, new techniques, alternative frameworks, and really anything in general for your domain is good. I would attribute some of my successes to _surface knowledge_ (i.e., having a high-level understanding), as it allows you to know of alternatives and possible solutions. Obviously, you would dive deeper into the area if you are going to invest more effort into it. In a way, this promotes a _just-in-time learning_ philosophy, to focus on areas as needed. Again, the key is that you _know_ of these areas.

# Keeping up as Developers

I encourage developers to do the following, although from my experiences it's common for developers to be doing at least some of these activities already:

 - Read blog posts: low friction and easily discoverable source of information, it normally comes naturally while developing.
 - Listen to podcasts: commuter friendly, topical and timely due to the _real-time_ nature, interviews with high-calibre people can be insightful.
 - Read Books: a wealth of knowledge but require more time investment.
 - Attend meetups: allows for networking with like-minded individuals, local groups, talks or workshops, typically free to attend.
 - Attend conferences: like meetups but normally of a higher calibre and immersive, costs a lot of money to attend.
 - Watch conference videos: talks of a conference, without the cost and networking aspects.

I want to focus on the last point -- watching conference videos. To me, this activity presents an affordable solution to attending conferences (from a time/money perspective). Additionally, conferences sometimes have multiple tracks and so, even as an attendee, it is not possible to see all the talks. The videos from a conference are usually available a few weeks after the conference. To me, conference talks represent distilled knowledge condensed into 30-60 minutes.

I would argue that it is a developer's job to keep up with the community and to _learn_ from industry-leaders. It can be hard to find the time to watch these videos on your own (i.e., evenings or weekends). Not only is the time a constraint, but also if you are consuming a conference video by yourself you are missing out on valuable discussions with peers immediately after the talk. So in an effort to better facilitate the time for learning, I am proposing the following: to start a _video club at your workplace_!

# The Workings of a Video Club

At theScore, the way we've handled our video club has evolved over the years. Initially, the flow worked like so:

  1. See an interesting video to watch.
  2. Add video URL to video club page in wiki ([Confluence](https://www.atlassian.com/software/confluence)).
  3. Once a week people would gather at lunch for the video club.
  4. Watch the next video or one which the audience really wants to see.
  5. Discuss (maybe?).
  6. Continue on with the day.

This flow worked and to be honest was fine. The main issue we wanted to fix was more transparency and organization around the videos. By addressing these concerns, the idea is that we'd be able to surface the most desired videos to be watched, as well as better facilitating discussion and recording findings.

The next section outlines how we've changed our video club to better work for developers, mainly taking advantage of GitHub and Slack. These changes have been well received, and it seems to better encourage the functioning aspects of the video club. I do want to mention that this next section is going to be highly tailored to developers.

# Video Club on GitHub

We decided to move away from the wiki version of the video club to GitHub. The main reasons were:

- Better structure (i.e., issues, labels, etc...).
- Familiar to developers.
- Voting via _reactions_.
- Slack + GitHub integration for visibility.

## Setup Repository

The first thing we need is a repository `video-club` (or any other name you like). We only need two files in our repository:

The following is the content of the `README.md`:

```
# The Video Club
* Video club for weekly educational videos
* Place for tracking/voting/discussion
* Slack Channel #video-club

## Would like to group watch a video?
* Create an issue
* Throw some labels on it
* Get people to vote on it with the :thumbsup: reactions

## Each week the highest voted video is watched
* Discussion happens immediately afterwards
* Issue could be updated with large takeaway points
* Close the issue
```

The following is the content of the `ISSUE_TEMPLATE.md`:

```
## [Video Title -- Also should be issue title](video.url)

### Description
<!-- Talk's description -->

### Time Length
<!-- Length of the video (i.e., 16m, 1h10m) -->
```

## Videos as Issues

![](/images/2018-08-28-video-clubs-a-way-to-keep-up/issues.jpg)

As you can see in the above image, each _GitHub Issue_ represents a video within our repository. As we have an `ISSUE_TEMPLATE.md` each issue then follows a consistent format containing context and information about the video. Ideally, we want the inputting process for a video to be as low-friction as possible. Right now it is pretty quick to create a new issue for a video, although **one thing I would like to do is create a bookmarklet or browser extension to pre-fill an issue based on the video URL**. The following image illustrates an example video in our issue format.

![](/images/2018-08-28-video-clubs-a-way-to-keep-up/video-issue.jpg)

You can see that we take advantage of _Issue Labels_ as well to further categorize the videos. We're pretty loose with their usage, but it does provide additional context and filtering capabilities. One other aspect to notice is that we use _Issue Reactions_ to _vote_ on videos that a participant would like to watch at some point. These votes are then used to help _pick the next video_, as we will see in the next section.

## Picking the Next Video

One of the main draws to using GitHub Issues is that we can vote using the reactions and then and sort the issues by _votes_ (i.e., thumbsup reactions on the issue). This approach allows the participants to weigh in on what they would like to see. The end goal is that the most highly desired videos will be watched. By sorting the open issues by votes, the process of picking the next video is pretty straightforward.

![](/images/2018-08-28-video-clubs-a-way-to-keep-up/next-video-sorting.jpg)

## Discussion and Context

The fact that we have GitHub Issues gives us a space for discussion using _GitHub Comments_. After the video has been watched, we carry out a 5~ minute discussion and record the high-level takeaways. Our video club accommodates remote attendees (coordination is done via Slack), and in those situations, we use video conferencing to facilitate the discussion process.

Ideally, additional discussion can be carried out via more comments (even later after the video has been watched). We use GitHub for our projects, and having the videos as issues allows us to link to videos if we want to use them as references or talking points in other issues or pull requests. Finally, a video issue is closed after the initial discussion is written up for it. The following image demonstrates the aforementioned concepts.

![](/images/2018-08-28-video-clubs-a-way-to-keep-up/completed-video.jpg)

## Slack Integration

To increase transparency and engagement, we are using the [GitHub + Slack integration](https://slack.github.com/). This allows us to have events in our `video-club` repository to be pushed to our `#video-club` Slack channel.

When someone adds a new video, the issue's content (following the template) lets everyone know of a new video they could vote on:
![](/images/2018-08-28-video-clubs-a-way-to-keep-up/slack-new-video.jpg)

We use [Slack's channel reminders](/slack-reminding-users-and-channels/) to ping the room to ensuring that votes are cast prior to the time we'll watch a video. In addition, we announce a bit before what video we will watch based on the sorting of votes:
![](/images/2018-08-28-video-clubs-a-way-to-keep-up/slack-video-selected.jpg)

Discussion notes and comments are pushed through the channel to help surface further comments:
![](/images/2018-08-28-video-clubs-a-way-to-keep-up/slack-video-finished.jpg)

# Starting a Video Club

So, are you are psyched to start a video club in your workplace? Now, how do you sell the idea to your boss and peers? You are trying to take 60~ minutes every week or so to watch _videos_... it doesn't sound like a good use of work time. Again, the whole point of this is to improve yourself and that these changes will be reflected in the work you do (i.e., knowing better practices and tools).

There are different ways to go about starting a video club, and honestly, it could be as straightforward as asking your boss and peers. I personally think if you can _embody_ the change, it is an easier sell to the organization and your direct manager. First thing I would do is personally find a set of high-quality videos from a conference relevant to your domain (i.e., could even be old ones). Put these out in the open as great material that everyone _should_ watch at some point (which shouldn't be a stretch from the truth). Suggest a brown bag lunch event, everyone brings their lunch (or buys it) and watches the video during their lunch. Encourage discussion and see if there are any takeaways that might be directly related to the work at hand. Then, eventually, you start to transition to an organizational model (i.e., GitHub) and getting participation from your peers by suggesting videos.

This is a cultural shift you are trying to create, therefore it could be slow. I believe the end goal is to move away from the brown bag lunch and instead to a dedicated _meeting time_ so that the video club isn't taking up everyone's personal time at lunch. I've seen various attendees drop off due to external lunch plans. Hopefully, a higher attendance can be achieved if it's a normal meeting time. Overall, I would say either you'll get your manager/organization to buy into the idea, or you will be stuck doing brown bag lunches. **In either case, _you_ will be improving and investing in yourself.**
