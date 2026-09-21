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
