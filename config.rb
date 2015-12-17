activate :blog do |blog|
  blog.default_extension = '.md'

  blog.permalink = '{title}'

  blog.sources = 'articles/{year}-{month}-{day}-{title}.html'
  blog.layout = 'article'
  blog.tag_template = 'tag.html'

  blog.paginate = true
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
activate :livereload

configure :build do
  activate :asset_hash
  activate :asset_host
  activate :gzip
  activate :minify_css
  activate :minify_html
  activate :minify_javascript
  activate :relative_assets

  activate :imageoptim do |options|
    options.manifest = true
    options.skip_missing_workers = true
    options.nice = true
    options.threads = true
    options.pngout = false
    options.svgo = false
  end
end
