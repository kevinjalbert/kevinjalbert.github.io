---
title: "Sharing Plex with Common Media Sense age-restrictions"

description: "Read how I've organized and shared my Plex media library for my kids. I've restricted the library to age-appropriate content using Common Sense Media and labels. The process is automated with the flexibility for manual overrides."

tags:
- Plex
- Kids

pull_image: "/images/2023-03-27-sharing-plex-with-common-media-sense-age-restrictions/dvds.jpg"
pull_image_attribution: '[Walmart, Merritt Island FL](https://flickr.com/photos/rusty_clark/8344342208 "Walmart, Merritt Island FL") by [Rusty Clark ~ 100K Photos](https://flickr.com/people/rusty_clark) is licensed under [CC BY](https://creativecommons.org/licenses/by/2.0/)'
---

I have a [Plex](https://www.plex.tv/) server which houses media for our household. With kids, I want to ensure that they don't have access to age-inappropriate movies and shows. I've taken a rather automated approach that leverages [Plex Meta Manager](https://metamanager.wiki/), but still provides the flexibility for manual override as needed.

## Common Media Sense Age Rating

The complexity around the (different) [Motion Picture Content Rating Systems](https://en.wikipedia.org/wiki/Motion_picture_content_rating_system) is fairly evident. Even with a selected system (i.e., [Canada's](https://en.wikipedia.org/wiki/Canadian_motion_picture_rating_system)) the ratings are still ambiguous on what might be appropriate for a certain age.

I decided to leverage the [Common Sense Media](https://www.commonsensemedia.org/) age rating for Movies, TV Shows, and Anime. This provides a more succinct age rating. To note, age appropriateness of media varies based on the child, so it doesn't hurt to double-check and manually override as needed.

## Automated Age Ratings using Plex Meta Manager

I use Plex Meta Manager to do the following tasks on a daily schedule:

- Add the Common Sense Media age rating on each item in the Library using the [Mass Content Rating Update operation](https://metamanager.wiki/en/latest/config/operations.html#mass-content-rating-update).
- Add an overlay (on the poster art) with the Common Sense Media age rating for each item in the Library using the [CommonSense Age Rating Overlay](https://metamanager.wiki/en/latest/defaults/overlays/commonsense.html#commonsense-age-rating-overlay).

The following is a slimmed-down snippet of my `config.yml` that adds the Common Sense Media age rating and displays it on the poster art. As you'll see in the example image, there are a lot of other Plex Meta Manager configurations in place to display ratings.

```yml
libraries:
  Shows:
    library_name: ⭐ Shows
    overlay_path:
    - pmm: commonsense
    operations:
      mass_content_rating_update: mdb_commonsense
```

![](/images/2023-03-27-sharing-plex-with-common-media-sense-age-restrictions/example-overlay-rating.jpeg)

In some cases, there might not be a Common Sense Media age rating available. When this scenario occurs, I just look around and make the best-educated guess (or I just be overly cautious), and set it manually in Plex.

## Manual Override using Labels

If needed, you can add a special _Sharing -> Labels_ on a media item to either include or exclude it from the Kid's account, regardless of the Common Sense Media age rating. The labels that I've chosen are `Override:Kids` for including, and `Override:Adult` for excluding.

![](/images/2023-03-27-sharing-plex-with-common-media-sense-age-restrictions/override-labels.png)

## Profile Restriction

The final piece of the puzzle is putting the actual restrictions on the Kid's account in Plex. As we can see in this setup, the account will:

- Allow any media that has a Common Sense Media age of 1-7
- Allow any media that has the manual _Sharing -> Label_ of `Override:Kids`
- Disallow any media that has the manual _Sharing -> Label_ of `Override:Adults`

![](/images/2023-03-27-sharing-plex-with-common-media-sense-age-restrictions/kids-restrictions.png)

I can add new age ranges as my kids grow up, and I can even introduce individualized profiles as required. I like having the flexibility to manually override age ratings for those times when we've watched the content as a family.
