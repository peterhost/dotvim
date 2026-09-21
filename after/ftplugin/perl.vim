" perl : ,h affiche la doc perl du mot (ou du module) sous le curseur
if executable('perldoc')
  nnoremap <buffer> <silent> <leader>h :call my#buffers#perldoc()<CR>
endif
