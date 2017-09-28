---
title: "Synchronizing my dotfiles"

description: "Overtime, you accumulate a set of configurations and dotfiles. To ensure a consistent environments across machines you want to have access to the same dotfiles. I share my synchronization approach along with how to keep the private and public information separate."

tags:
- tools
- learning
- dotfiles

pull_image: "/images/2017-09-28-synchronizing-my-dotfiles/github-dotfiles.jpg"
---

![](/images/2017-09-28-synchronizing-my-dotfiles/github-dotfiles.jpg)
_[My dotfiles repository on GitHub](https://github.com/kevinjalbert/dotfiles)_


I always strive to [share my bag of tricks](/share-your-bag-of-tricks/). Hosting [my dotfiles on GitHub](https://github.com/kevinjalbert/dotfiles) is one way I can share the tricks and tips I've picked up over time. In addition, this makes it easy to replicate my development environment on another machine if needed.

There are some technical challenges I've had to overcome in open-sourcing my dotfiles. My dotfiles is a living repository, it is constantly changing as I tweak my environment. I recently encountered a situation where I have two physical machines to use for development. I want a simple and comprehensive solution for synchronizing my dotfiles, both the private and public content, between both machines.

# What are dotfiles?

Jump right to the next section if you are already familiar with the dotfiles concept. The basic principle is that someone's dotfiles are a set of the files that represent the configurations of applications and utilities (usually consisting of many _\<dot\>files_, for example `.zshrc`).

As a developer, we have many tools at our disposal, and in many cases they are essential to our day-to-day work. The main reason to care about your own dotfiles is to ensure that you can replicate your working environment again. That alone is huge if you ever have to move to a new machine. It is a common pattern to push up your dotfiles to the cloud for back up purposes. I have most of mine on GitHub. The following points answer [why you would want your dotfiles on GitHub](https://dotfiles.github.io/):

> * Backup, restore, and sync the prefs and settings for your toolbox. Your dotfiles might be the most important files on your machine.
> * Learn from the community. Discover new tools for your toolbox and new tricks for the ones you already use.
> * Share what you’ve learned with the rest of us.

# My dotfiles

Since the beginning, I have hosted my dotfiles on GitHub. For the most part, I've only had one machine for development, and so I would slowly push my tweaks to my dotfiles repository.

I've built up a [Rakefile](https://github.com/kevinjalbert/dotfiles/blob/6585c9a7e1ae1926fcaf2210d48be23a2e988bdb/Rakefile) that orchestrates the install/update/backup/uninstall operations of my dotfiles.

My dotfiles are specific for MacOS and take advantage of [homebrew](https://brew.sh/) to bootstrap the system. In addition, I also use [homebrew cask](https://caskroom.github.io/) and [mas](https://github.com/mas-cli/mas) to install system applications.

As previously mentioned, my dotfiles is a living repository -- it will continue to evolve and change. I make no guarantee that it'll still operate or use the same solution at the time this article was written. The `README.md` in the repository should always reflect the state of my dotfiles (although admittedly they are lacking as I write this).

## Mackup + Dropbox Synchronization

I've recently stumbled upon [Mackup](https://github.com/lra/mackup), a solution to keep application settings in sync for MacOS/Linux. The concept is pretty simple as per the [What does it do](https://github.com/lra/mackup#what-does-it-do) section says in the README:

> * Back ups your application settings in a safe directory (e.g. Dropbox)
> * Syncs your application settings among all your workstations
> * Restores your configuration on any fresh install in one command line

It has a list of [support applications](https://github.com/lra/mackup/tree/master/mackup/applications), although it also supports [custom file/directory/application](https://github.com/lra/mackup/tree/master/doc#add-support-for-an-application-or-any-file-or-directory).

Using Mackup, I can take advantage of:

* Backing up configurations of supported applications. This alone is awesome, as there were many application settings that I never bothered to backup.
* Ability to create custom application configurations defining their symlink-able dotfiles.
* More battle-tested process for backing up and restoring symlinks.
* Real-time synchronization of configurations in Dropbox.
* Private dotfile synchronization in Dropbox.


### Synchronization

Before Mackup, I was using `git pull` and `git push` to synchronize _deliberate_ configuration changes. I would have to manually add files I wanted to synchronize to the dotfile repository, along with the initial symlink. On another machine, I would `git pull` and _reinstall_ to apply the changes.

I was fortunate in that I didn't whole-heartedly use this approach with multiple machines at the same time. I suspect there could be conflicts, or lost configurations using this approach.

With Mackup and the idea of using dropbox for synchronization, configurations are reflected in near real-time (although applications might have to be restarted on the other machine). To better accommodate the real-time synchronization features, I moved my dotfile repository to dropbox. I also let Mackup handle the backup/restore of symlinks as it has that feature built into it.

As Mackup provides a host of support applications, I was able to synchronize much more between environments. As it also has the support for custom application configurations I was able to better declare what I wanted to synchronize.

### Public Sharing

One of my main goals was to keep my dotfiles [focused and organized](https://github.com/kevinjalbert/dotfiles/tree/6585c9a7e1ae1926fcaf2210d48be23a2e988bdb) from a directory structure perspective. This simplifies the navigation and discoverability for anyone looking at my dotfiles. Each directory contains a specific set of configurations, and through the orchestration system, they get applied to the environment.

When adopting Mackup, I decided to shed this and simply adopt the _root is my home directory_ that Mackup uses by default. This isn't pretty, but it removes the _mapping_ of where the file would reside in the system. In retrospect, it actually better reflects where someone would expect to find certain configurations.

I define my own [custom applications](https://github.com/kevinjalbert/dotfiles/tree/5acf8672973e31dace420ad8e8303675094ed4e5/.mackup) so I can share/synchronize what I desire.

As mentioned, Mackup is capabile of synchronizing a bunch of supported applications. I didn't exactly want to put all those up in my repository for sharing. If I don't actively manage the configuration then I don't want to share it. For example, my configurations for [Doxie](https://github.com/lra/mackup/blob/719efd0a630fc3c6326aab5c84ac12b8509bbbf9/mackup/applications/doxie.cfg) aren't important, while my vim/zsh configurations are highly curated.

To make sure my repository only has the _curated_ configurations that I want to publicly share I use [whitelisting in the `.gitignore`](https://github.com/kevinjalbert/dotfiles/blob/5acf8672973e31dace420ad8e8303675094ed4e5/.gitignore) to selectively publish dotfiles.

This approach allows me to take full advantage of synchronizing all configurations between environments, while publically sharing selected configurations in my repository.

## The Flow

### Adding files to synchronize

When I use `mackup --dry-run backup`, I get a list of configurations that have not yet been backed up. This will pick up new applications, as well as new custom configurations I've added.

If I have something custom to backup I will create a new configuration.

```
$ cat ~/.mackup/tips.cfg
[application]
name = My tips

[configuration_files]
.tips
```

Now I can run `mackup backup` and backup the new additions to my dropbox.

If I'm considering publically sharing this in my dotfiles repository, I'll add the appropriate changes in the `.gitignore` whitelist.

### Restoring files on different environment

Similar to the backup command, I can use `mackup --dry-run restore` to see a list of configurations that have yet to be restored. This will add new symlinks on the current machine based on the configurations in dropbox.

After that, the symlinks will take care of the synchronization of data between the multiple systems in real-time.

### Gotchas

1. Some dotfiles of applications are always changing or overwriting the symlinks. These are hard to handle, and might not even be worth synchronizing between systems. With dropbox, I kept getting notifications of changes to files (i.e., Screenhero did this for me).

2. You can synchronize whole directories with a symlink. This is great as any new files that appear within it will be handled automatically. The only issue I've hit with this is when you want to change the scope of the symlinking (i.e., replace the directory with just individual files within it, or vice versa). Just be careful, as in my experience Mackup might not do the backup/restore correctly if you are changing the scope of the symlink.

3. Concerns with sensitive private keys (GPG/SSH private keys, secret API keys, etc...), as you are putting them in Dropbox (in the cloud). Some people/organizations will not like this, and you have to be aware of what you are synchronizing.

4. You can always override an existing Mackup application configuration with a custom one. For example, I wanted to add some additional files for my [ZSH configuration](https://github.com/kevinjalbert/dotfiles/blob/1c6c2b03169a57708b4487c4af0d52168f9957ef/.mackup/zsh.cfg).

# TL;DR

* The concept of dotfiles is awesome, especially if you have multiple environments you want to synchronize configurations between.
* GitHub is a great place to host/explore public dotfiles.
* Mackup provides a comprehensive synchronization solution for application configurations and files.
* Using Dropbox as Mackup's storage option provides near real-time synchronization of dotfiles.
* Make use of `.gitignore`'s whitelisting feature to selectivly share your public dotfiles while staying within Mackup's solution.
