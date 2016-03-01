---
title: Vim Substitution Feedback Using `vim-over`

teaser:
  Vim substitutions offer little affordance in whether the search will match the desired text. `vim-over` is a vim plugin that provides visual feedback while working with substitutions.

tags:
- vim
---

It is common while in vim to perform substitution tasks over the text you are editing. This is often accomplished using the following command:

    :%s/<find>/<replacement>/g

The `%s` command will perform substitution over every line within the buffer. The `/<find>/<replace>` specifies the substitution to perform. Finally the `/g` indicates that this should apply to multiple occurrences if they are present on the same line.

This works great, although there is little affordance in determining whether the specified `<find>` will hit the matches you are interested in. The aforementioned command is a *all-or-nothing* with respect to execution, there is no *visual feedback* until you execute the command.

# Visual Feedback via vim-over
The [vim-over](https://github.com/osyo-manga/vim-over) plugin provides a dynamic approach for visual feedback while performing substitutions. It is extremely useful while crafting specific `<find>` patterns.

![Visual Feedback Demo](/images/2016-02-29-vim-substitution-feedback-using-vim-over/visual-feedback-demo.gif)

# Tips and Tricks
I have three vim maps that I use to simplify and enhance my substitutions.

## #1 - Substitute Word
This mapping (`<leader>s`) will find and replace the text under the cursor using `vim-over` for visual feedback. After the mapping has been executed you are left where you simply type the `<replacement>/g`.

	nnoremap <leader>s :OverCommandLine<CR> %s/<C-r><C-w>/

## #2 - Global Substitution
This mapping (`<leader>v`) will perform a global substitution using `vim-over` for visual feedback. After the mapping has been executed you are left where you type the `<find>/<replacement>/g`.

	function! VisualFindAndReplace()
	    :OverCommandLine %s/
	    :noh
	endfunction
	nnoremap <Leader>v :call VisualFindAndReplace()<CR>

## #3 - Visual Substitution
This mapping (`<leader>v` while in visual mode) will perform a substitution only within the visually selected text using `vim-over` for visual feedback. After the mapping has been executed you are left where you type the `<find>/<replacement>/g`.

	function! VisualFindAndReplaceWithSelection() range
	    :'<,'>OverCommandLine s/
	    :noh
	endfunction
	xnoremap <Leader>v :call VisualFindAndReplaceWithSelection()<CR>
