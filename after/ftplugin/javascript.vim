" javascript : repli par indentation ; ALE (eslint, prettier, tsserver)
setlocal foldmethod=indent

if exists(':ALEFix') == 2
  nnoremap <buffer> <F8> :ALEFix<CR>
  nnoremap <buffer> gd :ALEGoToDefinition<CR>
  nnoremap <buffer> <leader>jsl :ALELint<CR>
  nnoremap <buffer> <leader>jsf :ALEFix<CR>
  setlocal omnifunc=ale#completion#OmniFunc
endif

" =d : commentaire JSDoc pour la fonction courante
if exists(':JsDoc') == 2
  nnoremap <buffer> <localleader>d :JsDoc<CR>
endif
" =D : générer la documentation du projet avec l'outil jsdoc (~/.jsdoc.json)
if executable('jsdoc')
  nnoremap <buffer> <localleader>D :!cd %:p:h:S && jsdoc --configure ~/.jsdoc.json app.js<CR>
endif
