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
  setlocal omnifunc=ale#completion#OmniFunc
endif
