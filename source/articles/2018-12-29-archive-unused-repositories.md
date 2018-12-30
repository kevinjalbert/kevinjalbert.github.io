---
title: "Archive Unused Repositories"

description: "Over time, an individual or organization will create a number of software projects. The purpose of these repositories is to facilitate libraries, micro-services, documentation, mono-repositories, etc. Every so often, the time comes when a repository is no longer used. This article will outline how to archive these repositories, and the benefits to be realized."

tags:
- process
- communication
- github

pull_image: "/images/2018-12-29-archive-unused-repositories/casket.jpg"
pull_image_attribution: '[IMG_6696](https://flickr.com/photos/bendibble/2965770392 "IMG_6696") by [BenDibble](https://flickr.com/people/bendibble) is licensed under [CC BY-ND](https://creativecommons.org/licenses/by-nd/2.0/)'
---

At the time of writing this article, [theScore](http://company.thescore.com/) has approximately 250 repositories hosted on [GitHub](https://github.com/). The majority of these are private, although some public ones do exist as well. I suspect that software companies of sufficient size eventually accumulate a large number of repositories due to new projects, libraries, experiments, etc. An employee being faced with these numbers can waste a lot of time searching through these repositories and determining whether a repository is actively used.

# The Burden

_Note: We'll be focused on GitHub as the platform of choice, although the same principals can be applied to other code hosting platforms._

Over time, a repository can fade in activity and end up in either a _finished and active_ or a _unused_ state. In the event that someone stumbles upon an unused repository, they can waste a lot of time if it's not clear that the repository is in fact unused. These repositories faded over time and so it will still have a detailed README and possibly open issues and pull requests. In the worst case scenario, an individual might put time and effort into addressing these unresolved issues to no benefits.

At theScore, we use [GitHub Teams](https://help.github.com/articles/about-teams/) to help determine the ownership of repositories. As you can guess, when you have unused repositories, this leads to a cognitive burden on the team. Routine tasks might involve going over all the repositories that a team owns, which just eats up time if you are unsure a repository is used or not.

In addition, theScore also uses services that periodically check for security violations or outdated dependencies. In a similar vein, these services are triggering for unused repositories, thus leading to more noise. In some instances, the services are priced by the number of repositories or invocations, and so unused repositories can lead to additional costs as well.

# The Solution

So one option that might have crossed your mind is to just delete/remove the repository. While it does the job of reducing the burden of having unused repositories, I would argue that there is a wealth of knowledge in the history of the repository and the code hosting platform (i.e., GitHub via issues and pull requests). A perfect example of where archiving makes a lot of sense is in open source software (i.e., like in [rails/actioncable](https://github.com/rails/actioncable)) -- you want to retain the open contributions and communications.

To prevent future confusion and wasted effort/time/cost, we've made a conscious decision to _archive unused repositories_. Fortunately, GitHub actually provides a mechanism for [archiving repositories](https://help.github.com/articles/archiving-a-github-repository/). I highly recommend giving [GitHub's blog post](https://blog.github.com/2017-11-08-archiving-repositories/) a read as it details how you use the feature and provides some recommendations for archiving.

The main takeaways of archiving a repository on GitHub are:

- The repository becomes read-only to everyone.
- Forks can still happen in the event someone wants to take the repository in a new direction.
- Archived repositories have a different appearance and can be filtered in a search.

# The Final Change

The first thing we do is create our final pull request, which adds the following notice to the top of the README:

```
# This repository is ⚰️ ARCHIVED ⚰️

FancyProject as a product has been sunsetted and decommissioned as the adoption was not as great as we were hoping for. Resources and efforts were moved to other projects. The last day of operation was on September 18, 2018.
```

This pull request has at least 4 major tasks in it:

### 1. Close All Open Issues and Pull Requests

We close the issues with the following message so that people know the reason why it was closed:

> Closing open issues and pull requests as the project is now archived (\<pr\_of\_final\_update\>).

A link to the pull request is also mentioned in the comment. We do this so the last pull request that GitHub includes all the issues and pull requests that were closed due to the archiving process. You can see an example of this in the image below:

![Closed issues and pull requests](/images/2018-12-29-archive-unused-repositories/closed-issues.jpg)

### 2. Set _Contributors_ to All Developers

When a repository is archived you cannot change the contributors (i.e., adding/removing teams). In the event that a repository was only visible to a subset of developers (it sometimes happens), we ensure our _developers team_ is a contributor before archiving. This subtle change makes it so everyone in the organization can see the repository (in the event it was needed for something).

### 3. Delete Repository from External Services

As part of the archiving process, we want to disable/remove any external services that might be monitoring the repository. For example, [Snyk](https://snyk.io/) checks for security vulnerabilities periodically, and would continue to do so unless disabled. As previously mentioned, some of these services are priced by invocations and/or the number of repositories, so it is important that this step is completed.

In the event that the repository represents a deployable project, you want to make sure you've taken steps to _decommission_ all aspects. For example, there might be servers, databases, cloud storage, etc., that are linked to this repository and need to be taken care of.

### 4. Archive Repository

Finally, with everything resolved, we can archive the repository in GitHub. Enjoy the event, as it simplifies the surface area of repositories you have to maintain.
