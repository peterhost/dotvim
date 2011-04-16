
" enter to follow link, backspace to go back
nmap <buffer> <CR> <C-]>
nmap <buffer> <BS> <C-T>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" added nohlsearch<CR> to default, so as not to get the search string
" highlighted :)

" jump to next/previous occurence of 'option link'
nmap <buffer> o /''[a-z]\{2,\}''<CR>nohlsearch<CR>
nmap <buffer> O ?''[a-z]\{2,\}''<CR>nohlsearch<CR>

" jump to next/previous occurence of 'subject link'
"nmap <buffer> s /\|\S\+\|<CR>
"nmap <buffer> S ?\|\S\+\|<CR>

nmap <buffer> s /\|\S\+\|<CR>nohlsearch<CR>
nmap <buffer> S ?\|\S\+\|<CR>nohlsearch<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" <F1> : search for word under cursor
map <F1> <ESC>:exec "help ".expand("<cWORD>")<CR>
