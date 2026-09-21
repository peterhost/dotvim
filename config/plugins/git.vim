" git.vim — fugitive (+ rhubarb pour GitHub) et gist
if my#plug#on('vim-fugitive')
  nnoremap <leader>gs :Git<CR>
  nnoremap <leader>gc :Git commit<CR>
  nnoremap <leader>gg :Ggrep<Space>
  nnoremap <leader>ga :Gwrite<CR>
  nnoremap <leader>gl :Gclog<Space>
  nnoremap <leader>gdc :Git diff --cached<CR>
  nnoremap <leader>gdh :Gdiffsplit HEAD<CR>
  nnoremap <leader>gdo :Gdiffsplit ORIG_HEAD<CR>
  nnoremap <leader>gb :GBrowse<CR>
  augroup my_fugitive
    autocmd!
    " ne pas accumuler les buffers ouverts en parcourant l'historique
    autocmd BufReadPost fugitive://* setlocal bufhidden=delete
  augroup END
endif

" Gist : jeton GitHub dans ~/.gist-vim (voir :help gist-vim)
if my#plug#on('vim-gist')
  let g:gist_open_browser_after_post = 1
  " configuration QUIX (bookmarklets)
  nnoremap <leader>eq :Gist 1397755<CR>
  nnoremap <leader>Gq :Gist 1397755<CR>
  nnoremap <leader>sq :Gist -e<CR>
  nnoremap <leader>Gs :Gist -e<CR>
endif
