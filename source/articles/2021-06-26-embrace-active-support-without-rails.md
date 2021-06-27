---
title: "Embrace Active Support without Rails"

description: "Read my opinion on using Active Support without Rails in Ruby-only projects. I think the benefits outweigh the cost. Active Support is a Ruby on Rails component that primarily extends the Ruby language providing, a richer experience to developers."

tags:
- ruby
- tools

pull_image: "/images/2021-06-26-embrace-active-support-without-rails/ruby-gem.jpg"
pull_image_attribution: '[DSCF5580](https://flickr.com/photos/jobafunky/4056697682 "DSCF5580") by [JOBAfunky](https://flickr.com/people/jobafunky) is licensed under [CC BY-NC-ND](https://creativecommons.org/licenses/by-nc-nd/2.0/)'
---

## What is Active Support

> Active Support is the Ruby on Rails component responsible for providing Ruby language extensions, utilities, and other transversal stuff.

> It offers a richer bottom-line at the language level, targeted both at the development of Rails applications and at the development of Ruby on Rails itself.

> -- [RailsGuides](https://guides.rubyonrails.org/active_support_core_extensions.html)

As a developer using Ruby, it is highly likely that you are using Rails in some projects. During your journey, you've likely touched aspects of Active Support without knowing it. Ruby, as a language, allows you to _redefine_ classes easily, almost to a fault. Active Support does exactly this.

Active Support does _a lot_ under the hood by modifying core Ruby classes. These core extensions provide more capabilities through new methods. If you are using Rails, Active Support is already there as a dependency. If you spend enough time on a Rails project, you'll reach for these methods from Active Support.

## Active Support Without Rails

The following are my opinions on when to use Active Support without Rails.

### Projects

In Ruby-only projects, you likely already require some gems, and at this point including Active Support just adds another dependency to the project. With Active Support, your project gains all those convenience methods you are used to.

The reality of the situation is that you are unlikely to use _all_ the features of Active Support. Yes, this dependency is a large one, although if you want you can be [selective in loading only parts of Active Support](https://guides.rubyonrails.org/active_support_core_extensions.html#how-to-load-core-extensions). If you need to optimize your project (i.e., no dependencies for portability, or optimized code for performance), you might be using the wrong language. Active Support does lazy-load parts of itself, so it might not even be as _heavy_ as you think.

In my Ruby projects I dislike reaching for something I'd typically use in a Rails project only to find out I don't have access to it (i.e., `10.days.ago`). Could I take an approach that doesn't require Active Support? Sure, but at what cost (i.e., time/complexity)? I love Ruby for its expressiveness and ease at _getting things done_. Active Support helps me do that better and faster.

**Opinion: Embrace Active Support and add it to your project's dependencies**

### Scripts

Small Ruby scripts are unique in the sense that they don't always have dependencies. Requiring that first gem in a script can feel _wrong_, although in my experience it's worth it. The boost in productivity that a gem provides when you are trying to script something together is immense.

Dealing with dependencies for scripts is a small inconvenience, as running a script without the required gems usually presents a clear error that is quickly remedied.

**Opinion: Embrace Active Support if you already require gems for your script or if you want methods that Active Support offers**

### Gems

If you are developing a Ruby gem, it would be best to not _force_ Active Support as a dependency without good reasons. If you absolutely need it, go for it -- ultimately it's your call as the maintainer. Now if your gem is inherently tied to Rails, then it's all good to include it.

**Opinion: Avoid Active Support unless you absolutely need parts of it, or if the gem is intended to be used in a Rails project**
