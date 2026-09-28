" perl : ,h affiche la doc perl du mot (ou du module) sous le curseur
if executable('perldoc')
"= langages | doc perl du mot ou du module sous le curseur
  nnoremap <buffer> <silent> <leader>h :call my#buffers#perldoc()<CR>
endif
