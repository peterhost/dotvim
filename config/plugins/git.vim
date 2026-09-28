" git.vim — fugitive (+ rhubarb pour GitHub) et gist
if my#plug#on('vim-fugitive')
"= git | état du dépôt (:Git)
  nnoremap <leader>gs :Git<CR>
"= git | valider les fichiers de l’index
  nnoremap <leader>gc :Git commit<CR>
"= git | chercher dans les fichiers suivis (:Ggrep)
  nnoremap <leader>gg :Ggrep<Space>
"= git | ajouter le fichier courant à l’index
  nnoremap <leader>ga :Gwrite<CR>
"= git | journal du dépôt (:Gclog)
  nnoremap <leader>gl :Gclog<Space>
"= git | diff de l’index (,gdc), avec HEAD (,gdh), avec ORIG_HEAD (,gdo)
  nnoremap <leader>gdc :Git diff --cached<CR>
  nnoremap <leader>gdh :Gdiffsplit HEAD<CR>
  nnoremap <leader>gdo :Gdiffsplit ORIG_HEAD<CR>
"= git | ouvrir le fichier sur GitHub (:GBrowse)
  nnoremap <leader>gb :GBrowse<CR>
  augroup my_fugitive
    autocmd!
    " ne pas accumuler les buffers ouverts en parcourant l'historique
    autocmd BufReadPost fugitive://* setlocal bufhidden=delete
  augroup END
endif

" Gist : jeton GitHub dans local/gist-token (et non ~/.gist-vim) ; un ancien
" ~/.gist-vim est repris une fois.
if my#plug#on('vim-gist')
  let g:gist_token_file = g:my_local . '/gist-token'
  if !filereadable(g:gist_token_file) && filereadable(expand('~/.gist-vim'))
    silent! call writefile(readfile(expand('~/.gist-vim'), 'b'), g:gist_token_file, 'b')
  endif
  let g:gist_open_browser_after_post = 1
"= git | gist QUIX (bookmarklets) : publier (,eq, ,Gq) ou éditer (,sq, ,Gs)
  nnoremap <leader>eq :Gist 1397755<CR>
  nnoremap <leader>Gq :Gist 1397755<CR>
  nnoremap <leader>sq :Gist -e<CR>
  nnoremap <leader>Gs :Gist -e<CR>
endif
