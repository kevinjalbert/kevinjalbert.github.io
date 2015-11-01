activate :blog do |blog|
  blog.calendar_template = 'calendar.html'
  blog.default_extension = '.md'
  #blog.generate_day_pages = false

  blog.permalink = '{year}/{month}/{day}/{title}.html'

  blog.sources = 'posts/{year}-{month}-{day}-{title}.html'
  blog.layout = 'post'
  blog.tag_template = 'tag.html'

  blog.paginate = true
end

page '/feed.xml', layout: false

set :css_dir, 'assets/stylesheets'
set :js_dir, 'assets/javascripts'
set :images_dir, 'assets/images'
set :partials_dir, 'partials'

set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true, smartypants: true

activate :automatic_image_sizes
activate :directory_indexes
activate :syntax, line_numbers: true
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
