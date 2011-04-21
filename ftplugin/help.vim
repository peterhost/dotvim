
" enter to follow link, backspace to go back
nmap <buffer> <CR> <C-]>
nmap <buffer> <BS> <C-T>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" added nohlsearch<CR> to default, so as not to get the search string
" highlighted :)

"" jump to next/previous occurence of 'option link'
"nmap <buffer> o /'\l\{2,\}'<CR>nohlsearch<CR>
"nmap <buffer> O ?'\l\{2,\}'<CR><CR>nohlsearch<CR>

"" jump to next/previous occurence of 'subject link'
"nmap <buffer> s /\|\S\+\|<CR>nohlsearch<CR>
"nmap <buffer> S ?\|\S\+\|<CR>nohlsearch<CR>



" jump to next/previous occurence of 'option link'
nmap <buffer> o /'\l\{2,\}'<CR>
nmap <buffer> O ?'\l\{2,\}'<CR>

" jump to next/previous occurence of 'subject link'
nmap <buffer> s /\|\zs\S\+\ze\|<CR>
nmap <buffer> S ?\|\zs\S\+\ze\|<CR>



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" <leader> h : search for word under cursor
map <leader> h :exec "help ".expand("<cWORD>")<CR>
