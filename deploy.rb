require 'tmpdir'

`git checkout real-master`

current_sha = `git rev-parse --short HEAD`.strip

`rm -R -f ./bower_components`
`rm -R -f ./build`

`git add -f -A`

`git commit -m "Temp commit"`

`bundle install`
`bower install`

`bundle exec middleman build`

Dir.mktmpdir do |tmp_dir|
  `mv ./build/* #{tmp_dir}/`
  `mv ./build/.well-known #{tmp_dir}/`

  `git checkout master`

  `cp CNAME #{tmp_dir}/`
  `cp .nojekyll #{tmp_dir}/`
  `cp README.md #{tmp_dir}/`

  `rm -R -f *`

  `cp -r #{tmp_dir}/* ./`
  `cp -r #{tmp_dir}/.well-known ./`
end

`git add -f -A`
`git commit -m "Update site @ #{Time.now} with #{current_sha}"`
`git push`

`git checkout real-master`
`git clean -df`

`git reset --soft HEAD~1`
`git reset`

`bower install`
