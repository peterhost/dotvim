" gvimrc — réglages de l'interface graphique (MacVim, gvim)
"
" Le vimrc est déjà chargé par vim avant ce fichier : on ne le recharge pas.

set guioptions-=T   " pas de barre d'outils

" --- Police ------------------------------------------------------------------------
" ,1 … ,9 : polices préférées ; ,= / ,- : taille +1 / -1
if has('gui_macvim')
  silent! set guifont=SourceCodePro-ExtraLight:h13
  nnoremap <silent> <leader>1 :silent! set guifont=Century\ Schoolbook\ Monospace\ BT:h14<CR>
  nnoremap <silent> <leader>2 :silent! set guifont=DejaVu\ Sans\ Mono:h11<CR>
  nnoremap <silent> <leader>3 :silent! set guifont=Menlo\ Regular:h11<CR>
  nnoremap <silent> <leader>4 :silent! set guifont=Nitti\ Light:h12<CR>
  nnoremap <silent> <leader>7 :silent! set guifont=Nitti\ Normal:h12<CR>
  nnoremap <silent> <leader>8 :silent! set guifont=Nitti\ Bold:h12<CR>
  nnoremap <silent> <leader>9 :silent! set guifont=SourceCodePro-ExtraLight:h14<CR>
elseif has('gui_win32')
  silent! set guifont=Consolas:h11
else
  silent! set guifont=Meslo\ LG\ M\ DZ\ 10
  nnoremap <silent> <leader>1 :silent! set guifont=Century\ Schoolbook\ Monospace\ BT\ 14<CR>
  nnoremap <silent> <leader>2 :silent! set guifont=DejaVu\ Sans\ Mono\ 11<CR>
  nnoremap <silent> <leader>3 :silent! set guifont=Meslo\ LG\ M\ DZ\ 10<CR>
  nnoremap <silent> <leader>6 :silent! set guifont=Nitti\ Light\ 12<CR>
  nnoremap <silent> <leader>7 :silent! set guifont=Nitti\ Normal\ 12<CR>
  nnoremap <silent> <leader>8 :silent! set guifont=Nitti\ Bold\ 12<CR>
endif

" Taille : le nombre après :h (Mac/Windows) ou en fin de nom (GTK)
nnoremap <silent> <leader>= :silent! let &guifont = substitute(&guifont, '\(:h\<Bar>\s\)\zs\d\+', '\=submatch(0)+1', '')<CR>
nnoremap <silent> <leader>- :silent! let &guifont = substitute(&guifont, '\(:h\<Bar>\s\)\zs\d\+', '\=submatch(0)-1', '')<CR>

" --- Réglages propres à la machine ---------------------------------------------------
for s:f in [expand('~/.gvimrc.local'), expand('~/_gvimrc.local')]
  if filereadable(s:f)
    execute 'source ' . fnameescape(s:f)
    break
  endif
endfor
unlet! s:f
