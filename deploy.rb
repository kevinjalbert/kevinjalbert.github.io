`git checkout real-master`

current_sha = `git rev-parse --short HEAD`.strip

`rm -R -f ./bower_components`
`rm -R -f ./build`

`bundle install`
`bower install`

`bundle exec middleman build`
`rm ./imageoptim.manifest.yml`
`rm -R -f ./bower_components`

`git checkout master`

`cp -r ./build/* ./`
`rm -R -f ./build`

`git add -f -A`
`git commit -m "Update site @ #{Time.now} with #{current_sha}"`
`git push`

`git checkout real-master`
`git clean -df`
