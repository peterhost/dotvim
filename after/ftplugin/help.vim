" help : navigation rapide dans l'aide de vim

" Entrée suit un lien, Retour arrière revient en arrière
nnoremap <buffer> <CR> <C-]>
nnoremap <buffer> <BS> <C-T>

" o / O : option suivante / précédente ('option')
nnoremap <buffer> o /'\l\{2,\}'<CR>
nnoremap <buffer> O ?'\l\{2,\}'<CR>

" s / S : sujet suivant / précédent (|sujet|)
nnoremap <buffer> s /\|\zs\S\+\ze\|<CR>
nnoremap <buffer> S ?\|\zs\S\+\ze\|<CR>

" ,h : aide sur le MOT sous le curseur
nnoremap <buffer> <leader>h :execute 'help ' . expand('<cWORD>')<CR>
