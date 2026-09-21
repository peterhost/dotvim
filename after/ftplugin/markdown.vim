" markdown (et .txt) : texte replié à 72 colonnes, orthographe française
setlocal wrap
setlocal textwidth=72
setlocal spell
setlocal spelllang=fr

" ,P : aperçu (markdown-preview, sinon l'appli Marked sous macOS)
if exists(':MarkdownPreviewToggle') == 2
  nnoremap <buffer> <leader>P :MarkdownPreviewToggle<CR>
elseif g:my_is_mac && isdirectory('/Applications/Marked 2.app')
  nnoremap <buffer> <silent> <leader>P :silent !open -a 'Marked 2' '%:p'<CR>:redraw!<CR>
endif
