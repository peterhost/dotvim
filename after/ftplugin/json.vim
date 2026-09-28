" json : = réindente avec jq s'il est installé
if executable('jq')
  setlocal equalprg=jq\ .
endif
if exists(':ALEFix') == 2
"= langages | reformater le fichier (jq)
  nnoremap <buffer> <F8> :ALEFix<CR>
endif
