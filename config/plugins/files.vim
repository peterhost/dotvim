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

" Liste des buffers : ,be (ici), ,bt (bascule), ,bs (partage horizontal),
" ,bv (partage vertical). Raccourcis fournis par bufexplorer ; sans lui
" (vim < 7.4), équivalent natif : la liste s'affiche, on tape le numéro.
if !my#plug#on('bufexplorer')
  nnoremap <leader>be :ls<CR>:buffer<Space>
  nnoremap <leader>bt :ls<CR>:buffer<Space>
  nnoremap <leader>bs :ls<CR>:sbuffer<Space>
  nnoremap <leader>bv :ls<CR>:vertical sbuffer<Space>
endif
