" javascript : repli par indentation ; ALE (eslint, prettier, tsserver)
setlocal foldmethod=indent

if exists(':ALEFix') == 2
"= langages | corriger le fichier (eslint, prettier)
  nnoremap <buffer> <F8> :ALEFix<CR>
"= langages | aller à la définition
  nnoremap <buffer> gd :ALEGoToDefinition<CR>
"= langages | vérifier (,jsl) ou corriger (,jsf) le fichier
  nnoremap <buffer> <leader>jsl :ALELint<CR>
  nnoremap <buffer> <leader>jsf :ALEFix<CR>
  setlocal omnifunc=ale#completion#OmniFunc
endif

"= langages | commentaire JSDoc pour la fonction courante
if exists(':JsDoc') == 2
  nnoremap <buffer> <localleader>d :JsDoc<CR>
endif
"= langages | documentation du projet avec l’outil jsdoc
if executable('jsdoc')
  nnoremap <buffer> <localleader>D :!cd %:p:h:S && jsdoc --configure ~/.jsdoc.json app.js<CR>
endif
