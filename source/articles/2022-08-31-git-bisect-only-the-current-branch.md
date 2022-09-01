---
title: "Git Bisect: Only the Current Branch"

description: "When working with branches, often you are focusing on a specific part of the codebase. Sometimes, a commit in a string of commits can cause failures elsewhere. Check out my script on bisecting the current branch and catch the commit that introduced the error."

tags:
- git
- git bisect
- tool

pull_image: "/images/2022-08-31-git-bisect-only-the-current-branch/broken-chain.jpg"
pull_image_attribution: '[Las cadenas se cortan por el eslabón mas débil / Chains break by the weakest link](https://flickr.com/photos/hernanpc/7115374283 "Las cadenas se cortan por el eslabón mas débil / Chains break by the weakest link") by [hernanpba](https://flickr.com/people/hernanpc) is licensed under [CC BY-SA](https://creativecommons.org/licenses/by-sa/2.0/)'
---

# Git Bisect's Usefulness

Imagine that at some point you've discovered that a bug/failure is present and you aren't exactly sure when it was introduced. This is when `git bisect` comes into the picture. With a little bit of setup, it helps binary search through changes to uncover the commit that introduced the issue.

There are a bunch of tips/tricks and usages of git bisect, but I'll leave that to the [official documentation](https://git-scm.com/docs/git-bisect) and possibly future posts (it is a very useful tool to be familiar with).

# Working on a Feature Branch

I almost always make changes using feature branches (i.e., branching off of `main` and eventually merging the branch back into `main`). In projects that have large test suites (where you wouldn't want to run the whole thing frequently), I only run the tests of files I'm working in. There is a small chance that I might _break_ something in a part of the codebase that I wasn't running the tests for, but it can happen. I tend to commit often while working, so to figure out what broke, I have to find which commit is responsible for the issue.

## Manual Way

The following is how I would approach this using `git bisect`. The general idea is to only bisect the commits that exist on the feature branch.

```bash
# While on the feature branch that I've been working on

# Start bisect
git bisect start

# Find SHA of where the branch diverged from main

# Mark that commit as 'good', as everything prior would have been okay
git bisect good <branching-sha>

# Mark the current branch's SHA as 'bad' since something is broken now
git bisect bad HEAD

# Run the script/test command to bisect and find the error commit
git bisect run <script/test-command>
```

When I'm done inspecting the identified commit, then I can `git bisect reset`.

## Automated Way

I've made a script that ends up automating the commands and the finding of the SHA. This makes it so I can use a single command and achieve the same results as the manual way:

```bash
# While on the feature branch that I've been working on

# Use bisect-branch passing the target branch I diverged from and the
# script/test command to bisect and find the error commit
git bisect-branch -b main <script/test-command>
```

When I'm done inspecting the identified commit, then I can `git bisect reset`.

# The git-bisect-branch Script

This [GitHub Gist](https://gist.github.com/kevinjalbert/3f0e7efe6ed0f411b7ae77b88e00a520) will be the canonical reference of the `git-branch-bisect` script (and will see updates as needed).

```bash
#!/usr/bin/env bash
while getopts 'b:dh' OPTION; do
  case "$OPTION" in
    b)
      divergent_branch=$OPTARG
      ;;
    d)
      debug=true
      ;;
    h)
      echo "This is a script that performs a git-bisect over all commits from the current branch's HEAD to where the branch diverged from the supplied branch."
      echo ""
      echo "script usage: git-bisect-branch [-b branch] [-d] [-h] run_command" >&2
      echo ""
      echo "example: git-bisect-branch -d -b main ruby test.rb"
      echo ""
      echo "Arguments:"
      echo " - Use '-b' to specify the branch from which your current branch has diverged, this should typically be 'main'/'master'."
      echo " - Use '-d' to debug internal variables and see the verbose output of git commands."
      echo " - Use '-h' to see this message."
      echo " - The remainder of the command is interpreted as the run_command, that will be running at each bisect step."
      echo ""
      echo "If this script is on your PATH, you will be able to use it like 'git bisect-branch'."
      echo ""
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

run_command=$*
current_branch=$(git branch --show-current)
current_branch_sha=$(git rev-parse HEAD)

if [ -z "$divergent_branch" ]
  then
  echo "No branch argument supplied. Should be the 'main/master' branch name"
  exit
fi

if [ -z "$run_command" ]
  then
  echo "No run_command argument supplied. Should be the command you will use to run tests for each bisect step"
  exit
fi

branching_sha=$(git merge-base $divergent_branch $current_branch)

echo "Starting bisect of commits on '$current_branch' branch ($current_branch_sha) since branching from '$divergent_branch' branch ($branching_sha)"

print_hline () {
  printf '%.s─' $(seq 1 $(tput cols))
}

if [ -n "$debug" ]
  then

  print_hline
  echo "run_command: $run_command"
  echo "current_branch: $current_branch"
  echo "current_branch_sha: $current_branch_sha"
  echo "divergent_branch: $divergent_branch"
  echo "branching_sha: $branching_sha"
  print_hline

  git bisect start
  git bisect good $branching_sha
  git bisect bad $current_branch_sha

  git bisect run $run_command
  echo ""
  print_hline
else
  git bisect start > /dev/null
  git bisect good $branching_sha > /dev/null
  git bisect bad $current_branch_sha > /dev/null
  git bisect run $run_command > /dev/null
fi

echo "Don't forget to 'git bisect reset'"
```
