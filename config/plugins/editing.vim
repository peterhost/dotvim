" editing.vim — plugins d'édition : snippets, complétion, annulation,
" registres, alignement, fenêtres, sessions

" Snippets (vsnip + friendly-snippets, remplace xptemplate) : Maj+Tab
" développe un snippet ou saute au champ suivant.
if my#plug#on('vim-vsnip')
  let g:vsnip_snippet_dir = g:my_dir . '/snippets'
  imap <expr> <S-Tab> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<S-Tab>'
  smap <expr> <S-Tab> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<S-Tab>'
endif

" Complétion sur Tab ; Maj+Tab reste aux snippets.
if my#plug#on('supertab')
  let g:SuperTabDefaultCompletionType = 'context'
  let g:SuperTabMappingBackward = '<C-S-Tab>'
endif

" Arbre d'annulation (remplace Gundo)
if my#plug#on('undotree')
  nnoremap <leader>u :UndotreeToggle<CR>
  let g:undotree_SetFocusWhenToggle = 1
endif

" Registres : vim-peekaboo les affiche en tapant " ou @ ; ,y les liste.
nnoremap <leader>y :registers<CR>

if my#plug#on('tabular')
  nnoremap <leader><C-t> :Tabularize /
endif

if my#plug#on('vim-windowswap')
  let g:windowswap_map_keys = 0
  nnoremap <silent> <leader>sw :call WindowSwap#EasyWindowSwap()<CR>
  nnoremap <silent> <leader>sm :call WindowSwap#MarkWindowSwap()<CR>
endif

if my#plug#on('golden-ratio')
  let g:golden_ratio_autocommand = 0
  nnoremap <S-F5> :GoldenRatioToggle<CR>
endif

" Sessions (vim-obsession, remplace vim-session) : les sessions sont dans
" local/sessions/. ,ws commence à suivre une session, ,wo en ouvre une,
" ,wl ouvre la plus récente, ,wx met en pause le suivi, ,wv affiche son état.
nnoremap <silent> <leader>wl :call my#buffers#last_session()<CR>
if my#plug#on('vim-obsession')
  execute 'nnoremap <leader>ws :Obsession ' . fnameescape(g:my_local . '/sessions') . '/'
  execute 'nnoremap <leader>wo :source ' . fnameescape(g:my_local . '/sessions') . '/'
  execute 'nnoremap <leader>ww :source ' . fnameescape(g:my_local . '/sessions') . '/'
  nnoremap <leader>wx :Obsession<CR>
  nnoremap <leader>wv :echo ObsessionStatus('Session suivie : ' . v:this_session, 'Aucune session suivie')<CR>
endif

if my#plug#on('csv.vim')
  let g:csv_highlight_column = 'y'
endif
