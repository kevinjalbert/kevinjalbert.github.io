---
title: "Rails ActiveStorage Configuration for Minio"

description: "Trying to configure Rails ActiveStorage for Minio as your storage provider? The default configuration does not work out of the box, so read on to see what configuration options you are missing."

tags:
- tools
- rails
- minio

pull_image: "/images/2018-02-26-rails-activestorage-configuration-for-minio/birdy-boxcar.jpg"
---

![](/images/2018-02-26-rails-activestorage-configuration-for-minio/birdy-boxcar.jpg)
_[birdy boxcar](https://flickr.com/photos/agent\_ladybug/661200957 "birdy boxcar") by [b.ug](https://flickr.com/people/agent_ladybug) is licensed under [CC BY-NC](https://creativecommons.org/licenses/by-nc/2.0/)_


You are looking at Rails 5.2 and its shiny new [ActiveStorage](https://github.com/rails/rails/tree/master/activestorage) -- a built-in abstraction/mechanism to handle file storage. You decide to give it a try and remove a dependency you normally use (i.e., [CarrierWave](https://github.com/carrierwaveuploader/carrierwave) or [Paperclip](https://github.com/thoughtbot/paperclip)).

For some reason, you decide to use [Minio](https://minio.io/) -- an Amazon S3 compatible open source project.

Looking through the ActiveStorage [documentation](http://edgeguides.rubyonrails.org/active_storage_overview.html) and [repository's readme](https://github.com/rails/rails/tree/master/activestorage), you figure out how to get everything working locally using ActiveStorage's `local` service.

Now it is time to try running everything, but with Minio as your file storage. Looking at your `config/storage.yml` you'll see the template for Amazon's S3:

```yaml
 amazon:
   service: S3
   access_key_id: <%= Rails.application.credentials.dig(:aws, :access_key_id) %>
   secret_access_key: <%= Rails.application.credentials.dig(:aws, :secret_access_key) %>
   region: us-east-1
   bucket: your_own_bucket
```

# Configuration Options

Now it's time to figure out how to use the S3 service in conjunction with your Minio server...

## Region

Your Minio server doesn't really support regions like Amazon's S3. Just keep it as `us-east-1` or your closest S3 region (although it really could be any string). From what I've seen, this is just used at the Amazon S3-level, and for your hosted Minio server it does not matter.

The `region` value is simply used to satisfy ActiveStorage and the `aws-sdk-s3` gem. If you omit the `region` option you get the following exception `missing keyword: region (ArgumentError)`. If you use an empty string for `region` you will see `missing region; use :region option or export region name to ENV['AWS_REGION'] (Aws::Errors::MissingRegionError)`.

## Endpoint

Your Minio server is hosted at some URL (i.e., https://minio123.com), so you'll need to inform ActiveStorage's S3 service about this _endpoint_. Luckily, it is just a matter of adding the URL endpoint to your configuration:

```
  endpoint: "https://minio123.com" # Points to your Minio server
```

You can also use ports on the endpoint (i.e., "http://localhost:9000").

## Force Path Style

So you have the endpoint and region all setup from a configuration standpoint. Your Minio server is also up and running, along with a bucket, `your_own_bucket`. You try to upload a file and see the following exception:

```
Aws::Errors::NoSuchEndpointError (Encountered a `SocketError` while attempting to connect to:

  https://you_own_bucket.minio123.com/RJioqjrTT4VmFobw5FhXkSby

This is typically the result of an invalid `:region` option or a
poorly formatted `:endpoint` option.

* Avoid configuring the `:endpoint` option directly. Endpoints are constructed
  from the `:region`. The `:endpoint` option is reserved for connecting to
  non-standard test endpoints.
```

Hmm... Well that didn't work out. If we look at the URL (https://your\_own\_bucket.minio123.com), we can see that it uses a bucket subdomain approach. However, Minio expects the bucket after the domain (i.e., https://minio123.com/your\_own\_bucket). Again, fortunately there is an configuration option we can add to _force this path style_:


```
  force_path_style: true # Needed to be compliant with how Minio serves the bucket
```

# Complete Configuration

At this point we covered all the configuration _gotchas_ to set up ActiveStorage with Minio. Namely, the missing and (mostly undocumented) `endpoint` and `force_path_style` options. The following is a complete configuration.

```yaml
 minio:
   service: S3
   access_key_id: <%= Rails.application.credentials.dig(:minio, :access_key_id) %>
   secret_access_key: <%= Rails.application.credentials.dig(:minio, :secret_access_key) %>
   region: us-east-1
   bucket: your_own_bucket
   endpoint: "https://minio123.com"
   force_path_style: true
```

It isn't a bad idea to have the configuration named `minio`, just so it is clear that it's a Minio file storage instead of the typical Amazon S3.
