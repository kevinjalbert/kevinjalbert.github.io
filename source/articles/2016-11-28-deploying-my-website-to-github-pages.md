---
title: "Deploying my Website to GitHub Pages"

teaser: |
  A little history on my website, and the underlying framework I have used -- Middleman. I walkthrough the process on how I deploy the website to GitHub pages using a deployment script.

tags:
- ruby
- middleman
- github

---

## History of my Website
Let's look back at my website back in early [2012](https://web.archive.org/web/20120122125850/http://kevinjalbert.com/):

 - It was built using [nanoc](http://nanoc.ws/) as I was learning and enjoying using ruby. This static site generator seemed like a great tool when I started. It gave me a lot of control as I was able to write [custom ruby helpers](https://github.com/kevinjalbert/website/blob/master/lib/helpers/custom_helper.rb) to assist in generating the website.
 - It was focused on showcasing my academic accomplishments such as publications/posters/presentations and projects as I was still in the education system and going down the academia career track.
 - The original [GitHub repository](https://github.com/kevinjalbert/website) for this version of the website still exists, if you were interested in looking at it.

After finishing my M.Sc degree I decided to work in industry instead of pursuing a Ph.D. I continued to update the website with minor changes, but for the most part it stagnated over time.

## Deciding on Middleman
I eventually wanted to revamp my website to be more _relevant_ and decided going with a blog to document my technical endeavors and musings. I retired the old website and built up the new blog from scratch. I look through the [Ruby Toolbox](https://www.ruby-toolbox.com/categories/static_website_generation) to see the alternatives to nanoc. Top pick seems to be [Jekyll](https://github.com/jekyll/jekyll), which is likely contributed to its painless integration with [GitHub Pages](https://help.github.com/articles/using-jekyll-as-a-static-site-generator-with-github-pages/).

My two main concerns with Jekyll were:

- The use of [Liquid Templating](https://jekyllrb.com/docs/templates/) - I was personally not a fan of it.
- To benefit from the tight integration with GitHub, you are restricted to certain [Jekyll plugin gems](https://pages.github.com/versions/) and no custom plugins.

The second contender is [Middleman](https://middlemanapp.com/). Its offering was very similar to nanoc. I decided to give Middleman a spin as it was new and different from nanoc. For hosting I could figure it out later, although I was still leaning towards a manual usage of GitHub Pages as it was a free hosting solution.

## Deployment Approach
With the initial work on the new blog being completed, it was time to handle the deployment of it. As previously mentioned I was still going to use GitHub pages due to its free offering. All the work can be seen in the [kevinjalbert/kevinjalbert.github.io repository](https://github.com/kevinjalbert/kevinjalbert.github.io). A few things to note:

- User GitHub Pages at the time was only deployable from the `master` branch of the github repository.
- If the website used Jekyll then GitHub would automatically generate the static site and deploy it appropriately.

To accommodate this I decided to treat `master` as the holding ground for the generated Middleman output. With respect to where to place the actual Middleman code, I placed everything in a new branch `real-master`.

After a quick setup on GitHub, anything in the `master` branch would be deployed to the public.

![GitHub Configuration](/images/2016-11-28-deploying-my-website-to-github-pages/github-configuration.png)

To reduce friction in deploying new changes, I created the following [ruby deploy script](https://github.com/kevinjalbert/kevinjalbert.github.io/blob/424c42a5bd65cefb083a01e49f94cbc2e3a73e82/deploy.rb).

```ruby
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

  `git checkout master`

  `cp CNAME #{tmp_dir}/`
  `cp README.md #{tmp_dir}`

  `rm -R -f *`

  `cp -r #{tmp_dir}/* ./`
end

`git add -f -A`
`git commit -m "Update site @ #{Time.now} with #{current_sha}"`
`git push`

`git checkout real-master`
`git clean -df`

`git reset --soft HEAD~1`
`git reset`

`bower install`
```

Now, when everything is committed on `real-master` and I'm ready to deploy I just run `ruby deploy.rb`. The following is then carried out:

1. Ensure that I'm on the `real-master` git branch
2. Remove all the generated directories
3. Add everything to a temporary commit
4. Install all dependencies needed and build the Middleman website
5. Create a temporary directory and put the built website in it along with the _CNAME and README.md_ files
6. Clear the current directory and put everything from the temporary directory (i.e., the build website) into the current directory
7. Add everything to git and make a new commit with the current timestamp and git SHA that was used to generate the website
8. Push new website changes to `master`
9. Checkout `real-master` again, clean everything, and reset that temporary commit
10. Reinstall dependencies so we are back in a good state

This results in a [formatted commit log](https://github.com/kevinjalbert/kevinjalbert.github.io/commits/master) on `master` that has snapshots of each deployment of the website.

## That's All Folks
This approach is working well for me at the current moment. I'll probably keep using Middleman for the foreseeable future. I am sure I will go through another phase of redesigning this process, in which I will document yet again.
