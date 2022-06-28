---
title: "Import Raindrop.io Highlights into Readwise"

description: "I really like how Raindrop.io handles highlights and bookmarking in general. As of the time of writing, there isn't any official solution to import Raindrop.io highlights into Readwise. Check out my script that bridges this gap until an official integration exists."

tags:
- knowledge
- raindrop
- readwise

pull_image: "/images/2022-06-28-import-raindrop-io-highlights-into-readwise/output.png"
pull_image_attribution: 'The output of the import script. Generated with [Carbon.now.sh](https://carbon.now.sh/).'
---

# Raindrop.io

I've recently discovered [Raindrop.io](https://raindrop.io/) as a bookmarking/highlighting service. It has been refreshing to use as it exudes polish. The browser extension is nice as it indicates if you've bookmarked the page already, shows you highlights on the page, and allows you to highlight the content of the page. The iOS client is also great and does everything I need. The cherry-on-top is that the _free_ plan is very capable and has unlimited highlights per article.

# Readwise

I've been a user of [Readwise](https://readwise.io/) for over two years at this point. It's an important service for me as it allows me to revisit article's key points that I've highlighted. Readwise has many integrations to import highlights into it. I've been using [Hypothesis](https://web.hypothes.is/) for a while, which has an official Readwise integration.

# No Official Integration

As I moved over to Raindrop.io, it dawned on me that Readwise doesn't yet have any official integration with Raindrop.io. I've emailed Readwise about this and got the following:

> You're actually one of the first to request an integration with Raindrop.io. I've noted your request in our system, so as more users request the integration then it'll move up in the queue to develop.

I didn't want to wait around and I noticed that both services have an API...

# Import Raindrop.io Highlights into Readwise

Looking at both the [Readwise API](https://readwise.io/api_deets) and [Raindrop.io API](https://developer.raindrop.io/), it seemed fairly straight-forward to connect them up.

- Iterate highlights in Raindrop
- Import highlights to Readwise

It was noted that Readwise _de-dupe highlights by title/author/text/source_url_, so the API was idempotent if I send the same highlights.

I did hit a couple of snags in building my solution:

- Highlights didn't have the title or author of the article
  - I used `nokogiri` to fetch these from the article's URL
- How to know when I've already processed a highlight
  - Highlights were ordered by last created.
  - I keep track of the last uploaded highlight's ID from Readwise, this acts as the marker to know when I've caught up with the last import.
  - The marker ID is automatically recorded in the script for future executions.

# Waiting for the Future Official Integration

My approach works and only requires to be run periodically. I've been toying around with the idea of just having a `cron` run it for me hourly.

I didn't put in annotations from Raindrop.io (as I'm using the free plan for now), but it wouldn't be hard to add that.

I didn't bother removing highlights from Readwise when highlights are _deleted_ on Raindrop.io. I noted that this is the [default behaviour with Readwise according to their FAQ](https://help.readwise.io/article/95-will-deleting-a-highlight-in-readwise-delete-the-original-or-vice-versa):

> if you delete the highlight in the original source, the highlight will not be deleted in Readwise.

An official integration would be nice, but until then this does the trick.

# The Import Script

The following is the Ruby script for importing Raindrop.io highlights into Readwise. You need to acquire your API tokens for both services and substitute them into the placeholders.

This [GitHub Gist](https://gist.github.com/kevinjalbert/1d77add23d9bdaa615a5bd5c05328678) will be the canonical reference of the import script (and will see updates as needed).

```ruby
#!/usr/bin/env ruby

require "httparty"
require "nokogiri"
require "open-uri"
require "uri"

RAINDROP_AUTH_TOKEN="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
READWISE_AUTH_TOKEN="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
LAST_SAVED_HIGHLIGHT=000000000 # <- Keeps track of import position (Updates automatically)

def title_from_url(url)
  URI.open(url) do |f|
    doc = Nokogiri::HTML(f)
    title = doc.at_css("title").text
    return title
  end
end

def domain_from_url(url)
  URI.parse(url).host.gsub(/^www\./i, "")
end

def request_raindrop_highlights(page)
  HTTParty.get("https://api.raindrop.io/rest/v1/highlights?page=#{page}&perpage=50",
    headers: {
      "Authorization" => "Bearer #{RAINDROP_AUTH_TOKEN}",
      "Content-Type" => "application/json"
    },
  )
end

def save_highlight_to_readwise(highlight)
  HTTParty.post("https://readwise.io/api/v2/highlights/",
    headers: {
      "Authorization" => "Token #{READWISE_AUTH_TOKEN}",
      "Content-Type" => "application/json"
    },
    body: {
      highlights: [
        {
          text: highlight["text"],
          title: title_from_url(highlight["link"]),
          author: domain_from_url(highlight["link"]),
          source_url: highlight["link"],
          category: "articles",
          highlighted_at: DateTime.parse(highlight["created"]).iso8601
        }
      ]
    }.to_json
  )
end

def update_last_saved_highlight_value(last_highlight_value)
  puts "Updating last saved highlight value to #{last_highlight_value}"
  content = File.read(__FILE__)
  updated_content = content.sub(/LAST_SAVED_HIGHLIGHT=\d+/, "LAST_SAVED_HIGHLIGHT=#{last_highlight_value}")
  File.write(__FILE__, updated_content)
end

first_highlight_id = nil
page = 0
while true
  puts "Processing Raindrop.io highlights from page #{page + 1}"
  raindrop_highlights = request_raindrop_highlights(page)["items"]

  if raindrop_highlights.empty?
    puts "No more highlights to process"
    update_last_saved_highlight_value(first_highlight_id)
    exit
  end

  raindrop_highlights.map do |highlight|
    puts "-> Importing highlight into Readwise (#{[highlight['link'], highlight['created']].join(', ')})"

    saved_highlight = save_highlight_to_readwise(highlight).first

    saved_highlight_id = saved_highlight["modified_highlights"].first
    first_highlight_id = saved_highlight_id if first_highlight_id.nil?

    if saved_highlight_id == LAST_SAVED_HIGHLIGHT
      puts "Reached last saved highlight"
      update_last_saved_highlight_value(first_highlight_id)
      exit
    end
  end

  page += 1
end
```
