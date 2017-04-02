---
title: "Cut Code Review Noise on GitHub"

description: "Code reviews on GitHub can be noisy and contain a lot of unnecessary chatter. We explore how to effectively coordinate code reviewing a pull request using GitHub's reactions and request review features."

tags:
- github
- code review
- collaboration

pull_image: "/images/2017-03-28-cut-code-review-noise-on-github/scissors.jpg"
---

![](/images/2017-03-28-cut-code-review-noise-on-github/scissors.jpg)
_[Painting scissors with light 4 by Zechariah  Judy, on Flickr](https://www.flickr.com/photos/9918311@N02/4268582634/in/photostream/)_


For this post I'm not going to detail my preferred approach for working through a source code change using GitHub's pull requests -- another post will likely contain this. I'm instead going to touch on GitHub's review requests feature, and present an effective and efficient way to handle code reviews with GitHub's interface.

# GitHub Review Requests and Reactions

GitHub, in late 2016, introduced [review requests](https://github.com/blog/2291-introducing-review-requests) to their platform. This was a welcome addition to code reviewing pull requests. It exposed a mechanism to request reviews without using _@mention_ or chat to get people's attention.

GitHub made it easier to identify pull requests that require your attention by [filtering review requests](https://github.com/blog/2306-filter-pull-request-reviews-and-review-requests). Additionally, GitHub also allowed review requests to integrate with their [protected branches](https://github.com/blog/2051-protected-branches-and-required-status-checks) feature. It became possible to prevent merging a pull request until at least one reviewer approved that pull request.

Last year GitHub released [reactions] (https://github.com/blog/2119-add-reactions-to-pull-requests-issues-and-comments) to simply reduce noise in large issues and pull requests. With this now you can simply add an emoji reaction instead of a new comment.

Overall, these are all incremental steps in the right direction towards the goal of a collaborative environment within GitHub. More and more, I find myself using review requests to communicate with other developers. Requesting a review now sends the appropriate notification to the individual. In the past, I would have pasted a link to the pull request in our chat room, or made an _@mention_ comment. By moving away from the old style of getting reviews, I find there is less _chatter_ and _noise_ for coordinating code reviews.

# Committed Reviewers

I'm going to introduce the concept of _committed reviewers_:

  > A _reviewer_ who is _committed_ to the overall quality and correctness of the pull request.

This implies that committed reviewers are individuals who give the final _approval_ for the pull request before merging.

This concept might not be applicable for various projects or organizations. I do recommend it, however, as it tends to promote higher quality code ending up in your codebase.

With GitHub's request reviewers feature, this means that if you are requested, you are now a committed reviewer. The pull request cannot be merged until all committed reviewers approve it. This prevents a scenario where a reviewer could still be working through a pull request when it's merged, wasting time and potentially missing issues. I have seen this happen when authors request numerous reviewers just to expedite the process.

# Coordinating Code Reviews

Imagine we're on a team of 4 people. You just created a pull request in GitHub. Now you want some eyes on the new changes you are proposing to put into the codebase.

You recall the old ways of using an _@mention_ just to get reviewers, same with pasting the link in our chat. You don't want to disturb the team with unnecessary noise. Instead, it is time to use the new request reviewers interface in GitHub.

![](/images/2017-03-28-cut-code-review-noise-on-github/reviewers-state-1.png)

You decide to directly request reviews from Jane and Bob, as you know they are familiar with this part of the system. You decided to request only two reviews as we have an informal rule of requiring two approvals before merging in any pull request.

![](/images/2017-03-28-cut-code-review-noise-on-github/reviewers-state-2.png)

Bob leaves a request for changes inquiring on one aspect of your code. In one of his comments he indicates that Mary had encountered a similar problem and her solution was slightly different from yours.

![](/images/2017-03-28-cut-code-review-noise-on-github/reviewers-state-3.png)

You read over the requested changes from Bob and make the corrections.

Mary chimes in regarding that comment and leaves some insight there for you. You read it over and leave a GitHub Reaction to express your thanks, which indicates that you acknowledged her comment.

![](/images/2017-03-28-cut-code-review-noise-on-github/reviewers-state-4.png)

You now need to signal to Bob that you addressed his concerns so he can look at the new changes you added. Instead of getting his attention via chat or a _@mention_ comment, you can remove and request him again for a review.

> Unfortunately, GitHub does not provide a one button click to request a review again from someone who is already a reviewer.

Bob receives a notification that he has been requested for a review and looks over the changes, finally approving it.

Jane gets back and also approves your pull request.

![](/images/2017-03-28-cut-code-review-noise-on-github/reviewers-state-5.png)

At this specific point you have the two approvals that we as a team decided is required before merging a pull requests. Mary's in a _comment_ state, which is fine as it indicates that she is not a _committed reviewer_.

You finally get around to merging in your pull request when you notice that Mary has added herself as a reviewer. She decided to give your pull request a complete review now as a committed reviewer. The intent was communicated through the request review.

![](/images/2017-03-28-cut-code-review-noise-on-github/reviewers-state-6.png)

Even though you got two approvals, you know that Mary is committed to reviewing your pull requests. At this point you wait for her results as to not waste her time, or to potentially miss any issues she might raise.

![](/images/2017-03-28-cut-code-review-noise-on-github/reviewers-state-7.png)

Everything looks great. You have approvals across the board, so hit that merge button!

## Less Noise and Wasted Time

A couple of things you might have noticed as we ran through that code review scenario:

No unnecessary commenting on the pull request to indicate that an individual has acknowledged something. GitHub Reactions provide an unobtrusive way for an individual to express themselves. Often reactions are replacing low-value comments (i.e,. _+1_, _LGTM_, _awesome!_).

No unnecessary _@mention_ comments to indicate that someone should review the pull request. In the past, we would have _@mention_ possible reviewers in the description or as comments in the pull request. The reviewers are now clearly indicated in the reviewers section of the pull request.

No unnecessary _@mention_ is needed to indicate a reviewer's request for change has been addressed. Previously, it was common to _@mention_ a reviewer when their concerns were addressed, thus causing noise with comments.

With the above points on _@mention_ you could also factor in that this communication could have been in chat (public channels or privately).

Another scenario that we have encountered in the past is that the reviewer would come back preemptively to review the pull request as they noticed new commits. The problem is that sometimes new changes are still being worked on and pushed up incrementally. This can potentially waste the reviewer's time as they have to look over more changes soon after.

As a reviewer, you know that you will receive a notification via GitHub when your attention is needed for a pull request. It also becomes easier to scan pull requests for where your action is required.

# Dealing with Notifications
There are a couple of options when dealing with notifications surrounding GitHub:

* Built-in web notification
* Email notifications
* Third-party application (depends on operating system)

I personally never got much benefit from the web notification, however, this could just be how I consume information. Without an actual notification appearing in my notification center (macOS), information doesn't reach me well.

Email notifications are currently my preferred approach, as I can receive request review notifications via email. In addition, with email you can get fancy with filters to further reduce notification to only what you want.

I use [Trailer.app](https://ptsochantaris.github.io/trailer/) in addition to email. With Trailer I am able to target specific repositories for native notification. Prior to review requests, this would have been my ideal approach for dealing with notifications at my work machine. There is active development to support the recent addition of GitHub review requests and reactions.

Regardless of delivery mechanism, take some time to figure how to deal with notifications. Each user will have different needs. For my case, I'm really only interested in emails about _Comments on Issues and Pull Requests_ and _Pull Request reviews_ on my _Participated Conversations_ (configured via [GitHub's Notifications](https://github.com/settings/notifications)).

# Keeping it all in GitHub

Going back to the above scenario, no use of direct form of communication was used to facilitate the code review, everything was kept within GitHub. Of course, deeper discussions should use those mediums, but the key is that the coordination of the code review was kept entirely in the GitHub platform. This reduces chatter and noise that we receive throughout the day, and keeps the GitHub pull request succinct.

Using review requests clearly states the next action for the reviewer and author. With both parties actively using the provided utilities in GitHub, code review collaboration becomes much more manageable.

 -----

# TL;DR

* The idea is to reduce the unnecessary noise within a pull request using GitHub's features.
* GitHub review requests keep state of each reviewer during the code review process.
* Make use of re-requesting a review when you have addressed a reviewer's concerns.
* Make use of reactions to acknowledge a comment if possible.
* Be aware of committed reviewers and ensure everyone knows of their roles.
* Ensure that all committed reviewers have approved the pull request before merging.

