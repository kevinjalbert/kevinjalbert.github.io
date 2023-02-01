---
title: "Sync Twitter Following to a List"

description: "Check out how I automatically maintain a Twitter list of all my following so that I can get daily summaries in Readwise Reader."

tags:
- twitter
- tool
- process

pull_image: "/images/2023-01-31-sync-twitter-following-to-a-list/twitter-list.png"
pull_image_attribution: "Screenshot of my [Twitter List](https://twitter.com/i/lists/1618235532990980096) that I'm subscribed to in Readwise Reader."
---

I mostly use Twitter as a source of information (to some degree), but I don't want to be _checking_ Twitter all the time. I usually batch my consumption while keeping track of the timeline position (via the app I use). I don't produce content on Twitter (I just never really got into that aspect of it).

I was using Tweetbot and out of nowhere it just stopped working... [Turns out Twitter suspended access to 3rd party clients -- which killed Tweetbot (and many other clients)](https://tapbots.com/tweetbot/).

This become the forcing function to try [Readwise’s Reader](https://readwise.io/read) as my primary way to consume Twitter.

## Readwise Reader

I've recently adopted Reader to help facilitate my consumption of information. It's really a delightful _all-in-one_ application that allows me to collect/filter/consume/highlight content. Reader highlights are instantly sync to [Readwise (referral link)](https://readwise.io/i/kevin862) at no cost as it is bundled into the tool.

With the change in Twitter, I decided to embrace Reader's ability to provide daily summaries of tweets from a [Twitter List](https://help.twitter.com/en/using-twitter/twitter-lists).

## Twitter List of Followings

Due to how Reader's Twitter daily summaries work, I need a public Twitter List of people I'm following. I went about this by throwing together a quick script to do synchronize my following to a list using Twitter's API.

```javascript
const { TwitterApi } = require("twitter-api-v2");

const TARGET_LIST_ID = "xxxxxxx"
const MY_USER_ID = "xxxxxxx"

const client = new TwitterApi({
  appKey: "xxxxxxx",
  appSecret: "xxxxxxx",
  accessToken: "xxxxxxx",
  accessSecret: "xxxxxxx",
});

async function sync() {
  // Fetch all users I follow
  const myFollowings = await (await client.v2.following(MY_USER_ID, { asPaginator: true })).fetchLast();
  const userIdsFollowing = myFollowings.users.map(user => user.id);

  // Fetch all users in specified list
  const membersOfList = await (await client.v2.listMembers(TARGET_LIST_ID)).fetchLast();
  const userIdsInList = membersOfList.users.map(user => user.id);

  // Get users I follow that are not on the list
  const usersToFollow = userIdsFollowing.filter(id => !userIdsInList.includes(id));

  // Get users in the list that I don't follow anymore
  const usersToUnfollow = userIdsInList.filter(id => !userIdsFollowing.includes(id));

  // Set the list to private (avoid notifying users of being added/removed)
  await client.v2.updateList(TARGET_LIST_ID, { private: true });

  // Add new users to list
  for (const userId of [...new Set(usersToFollow)]) {
    console.log(`Adding ${userId} to list`);
    await client.v2.addListMember(TARGET_LIST_ID, userId);
  }

  // Remove users from the list I don't follow anymore
  for (const userId of [...new Set(usersToUnfollow)]) {
    console.log(`Removing ${userId} to list`);
    await client.v2.removeListMember(TARGET_LIST_ID, userId);
  }

  // Set the list back to public
  await client.v2.updateList(TARGET_LIST_ID, { private: false });
}

await sync()
```

Nothing too special with the above -- I've commented the code. The `.fetchLast()` should paginate automatically and grab all members (no guarantees what happens if you have a large following count). I also set the list to private before adding/removing users to avoid notifying them of changes.

When I run this script all users I'm following are synced to the list (adding/removing based on differences). I don't have to manage the list at all!

## Automating the Sync

The final step in making this syncing automatic. If following/removing someone on Twitter, it should be reflected on that list without any extra effort on my part.

I decided to use [Pipedream](https://pipedream.com/) and scheduled the execution of this script every hour. Pipedream makes this painless, and the free plan is _plenty_ for me. The great thing is that I don't have to worry about it anymore.

![](/images/2023-01-31-sync-twitter-following-to-a-list/pipedream-workflow.png)
