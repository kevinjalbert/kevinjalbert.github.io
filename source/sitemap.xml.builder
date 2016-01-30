---
layout: false
---
xml.instruct!
xml.urlset xmlns: 'http://www.sitemaps.org/schemas/sitemap/0.9' do
  sitemap.resources.select { |page| page.destination_path =~ /\.html/ && !(page.destination_path =~ /404/) }.each do |page|
    xml.url do
      xml.loc URI.join(config[:root_url], page.url)
    end
  end
end
