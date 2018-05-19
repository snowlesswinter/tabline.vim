" File:        tabline.vim
" Maintainer:  Matthew Kitt <http://mkitt.net/>
" Description: Configure tabs within Terminal Vim.
" Last Change: 2012-10-21
" License:     This program is free software. It comes without any warranty,
"              to the extent permitted by applicable law. You can redistribute
"              it and/or modify it under the terms of the Do What The Fuck You
"              Want To Public License, Version 2, as published by Sam Hocevar.
"              See http://sam.zoy.org/wtfpl/COPYING for more details.
" Based On:    http://www.offensivethinking.org/data/dotfiles/vimrc

" Bail quickly if the plugin was loaded, disabled or compatible is set
if (exists("g:loaded_tabline_vim") && g:loaded_tabline_vim) || &cp
  finish
endif
let g:loaded_tabline_vim = 1

function! Tabline()
  let s = ''
  for i in range(tabpagenr('$'))
    let tab = i + 1
    let buflist = tabpagebuflist(tab)

    " https://vi.stackexchange.com/questions/12705/how-can-i-keep-the-tab-title-text-fixed-during-movement-through-separate-split
    let bufignore = ['nerdtree', 'tagbar', 'codi', 'help']

    " Set the tab title to the name of the buffer which is not in the ignore list
    for b in buflist
      let buftype = getbufvar(b, "&filetype")
      if index(bufignore, buftype) == -1 " index() returns -1 if the item is not contained in the ignore list
        let bufnr = b
        break
      elseif b == buflist[-1]
        let bufnr = b
      endif
    endfor
    let bufname = bufname(bufnr)
    let bufmodified = getbufvar(bufnr, "&mod")

    let s .= '%' . tab . 'T'
    let s .= (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
    let s .= ' ' . tab .':'
    let s .= (bufname != '' ? '['. fnamemodify(bufname, ':t') . '] ' : '[No Name] ')

    if bufmodified
      let s .= '[+] '
    endif
  endfor

  let s .= '%#TabLineFill#'
  if (exists("g:tablineclosebutton"))
    let s .= '%=%999XX'
  endif
  return s
endfunction
set tabline=%!Tabline()

