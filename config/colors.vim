" colors.vim — thème de couleurs
"
" Défaut : everforest (sombre). Changer :
"   :Theme <Tab>           liste des thèmes affichables ici, puis choix
"   :Theme lucius light    thème + fond
"   <F5>                   bascule clair / sombre
"   ,$n / ,$p              thème suivant / précédent
" Le dernier choix est mémorisé par machine (local/theme.vim). Pour imposer
" un thème sur une machine : `let g:my_theme = '…'` dans ~/.vimrc.local.
"
" Selon le terminal : truecolor ou GUI -> couleurs 24 bits ; 256 couleurs ->
" même thème en 256 ; console Linux / 8-16 couleurs -> noctu, puis PaperColor,
" puis default.

if !has('syntax')
  finish
endif

augroup my_colors
  autocmd!
  autocmd ColorScheme * call my#colors#fixup()
augroup END

command! -nargs=* -complete=customlist,my#colors#complete Theme call my#colors#command(<q-args>)

call my#colors#init()
