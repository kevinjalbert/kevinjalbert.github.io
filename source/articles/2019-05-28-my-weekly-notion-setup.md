---
title: "My Weekly Notion Setup"

description: "My note taking, tasks, and self-organization tools and systems have evolved over the years, and I'm feeling pretty confident that Notion is a keeper. It has this incredible range of flexibility that allows you to mould it to fit your needs. I want to showcase how I use Notion to organize and manage my week."

tags:
- notion
- productivity
- organization

pull_image: "/images/2019-05-28-my-weekly-notion-setup/notebook.jpg"
pull_image_attribution: '[notebook](https://flickr.com/photos/markusspiske/14164315519 "notebook") by [markus spiske](https://flickr.com/people/markusspiske) is licensed under [CC BY](https://creativecommons.org/licenses/by/2.0/)'

notes:
-
  date: 2019-06-04
  type: add
  content: Add YouTube links to supplementary videos.
---

I started using [Notion [Referral]](https://www.notion.so/?r=6b8d609eb50943419db4d87c67fa558e) early 2018 in a limited capacity as I was evaluating it as a potential tool to adopt. In a year's time, Notion, as a service, improved a lot and had garnered quite a following. It was at this point that I decided to fully commit to it.

My note taking, tasks, and self-organization tools and systems have evolved over the years, and I'm feeling pretty confident that Notion is a keeper. It has this incredible range of flexibility that allows you to mould it to fit your needs. I want to showcase how I use Notion to organize and manage my week.

# Features I Needed for my Week

I spend many weeks iterating and refining my weekly Notion template and I suspect that I'll continue to do so. I made a point to incorporate the following ideas into my template:

## Note Taking

I wanted my weekly template to have the idea of a daily scratch pad for note-taking. It would be my _go-to_ notepad when I wanted to jot something down.

The plan then would be to clean up the raw notes at the end of the day and, if needed, extract them into a proper location.

**Goal: Have a place for daily note-taking.**

## Journaling

I like the idea of journaling daily as it gives a place to do a quick reflection and analysis of the events that transpired that day. Due to the normal work/life divide, I feel that it might not be a bad idea to split the journaling to individually accommodate both work and personal.

**Goal: Have a place for daily journaling (work/personal).**

## Tasks

As I wanted to fully commit to Notion, I need to make Notion accommodate a task management system. My tasks in Notion will be backed by a database as this structure will better accommodate searching and organization. I want to be able to capture the following for tasks:

- Title
- Creation date
- Due date
- Completed date
- Tags
- Notes

Having a tailored view of the tasks of importance for the day is ideal. This will help me focus on what is next and what is currently on my plate.

**Goal: Have a master database of tasks, with a view to easily see relevant tasks at the current time.**

## Wins

Something that kind of falls in line with journaling is recounting the wins of the day. I want to explicitly call out wins in different areas of my life (i.e., work, family, etc...). To accomplish this, I'd also like the wins to be backed by a database for organization and searching capabilities. I want to be able to capture the following for wins:

- Title
- Creation date
- Tags
- Notes

In my weekly template, I want to see all the wins for the current week only. This is to simplify the view and keeps it in scope to the week.

**Goal: Have a master database of wins, with a view to easily see wins for the week.**

## Habits

I've used habit trackers in the past with little success. I recently discovered a technique called _[Lights by Ultraworking](https://www.ultraworking.com/lights)_ and it struck a chord with me. For more information, I recommend giving their [guide](https://ultraworking.gitbooks.io/lights/content/) a quick read.

In my weekly template, I want a _Lights_ spreadsheet/database that I can use to track habits and objectives for each day of that week.

**Goal: Replicate _Lights Spreadsheet by Ultraworking_ in my weekly template**

## Weekly Reflection

Finally, I wanted to be able to have a place to hold an end-of-the-week reflection. I want to be able to do a retrospective on the progress of my habits for the week. I've also been passively using [RescueTime [Referral]](https://www.rescuetime.com/ref/31263) for many years now, and I want to actively pay attention to my productivity and time allocation going forward.

**Goal: Have a place for a weekly reflection on habits and time allocation**

# How it all looks

> [Watch a Video that walks through the template](https://www.youtube.com/watch?v=ZwZMU5QeWgQ)

Given the above features, how does all of this look in practice? The following pages took some time to arrive at due to much tweaking and testing. As mentioned earlier, I fully expect these pages to continue to evolve in structure in the future.

## Week Page

The following is an annotated screenshot of what my week page looks like. Each numbered section is further described under its corresponding subheading. I decided to use the `Week ##` format for my page names as it's easy to use the sequential numbering and avoids issues with using specific days and handling crossover weeks (ie., May → June).

![](/images/2019-05-28-my-weekly-notion-setup/week.png)

### Quick Links (1)

This section has links to pages for the previous week and the next week, acting as a quick way to navigate sequentially between weeks. In addition, I have _common_ pages that I like to keep accessible here as well.

### Days (2)

This section has links to pages for each day within this week. The contents of the _day_ page is explained further below.

### Lights (3)

This database is essentially my port of [Lights by Ultraworking](https://www.ultraworking.com/lights). If you have not read the [guide](https://ultraworking.gitbooks.io/lights/content/) I recommend it as I'm not going to dive into the details of how it works. To make it work with Notion, I had to make some modifications:

- The database is embedded in the page (i.e., this is only for the current week). This is done so that each week can have _different_ objectives.
- The database's name is formatted as `YEAR > WEEK ## > Lights` so that it is easier to find via search.
- I couldn't really build any percentage or success statistics easily, so I just left them out. The colour coding of Yes/No/Half works out pretty well.
- I use an explicit empty row to help separate the different areas.
- I rename the default _name_ column to `.` and push it all the way to the right. This is done so that the objectives don't show up in Notion's search as all row's names are indexed.
- Each day is not dated as this simplifies the reuse of this table for subsequent weeks. I also don't feel I gain much from adding that information.

Throughout the day I end up looking at the Lights and updating them as I accomplish them. The presence of it also constantly reminds me of the objectives I want to meet.

### Wins (4)

This is a _linked database_ of a global database that holds all the _wins_. The benefit of this is that this linked database view can be filtered to the specific week. This allows me to look back at any week and see the victories.

![](/images/2019-05-28-my-weekly-notion-setup/wins-filter.png)

The Tags column for Wins (and later for Tasks) is a Notion _Relation_. This allows the column to reference other values from another database. The main benefit here is that I wanted to have a global set of tags that could be used in all my tables. I accomplish this using a strategy outlined in the [Notion sub-reddit](https://www.reddit.com/r/NotionSo/comments/ayvkcs/notioneers_level_up_your_tagging/), where I have a dedicated _Tags_ table:

![](/images/2019-05-28-my-weekly-notion-setup/tags.png)

### Weekly Review (5)

This section is where I can reflect at the end of the week. I currently look at the Lights and see what happened — are there any trends or areas to change? I also have a section to put a screenshot of my week recorded by RescueTime.

## Day Page

The following is an annotated screenshot of what my day page looks like. Each numbered section is further described under its corresponding subheading. I decided to use the `Month ## (Weekday)` for my page names as I find it easier to use and easier to search.

![](/images/2019-05-28-my-weekly-notion-setup/day.png)

### Previous/Next Day (1)

These two links are present to quickly allow me to pan through the days. When they are all linked properly, it's a pretty seamless way to navigate.

### Tasks (2)

Similar to the Wins linked database, I'm using the same approach here. There is a master Tasks database that holds all of my tasks. I end up using filters on the linked database to only show relevant tasks.

![](/images/2019-05-28-my-weekly-notion-setup/tasks-filter.png)

The tasks have the desired attributes that I mentioned earlier. The Tags column is a _Relation_, which is the same approach that was described for the Wins. The Status column helps me track tasks and assists with filtering. Each task also has full capabilities to add notes within the record. To me, this is where Notion excels for task management.

![](/images/2019-05-28-my-weekly-notion-setup/task-record.png)

### Notes (3)

This is just a flexible section to place random notes during the day. At the end of the day, I can clean up the notes and extract them into a larger page in Notion.

One great aspect of Notion is that you are able to search across all of the text, regardless of where the notes are located.

### Day Review (4)

This section is where the journaling aspect comes in. Again, this is a flexible place to reflect on the day from a personal and work perspective.

# Setting up the Next Week

> [Watch a video on how I setup the next week](https://www.youtube.com/watch?v=ZwZMU5QeWgQ)

I've covered my week/days setups, although this has only been for one week. Manually setting this up for every week would be a pain — fortunately you can _duplicate pages_ in Notion.

![](/images/2019-05-28-my-weekly-notion-setup/year.png)

By keeping a template that has mostly everything set up, I'm able to generate the next week in about 2 minutes. The days stay linked (even after renaming them), the linked databases are properly duplicated along with their filters, and a fresh Lights database is present. From my perspective, this is a huge win.

# Get your Own Version!

> [Click to get my Weekly Notion Template](https://kevinjalbert-shared-templates.notion.site/Week-Template-9d2dba2d4c164defb57cf8ff4299fc0c)

Notion has the ability to [duplicate public pages into your own account](https://www.notion.so/Duplicate-public-pages-d8a461baeeb54d91b156ff5559192321#d8a461baeeb54d91b156ff5559192321). You can use that functionality along with the above link to get my template. It can be a bit overwhelming, but I've placed some annotations in the template to help you set it up. If you have any questions, feel free to leave a comment on this post. I'm planning to keep this public template static even though my own template will evolve over time — this is all for the purpose of this blog post.

I am loving what this setup has done for me so far and I'm planning to keep moving forward with it, further customizing it to fit my needs.
