" help : navigation rapide dans l'aide de vim

"= aide | suivre un lien (Entrée), revenir en arrière (Retour arrière)
nnoremap <buffer> <CR> <C-]>
nnoremap <buffer> <BS> <C-T>

"= aide | option suivante (o) ou précédente (O)
nnoremap <buffer> o /'\l\{2,\}'<CR>
nnoremap <buffer> O ?'\l\{2,\}'<CR>

"= aide | sujet suivant (s) ou précédent (S)
nnoremap <buffer> s /\|\zs\S\+\ze\|<CR>
nnoremap <buffer> S ?\|\zs\S\+\ze\|<CR>

"= aide | aide sur le MOT complet sous le curseur
nnoremap <buffer> <leader>h :execute 'help ' . expand('<cWORD>')<CR>
