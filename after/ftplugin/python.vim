" python : tabulations bien visibles ; ALE pour corriger, compléter, naviguer
scriptencoding utf-8
if g:my_utf8
  setlocal listchars=tab:▷⋅,trail:⋅,extends:#,nbsp:⋅
else
  setlocal listchars=tab:>.,trail:.,extends:#,nbsp:.
endif

if exists(':ALEFix') == 2
  nnoremap <buffer> <F8> :ALEFix<CR>
  nnoremap <buffer> gd :ALEGoToDefinition<CR>
  nnoremap <buffer> K :ALEHover<CR>
  " raccourcis de jedi-vim, conservés : définition, usages, renommage
  nnoremap <buffer> <leader>d :ALEGoToDefinition<CR>
  nnoremap <buffer> <leader>n :ALEFindReferences<CR>
  nnoremap <buffer> <leader>r :ALERename<CR>
  nnoremap <buffer> <leader>R :ALERename<CR>
  setlocal omnifunc=ale#completion#OmniFunc
endif

" Objets de texte classe / fonction (vim-pythonsense) : ac ic af if ad id,
" déplacements [[ ]] [m ]m. Plus les touches de l'ancien python-mode :
" aC iC (classe), aM iM (méthode ou fonction).
if exists('g:loaded_pythonsense') || exists('*pythonsense#select_named_block')
      \ || my#plug#on('vim-pythonsense')
  for s:m in ['o', 'x']
    execute s:m . 'map <buffer> aC <Plug>(PythonsenseOuterClassTextObject)'
    execute s:m . 'map <buffer> iC <Plug>(PythonsenseInnerClassTextObject)'
    execute s:m . 'map <buffer> aM <Plug>(PythonsenseOuterFunctionTextObject)'
    execute s:m . 'map <buffer> iM <Plug>(PythonsenseInnerFunctionTextObject)'
  endfor
  unlet s:m
endif
