---
title: "Document Storage: Migrating Evernote to Google Drive"

description: "Read about my document storage journey to understand the reasons why I'm moving from Evernote to Google Drive and ditching my Doxie Go for Genius Scan (a mobile scanner application). Included are steps for exporting out of Evernote and into Google Drive."

tags:
- process
- productivity
- evernote
- google

pull_image: "/images/2021-09-29-document-storage-migrating-evernote-to-google-drive/doxie-genius-scan.jpg"
pull_image_attribution: 'My Doxie Go Scanner box with my iPhone 11 showing the Genius Scan application'
---

I only really embraced a document storage solution when I acquired a [Doxie Go](https://www.getdoxie.com/) back in 2013. I was able to scan documents with [OCR](https://en.wikipedia.org/wiki/Optical_character_recognition) so that I could search their contents. I even paired it with an [Eye-Fi SD card](https://en.wikipedia.org/wiki/Eye-Fi) so that I could upload scans wirelessly to my Macbook Air. It was great. I embraced [Evernote](https://evernote.com/) as my document storage solution, as it hit everything and was highly recommended.

The times have changed. My Doxie Go has lost its battery capacity and dies after a few scans (you cannot scan when it's charging). The Eye-Fi company doesn't exist anymore, and my SD card is useless (trust me I tried to make it work). Evernote's software isn't looking so great anymore, and there is wavering hope around the company. On the flip side, mobile phones and their applications have greatly advanced in the last 8 years.

I decided to switch from using my Doxie with Evernote to using [Genius Scan](https://thegrizzlylabs.com/genius-scan/) with [Google Drive](https://drive.google.com/).

## Why Genius Scan

In my experimentation, Genius Scan performed exceedingly well against others with respect to the quality and speed of scans. In contrast to many other document scanning applications out there, you don't need a subscription to unlock the extra functionality -- it's a one-time purchase of approximately $10. You gain the ability to export automatically to a document storage solution of your choice -- I selected Google Drive.

## Why Google Drive

There are a number of reasons for picking Google Drive over Evernote:

  - Storage isn't a concern. You get 15 GB for free (which is a lot for documents), or you're likly already paying for additional storage anyways.
  - Evernote now requires me to pay ($90/year) for a subscription to search text inside documents
  - Evernote has all these other features that it has accumulated over the years that I don't utilize (feature bloat).
  - I share the account with my wife and so she'll have easy access as well.
  - Google Drive search is fairly powerful (it will search the content even without OCR)

The only issue I have is that the Google Drive search results interface is lacking compared to Evernote. Evernote provides a view containing a snippet of the search results in the context of the file. Evernote also has a preview of the selected note when navigating notes. In Google Drive, you just see the file names of the matches, forcing you to individually preview each file until you find what you need. That being said, the amount of times I've needed that level of precision in searching is infrequent.

## Migrating to Google Drive

I recently made the migration over to Google Drive -- overall, it wasn't too bad. The following outlines the steps I took:

1. Select each notebook from Evernote containing documents. I had multiple notebooks which acted as categories (e.g., Receipts, Bills, Taxes, etc...).
2. Right-click and open the export modal. Export using the 'Multiple web pages (.html)' file format.
3. Put these in a `Notebooks` directory.
4. Put the following Ruby script (`transform.rb`) in the same directory level as `Notebooks`:

    ```ruby
    require 'fileutils'
    require 'securerandom'

    Dir.glob("Notebooks/*").each do |notebook|
      puts "Processing #{notebook}"

      Dir.glob("#{notebook}/*").each do |note|
        # Only interested in directories as they hold PDFs, .html files exist here
        if File.file?(note)
          FileUtils.rm(note)
          next
        end

        puts "=> Processing #{note}"

        # Getting each file, renaming it and moving it to notebook directory
        Dir.glob("#{note}/*").each do |resource|
          file_name = [File.basename(note).chomp("files"), SecureRandom.alphanumeric(8), File.extname(resource)].join
          FileUtils.mv(resource, [notebook, file_name].join(File::SEPARATOR))
        end

        # Cleaning up empty note directories
        FileUtils.rmdir(note)
      end
    end
    ```

5. Run `ruby transform.rb`, which leaves only resources (e.g., PDFs, images) in their respected notebook directory. The resources are also named after the note in Evernote (using a random suffix in case multiple resources existed in a note).
6. Import the whole `Notebooks` directory into Google Drive where you want it.

I'll see how this new document storage solution works long-term, but I have high hopes. An added bonus with the mobile application approach is that it allows me (or my wife!) to scan stuff without needing to be in my home office.
