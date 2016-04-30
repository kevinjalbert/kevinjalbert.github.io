---
title: Enhanced Vim Searching

teaser:
  Vanilla vim offers farily powerful searching capabilities within a buffer. It is possible to _enhance_ vim's searching capabilities even further with vim plugins. Using several plugins, keymappings and settings, we can improve upon vim's search.

tags:
- vim
---

## Basic Searching

Vim provides rather simple searching capabilities using the following keys while in normal mode:

* `/` performs a *forward* search of the provided pattern
* `?` performs a *backward* search of the provided pattern
* `*` performs a *forward* search of the word under the cursor
* `#` performs a *backward* search of the word under the cursor
* `n` navigates to the *next* search occurrence
* `N` navigates to the *previous* search occurrence

These commands alone are vital to anyone working with text in Vim. Without any customization these search commands perform simple

![Basic Searching](/images/2016-04-30-enhanced-vim-searching/basic-searching.gif)

## Better Searching

Personally, I always apply the following to make my searching slightly more responsive with visual feedback:

```vim
set hlsearch
set incsearch

" This unsets the 'last search pattern' register by hitting ;
nnoremap ; :noh<CR>:<backspace>
```

This allows our searches to *incrementally* highlight the first match, providing visual feedback on our pattern matching. In addition, when proceeding with the search all the matches of the pattern are highlighted to visually indicate possible next matches.

As searching is a frequently used motion, I have added a map to `;` to clear any highlighting from the searches.

![Better Searching](/images/2016-04-30-enhanced-vim-searching/better-searching.gif)

## Enhance Searching

We can do better! Using a mixture of two vim plugins we can achieve an enhanced form of searching within vim:

```vim
" All around better searching (via Vundle's plugin manager)
Bundle 'haya14busa/incsearch.vim'
Bundle 'osyo-manga/vim-anzu'
```

First, we have a bunch of maps and settings to incorporate [`incsearch.vim`](https://github.com/haya14busa/incsearch.vim) and [`vim-anzu`](https://github.com/osyo-manga/vim-anzu) together:

```vim
" Use incsearch.vim for all search functions (with anzu for indication)
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
let g:incsearch#auto_nohlsearch = 1
set hlsearch
map n <Plug>(incsearch-nohl)<Plug>(anzu-n-with-echo)
map N <Plug>(incsearch-nohl)<Plug>(anzu-N-with-echo)
map * <Plug>(incsearch-nohl)<Plug>(anzu-star-with-echo)
map # <Plug>(incsearch-nohl)<Plug>(anzu-sharp-with-echo)
let g:anzu_status_format = "%p(%i/%l) %w"
```

By using `incsearch.vim` we not only gain access to other perks that it brings in it's toolkit, but it also handles our highlighting issue. Anytime the cursor moves after a search motion it `incsearch.vim` will automatically remove the highlighting, which saves us from using the previously mentioned `;` map for manually clearing the search highlighting. Secondly we have `vim-anzu` which indicates the current *index* of the search occurrence that you are at, it also indicates when you wrap around the bottom/top of the buffer.

![Enhanced Searching](/images/2016-04-30-enhanced-vim-searching/enhanced-searching.gif)

## *tap tap tap* Enhance... *tap tap tap* Enhance Searching

We can go even further to *enhance* our searching by making use of another vim plugin, [`vim-easymotion`](https://github.com/Lokaltog/vim-easymotion) for better targeting our searches:

```vim
" Targeting our searching (via Vundle's plugin manager)
Bundle 'Lokaltog/vim-easymotion'
```

By default `vim-easymotion` could be used on the common `/` searches to provide an intelligent way to *target* our searches. Although, this tramples over our previous work, and we lose the simplicity of our common `/` searches. The following function and augmentations allow `vim-easymotion` to be triggered off of a `/` search by hooking into the search by `incsearch.vim`.

```vim
" Integrate incsearch and easymotion
" https://github.com/Lokaltog/vim-easymotion/issues/146#issuecomment-75443473
" Can use / for 'normal searching', at anytime its possible to use <space> to
" pass search over to easymotion. To use spaces in search you need to apply
" them via the regex approach \s.
augroup incsearch-easymotion
  autocmd!
  autocmd User IncSearchEnter autocmd! incsearch-easymotion-impl
augroup END
augroup incsearch-easymotion-impl
  autocmd!
augroup END
function! IncsearchEasyMotion() abort
  autocmd incsearch-easymotion-impl User IncSearchExecute :silent! call EasyMotion#Search(0, 2, 0)
  return "\<CR>"
endfunction
let g:incsearch_cli_key_mappings = {
\   "\<Space>": {
\       'key': 'IncsearchEasyMotion()',
\       'noremap': 1,
\       'expr': 1
\   }
\ }
```

![Targeted Searching](/images/2016-04-30-enhanced-vim-searching/targeted-searching.gif)

We finally have all-around better vim searching, by configuring three search related plugins to play nice with each other!
