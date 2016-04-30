activate :blog do |blog|
  blog.default_extension = '.md'

  blog.permalink = '{title}'

  blog.sources = 'articles/{year}-{month}-{day}-{title}.html'
  blog.layout = 'article'
  blog.tag_template = 'tag.html'

  blog.paginate = true
  blog.per_page = 5
end

activate :search do |search|
  search.resources = ['articles/']
  search.index_path = 'search/lunr-index.json' # defaults to `search.json`
  search.fields = {
    title:   { boost: 100, store: true, required: true },
    content: { boost: 50 },
    url:     { index: false, store: true },
    author:  { boost: 30 }
  }
end

page '/feed.xml', layout: false

# Add bower's directory to sprockets asset path
after_configuration do
  sprockets.append_path File.join "#{root}", 'bower_components'

  Dir.glob('./bower_components/bootstrap/fonts/**/*').each do |file|
    sprockets.import_asset(file.split('/')[2..-1].join('/')) do |logical_path|
      Pathname.new('fonts') + logical_path.split.last
    end
  end
end

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'
set :partials_dir, 'partials'

set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true, smartypants: true

activate :automatic_image_sizes
activate :directory_indexes
activate :syntax

configure :development do
  set :root_url, 'http://kevinjalbert.dev'

  activate :livereload

  activate :disqus do |d|
    d.shortname = 'kevinjalbert-test'
  end
end

configure :build do
  set :root_url, 'https://kevinjalbert.com'

  # Not really useful when serving from Github Pages
  #activate :gzip
  #activate :asset_hash

  activate :asset_host
  activate :minify_css
  activate :minify_html
  activate :minify_javascript

  activate :imageoptim do |options|
    options.manifest = false
    options.skip_missing_workers = true
    options.nice = true
    options.threads = true
    options.pngout = false
    options.svgo = false
  end

  activate :disqus do |d|
    d.shortname = 'kevinjalbert'
  end
end
