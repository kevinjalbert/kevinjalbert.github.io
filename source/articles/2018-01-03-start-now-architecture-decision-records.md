---
title: "Start Now: Architecture Decision Records"

description: "Stop asking questions about certain architectural decisions for a project. Implement Architecture Decision Records, and save the team and yourself future headaches."

tags:
- communication
- collaboration
- architecture

pull_image: "/images/2018-01-03-start-now-architecture-decision-records/filing-cabinet.jpg"
---

![](/images/2018-01-03-start-now-architecture-decision-records/filing-cabinet.jpg)
_[Filing cabinet](https://flickr.com/photos/mightymightymatze/2150298078 "Filing cabinet") by [mightymightymatze](https://flickr.com/people/mightymightymatze) is licensed under [CC BY-NC](https://creativecommons.org/licenses/by-nc/2.0/)_

While working on any project, you'll eventually need to make decisions regarding the task at hand. The decision that has to be made can vary in size and impact. Often we are in the context of a team, and these decisions are made in consultation with others. As time progresses, with new and old team members moving on and off the project, we'll start to question some of those decisions that were made in the past.

> Why was it done that way?

> Did we not consider this alternative?

> What was the context when that decision was made?

Save the team and yourself future headaches and plan accordingly for these types of questions now, by starting Architecture Decision Records (ADRs) for your project.

# What are ADRs?

I first read about ADRs in the [documenting architecture decisions](http://thinkrelevance.com/blog/2011/11/15/documenting-architecture-decisions) blog post by [Michael Nygard](http://thinkrelevance.com/team/members/michael-nygard). ADRs are a form of documentation that record any _architecturally significant_ decisions that impact a project. For an impact to be considered _architecturally significant_ within a software project context, Micheal stated:

> ... those that affect the structure, non-functional characteristics, dependencies, interfaces, or construction techniques.

Michael's blog post was focused on ADRs within the context of an agile software project, but I believe it can be applied across different domains. The affected values for what a decision might impact would have to be altered to suit the appropriate domain. For example, altering the customer support workflow could constitute a decision record as it significantly changes a business process.

I had recently read that [lightweight architecture decision records](https://www.thoughtworks.com/radar/techniques/lightweight-architecture-decision-records) had made it into the _adopt_ ring of [Thoughtworks Technology Radar](https://www.thoughtworks.com/radar) in the November 2017 edition. They note that the lightweight aspect of ADRs is to just have text/markdown files alongside software projects in their repositories.

Here is an example ADR (pretty meta as it is about starting ADRs):

```markdown
# 1. Record architecture decisions

Date: 2018-01-03

## Status

Accepted

## Context

We need to record the architectural decisions made on this project.

## Decision

We will use Architecture Decision Records, as described by Michael Nygard in this article: http://thinkrelevance.com/blog/2011/11/15/documenting-architecture-decisions

## Consequences

See Michael Nygard's article, linked above. For a lightweight ADR toolset, see Nat Pryce's _adr-tools_ at https://github.com/npryce/adr-tools.
```

I don't want to go into technical details of ADRs, as this blog post is to bring awareness to them, as well as tools/techniques around them. There is plenty of supplementary material in this blog post via links to other articles.

# Getting Started with ADRs

The biggest thing when adopting ADRs in your project is being consistent with them. As with any added process, it's easy to simply overlook the new parts if they aren't at the forefront of your mind. Within our software projects, we actually incorporate ADR consideration in our [GitHub pull request template](https://help.github.com/articles/creating-a-pull-request-template-for-your-repository/). It's a good idea to make sure all team members are all in agreement with using ADRs, as well as when to make one. You don't want a decision to be made that is not documented.

## Simplify ADRs with `adr-tools`

In addition to including a note about ADRs in our pull request template, there is more tooling to help out. In the spirit of being lightweight records, markdown files are the preferred way to write ADRs. The [`adr-tools` command line tool](https://github.com/npryce/adr-tools) is a great way to simplify the creation of ADRs. If you are on MacOS, back in May 2017, I got [adr-tools accepted into homebrew](https://github.com/Homebrew/homebrew-core/pull/13081), so now you can just `brew install adr-tools`.

There are a lot of configurations and features that exist within `adr-tools`. I'm going to go over some of the essentials, with examples. I highly recommend taking a deeper look into the tool itself to get the most out of it.

### Initialize Repository

With a new repository, you get started with `adr init`, which creates the following `doc/adr/0001-record-architecture-decisions.md` file for you. The contents of this ADR is actually the sample one presented above.

### Create New ADRs

When you want to add a new ADR, you can execute `adr new "Split up component XXXX into two modules"` which opens up a basic ADR template to fill in. It creates the next incremented ADR -- `doc/adr/0002-split-up-component-xxxx-into-two-modules.md`.

### Maintain Table of Contents

Most software projects have a `README.md` file. When working with ADRs, I include a hyperlink to `/doc/adr/README.md`. This file can be generated using `adr generate toc > ./docs/adr/README.md`, and ends up creating a nice table of contents of the current ADRs:

```markdown
# Architecture Decision Records

* [1. Record architecture decisions](0001-record-architecture-decisions.md)
* [2. Split up component XXXX into two modules](0002-split-up-component-xxxx-into-two-modules.md)
```

### Superseding Existing ADRs

Eventually, you will have a decision which is somehow _linked_ to another ADR. A great example of this is a new ADR which supersedes an older decision. First let us make a new ADR `adr new -s 2 "Combine modules back into one component"`, which ends up superseding our earlier decision. This will actually modify the ADR's _status_ section by adding the following:


```markdown
# In 0002-split-up-component-xxxx-into-two-modules.md
Superseded by [3. Combine modules back into one component](0003-combine-modules-back-into-one-component.md)
```

```markdown
# In 0003-combine-modules-back-into-one-component.md
Superseds [2. Split up component XXXX into two modules](0002-split-up-component-xxxx-into-two-modules.md)
```

It is useful to see how ADRs relate to each other. In our example, we're indicating one ADR that supersedes another. It is possible to use `adr link` to specifically tailor the link to use different wording, so you can be specific in how ADRs are associated. Ultimately, linking provides additional context surrounding linked decisions.

### Visualizing ADRs

With the ability to _link_ ADRs together, it now becomes possible to trace the story of a specific ADR. By following links you can understand the _bigger picture_ of how the architecture evolved over time. It can be hard to navigate one file at a time, so fortunately for us, `adr-tools` has us covered by being able to produce a visualization of the ADRs.

With `adr generate graph | dot -Tjpg > graph.jpg` we can generate the following image (using our example ADRs so far):

![](/images/2018-01-03-start-now-architecture-decision-records/graph.jpg)

It is quite apparent to see the ADR links in this diagram. I personally have not seen how well this scales, although it still is a good technique to be aware of.

Using `adr generate graph` by itself will return a [graphviz](https://graphviz.gitlab.io/) output. It would be interesting to attach this to the `/doc/adr/README.md` using the [gravizo](https://github.com/TLmaK0/gravizo) service. This way, the ADR visualization is always within reach and can be apart of the normal process when adding new ADRs. I have not personally done this approach, but it looks interesting.

## Searching ADRs

As we're just dealing with markdown files, it becomes trivial to search through the ADRs. The file names are the titles, so even at a glance, it becomes easy to narrow down what you are looking for. You can even use `adr list` to just list all the ADRs. In combination with other command line tools (i.e., grep) you can filter the list. I personally like using the [`fzf` command line tool](https://github.com/junegunn/fzf) to filter the list and open it in vim: `adr list | fzf | xargs vim`.

If you want to dig deeper you can search the contents of the files for what you are looking for. For example, `grep -l 'tool' ./doc/adr/*.md | fzf | xargs vim` would look for any file with _tool_ in it, and present the `fzf` interface for further filtering.

In the end, you can be creative on how you search through ADRs -- there is a lot of flexibility built into it. I usually use the [`tag` command line tool](https://github.com/aykamko/tag) for searching within files.

## Customizing ADRs

At this point, you might be thinking _"ADRs sound great, but it doesn't quite satisfy all my needs"_. The concept of ADRs is very general and flexible in nature so that if you have specific needs or requirements, you can customize it. In our case, we've been using `adr-tools` and it has a base template. You can change it, or use a different template. For example, it might be useful to look through [other templates](https://github.com/joelparkerhenderson/architecture_decision_record) to find one that fits your needs.

This post has been talking about using markdown files, but your ADRs could be held in any other medium (i.e., JIRA, Google Docs, etc...). I would argue to use what works best for your team. In most cases, within a software project, the markdown approach is nice as it's very lightweight and everything is contained in the source directory.

# TL;DR

* ADRs are a great way keep records of architectural decisions
* ADRs provide context surrounding architectural decisions
* ADRs can be lightweight as markdown files that live within your project's repository
* ADRs are searchable and customizable

> _The best time to start ADRs is at the start of a project; the second best time is right now_
