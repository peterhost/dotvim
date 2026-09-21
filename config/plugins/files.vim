" files.vim — explorateur de fichiers et liste des symboles
if my#plug#on('nerdtree')
  nnoremap <silent> <leader>t :execute 'NERDTreeToggle ' . fnameescape(getcwd())<CR>
endif

" Tagbar a besoin d'universal-ctags ; le ctags d'Apple (BSD) ne convient pas.
" Sans lui, Tagbar affiche un message à l'ouverture, sans autre gêne.
if my#plug#on('tagbar')
  if executable('uctags')
    let g:tagbar_ctags_bin = 'uctags'
  endif
  nnoremap <leader>T :TagbarToggle<CR>
endif
