" ale.vim — vérification et correction du code (remplace syntastic, jshint,
" gjslint, python-mode, jedi, tern). Utilise les outils installés sur la
" machine (ruff, pyright, eslint, prettier, jq, xmllint…) et ignore les autres.
if !my#plug#on('ale')
  finish
endif
scriptencoding utf-8

let g:ale_fix_on_save = 0
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_set_loclist = 1
let g:ale_open_list = 0
if g:my_utf8
  let g:ale_sign_error = '✗'
  let g:ale_sign_warning = '⚠'
else
  let g:ale_sign_error = '>>'
  let g:ale_sign_warning = '--'
endif

" Correcteurs (F8 dans ces types de fichiers, voir after/ftplugin/)
let g:ale_fixers = {
      \ 'python':     ['ruff', 'ruff_format'],
      \ 'javascript': ['eslint', 'prettier'],
      \ 'typescript': ['eslint', 'prettier'],
      \ 'css':        ['prettier', 'stylelint'],
      \ 'scss':       ['prettier', 'stylelint'],
      \ 'json':       ['jq'],
      \ 'xml':        ['xmllint'],
      \ 'sh':         ['shfmt'],
      \ }

" Erreurs : ,E ouvre la liste, ]d / [d passe à la suivante / précédente
nnoremap <leader>E :lopen<CR>
nmap <silent> ]d <Plug>(ale_next_wrap)
nmap <silent> [d <Plug>(ale_previous_wrap)
