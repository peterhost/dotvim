" writing.vim — écriture : Goyo (plein écran), Limelight, Pencil, Grammalecte
if my#plug#on('goyo.vim')
  let g:goyo_linenr = 1
  augroup my_goyo
    autocmd!
    autocmd User GoyoEnter nested call my#writing#enter()
    autocmd User GoyoLeave nested call my#writing#leave()
  augroup END
endif

if my#plug#on('limelight.vim')
  " couleur du texte estompé quand le thème ne permet pas de la calculer
  let g:limelight_conceal_ctermfg = 'darkgray'
endif

let g:pencil_terminal_italics = 1
