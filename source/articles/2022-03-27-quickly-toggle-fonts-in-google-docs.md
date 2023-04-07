---
title: "Quickly Toggle Fonts in Google Docs"

description: "If you use two fonts in Google Docs often (i.e., like using mono fonts for code keywords) then read my approach to toggling between two fonts quickly using AppleScript on MacOS."

tags:
- applescript
- productivity
- google

pull_image: "/images/2022-03-27-quickly-toggle-fonts-in-google-docs/signs-fonts.jpg"
pull_image_attribution: '[blackjack](https://flickr.com/photos/beckettgirlphotos/43821835480 "blackjack") by [Rural Warrior Photography](https://flickr.com/people/beckettgirlphotos) is licensed under [CC BY-ND](https://creativecommons.org/licenses/by-nd/2.0/)'
---

I spend a fair amount working in technical documents within [Google Docs](https://www.google.ca/docs/about/) at work. Due to the content of these documents, there will be parts of them that visually resonate with a monospaced font (i.e., name of a class/module/method). Unfortunately, Google Docs does not natively support [Markdown](https://daringfireball.net/projects/markdown/) for `code spans` by surrounding text with backtick quotes.

## Ways to Toggle Fonts in Google Docs

### Option 1 – Using the Mouse
Mouse to the Font select and pick one
<details>
  <summary>**→ Click to see GIF ←**</summary>
![](/images/2022-03-27-quickly-toggle-fonts-in-google-docs/toggle-font-mouse.gif)
</details>

### Option 2 – Keyboard using the Menu Search
Use the menu search option via the keyboard Option+/ (or Alt+/) and type the font name, then push enter
<details>
  <summary>**→ Click to see GIF ←**</summary>
![](/images/2022-03-27-quickly-toggle-fonts-in-google-docs/toggle-font-keyboard-menu.gif)
</details>

### Option 3 - Global Hotkey Triggering AppleScript
Use a global hotkey [Hyper](/global-hotkeys-using-the-hyper-key/)+C to automate Option 2 (and let you toggle between two fonts)
<details>
  <summary>**→ Click to see GIF ←**</summary>
![](/images/2022-03-27-quickly-toggle-fonts-in-google-docs/toggle-font-keyboard-applescript.gif)
</details>

## The AppleScript Code

The following is the dump of the AppleScript I'm using. It has some guards in place to ensure that it only works when your focus is in Google Chrome and the current tab is a Google Doc (or Sheet/Slide).

The fonts will toggle between Arial and Roboto Mono (although easy enough to modify to your own preference). The Font _selector_ works for me... however Google could change it at anytime, breaking this flow.

This code can then be put into a global hotkey (using something like [Alfred](https://www.alfredapp.com/) or [Raycast](https://www.raycast.com/)).

```applescript
# Check to make sure we are focused on Google Chrome
tell application "System Events"
	set activeApp to name of first application process whose frontmost is true

	if "Google Chrome" is not activeApp then
		log "Google Chrome isn't active application"
		return
	end if
end tell

# Check to make sure we are in a https://docs.google.com/
tell application "Google Chrome"
	set activeURL to get URL of active tab of first window

	if activeURL does not contain "https://docs.google.com/" then
		log "URL is not under https://docs.google.com"
		return
	end if
end tell

tell application "Google Chrome"
	tell active tab of front window to set fontFamily to execute javascript "document.querySelector('#docs-font-family > div > div > div.goog-toolbar-menu-button-caption.goog-inline-block').innerHTML;"

	if fontFamily is missing value then
		log "No Font Found"
		return
	end if
end tell

tell application "System Events"
	delay 0.2
	keystroke "/" using option down
	delay 0.2

	if fontFamily = "Roboto Mono" then
		keystroke "Arial"
	else
		keystroke "Roboto Mono"
	end if

	delay 0.2
	keystroke return
end tell
```

## Let Chrome Know You Will Do This

According to [Information for Third-party Applications on Mac](https://sites.google.com/a/chromium.org/dev/developers/applescript?visit_id=638164763442473572-1986603841&p=applescript&rd=1) "in order to protect users from injection of unwanted content" Chrome would prevent this type of manipulation by default.

In order to get this working you'll need to tell Chrome to "Allow JavaScript from Apple Events" which is an option under View > Developer.
