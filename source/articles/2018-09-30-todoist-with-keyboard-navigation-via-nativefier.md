---
title: "Todoist with Keyboard Navigation via Nativefier"

description: "Todoist does not have strong keyboard navigation and shortcuts. Fortunately, there is a browser extension that augments the web client to support better keyboard navigation. This article outlines how to gain this functionality in a desktop version of Todoist using 'nativefier'."

tags:
- productivity
- tools

pull_image: "/images/2018-09-30-todoist-with-keyboard-navigation-via-nativefier/todoist-keyboard.jpg"
pull_image_attribution: 'My MacBook Pro displaying "TODOIST"'
---

[Todoist](https://todoist.com) is a powerful task manager. It offers a [MacOS Application](https://itunes.apple.com/ca/app/todoist-organize-your-life/id585829637) that provides a desktop experience and a dedicated _quick task adding_ feature. I am a poweruser of the keyboard (i.e., I use [Vimium](https://chrome.google.com/webstore/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb?hl=en) in Chrome), and my big issue is that Todoist doesn't offer strong keyboard navigation. Fortunately, [todoist-shortcuts](https://github.com/mgsloan/todoist-shortcuts) adds much-needed keyboard navigation to the web client as a browser extension.

I enjoy having _dedicated tools/applications_ for tasks and tend to keep my browser for ephemeral tasks. Therefore I wanted to keep Todoist as a desktop application but with the keyboard navigation extension.

## Web Application -> Desktop Application

I've used [nativefier](https://github.com/jiahaog/nativefier) in the past to create a desktop version of various web applications. Quick searching showed the following [issue](https://github.com/jiahaog/nativefier/issues/207) mentioning that adding a Chrome extention isn't supported, although it is possible to _inject_ custom JavaScript to be executed within the newly created application.

The following command will build the application while injecting [`src/todoist-shortcuts.js`](https://github.com/mgsloan/todoist-shortcuts/blob/v22/src/todoist-shortcuts.js) in it. The injected file contains all of the keyboard navigation of `todoist-shortcuts`. In addition, other options were provided to `nativefier` so that we have support for badge counts and bouncing the dock icon on changes when out of focus (MacOS).

```sh
nativefier 'https://todoist.com/' --name 'Todoist' --icon ./todoist-icon.png --inject ./todoist-shortcuts-22/src/todoist-shortcuts.js --counter --bounce --single-instance
```

The produced application works as expected. Keyboard navigation exists within the `nativefier` created application. Unfortunately, the badge count aspect did not...

### Supporting Badge Count

The reason the badge count didn't work is because `nativefier` is looking in the title of the window/application for the number (using a regular expression). To solve this, we will need some additional JavaScript that will propagate the number of tasks in _Today_ into the title (while handling edge cases). It isn't the prettiest, but the following `counter.js` snippet does the trick:

```js
// Returns the count for the 'Today' list (defaults to 0)
function currentCount() {
  return document.querySelector('#top_filters > li:nth-child(2) > span.item_content > small').innerText || 0;
}

// Returns the title without any annotated count
function titleWithoutCount() {
  const title = document.title;
  const indexOfCount = title.indexOf(" (");

  if (indexOfCount >= 0) {
    return title.substring(0, indexOfCount);
  } else {
    return title;
  }
}

// Returns the existing count from the title (defaults to 0)
function existingCount() {
  const title = document.title;
  const indexOfCount = title.indexOf(" (");

  return title.substring(indexOfCount + 2, title.length - 1) || 0
}

// Update badge count based on the number in Today
function updateBadgeCount() {
  const count = currentCount();
  const title = titleWithoutCount();
  var newTitle = document.title;

  if (count === 0) {
    newTitle = title;
  } else if (count !== existingCount()) {
    newTitle = `${title} (${count})`;
  }

  if (document.title !== newTitle) {
    document.title = newTitle
  }
}

// Update the badge every 5 seconds
setInterval(updateBadgeCount, 5000);

// Update the badge when the title changes
new MutationObserver(function(mutations) {
  updateBadgeCount();
}).observe(
  document.querySelector('title'), {
    subtree: true,
    characterData: true,
    childList: true
  }
);
```

Unfortunately, `nativefier` has an issue with [injecting multiple JavaScript files](https://github.com/jiahaog/nativefier/issues/458). As a workaround, we concatenate the JavaScript into one file before _injecting it_ (which fortunately works with the JavaScript we have).

```sh
#!/bin/bash
cat ./counter.js > todoist.js; cat ./todoist-shortcuts-22/src/todoist-shortcuts.js >> todoist.js
nativefier 'https://todoist.com/' --name 'Todoist' --icon ./todoist-icon.png --inject ./todoist.js --counter --bounce --single-instance --overwrite
```

## Desktop Todoist with Keyboard Navigation

At this point, we've successfully wrapped the web client of Todoist for Desktop while injecting `todoist-shortcuts`. Badge support is preserved and notifications continue to function.

I still like the _quick task adding_ feature of the original Todoist application on the desktop, but unfortunately, that was outside the scope of what I could do with `nativefier`. As a workaround, I've renamed the original application to `Todoist-store` and moved the new application over with no naming conflicts. I run both applications so that I can continue to use the _quick task adding_ feature, although I hide `Todist-store`in the tray and prevent any notifications from appearing.

To simplify the process of extending/modifying/building this solution, I've put together the following [repository on GitHub](https://github.com/kevinjalbert/todoist-shortcuts-nativefier). I hope that Todoist simply adds better keyboard navigation in their client by default... but until then, I'll be using this solution.
