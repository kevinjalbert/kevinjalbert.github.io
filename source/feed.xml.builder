---
layout: false
---

xml.instruct!
xml.feed xmlns: 'http://www.w3.org/2005/Atom' do
  site_url = 'https://kevinjalbert.com'
  xml.title 'Kevin Jalbert'
  xml.link href: URI.join(site_url, blog.options.prefix.to_s)

  xml.updated(blog.articles.first.date.to_time.iso8601) unless blog.articles.empty?
  xml.author { xml.name 'Kevin Jalbert' }
  xml.id URI.join(site_url, blog.options.prefix.to_s)

  blog.articles[0..10].each do |article|
    xml.entry do
      xml.title article.title
      xml.link rel: 'alternate', href: URI.join(site_url, article.url)
      xml.id URI.join(site_url, article.url)
      xml.updated File.mtime(article.source_file).iso8601
      xml.published article.date.to_time.iso8601
      xml.author { xml.name 'Kevin Jalbert' }
      xml.description article.raw_data[:description], "type" => "html"
      xml.content article.body, type: 'html'
    end
  end
end
