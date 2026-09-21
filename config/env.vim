" env.vim — détection de l'environnement
"
" Aucun appel à system() ici : tout doit rester instantané, même sous Cygwin
" ou sur un NAS. On ne se sert que de has(), exists(), executable() et $VAR.

" Encodage interne : à régler avant tout le reste.
if has('multi_byte')
  set encoding=utf-8
endif
scriptencoding utf-8

" --- Système -----------------------------------------------------------------
let g:my_is_win    = has('win32') || has('win64')
let g:my_is_cygwin = has('win32unix')
let g:my_is_mac    = has('mac') || has('macunix') || has('osx')
let g:my_is_linux  = has('unix') && !g:my_is_mac && !g:my_is_cygwin

" Dossier des données locales (undo, vues, sessions, état) : jamais versionné.
" $MY_VIM_LOCAL permet de le déplacer (utilisé par les tests).
let g:my_local = empty($MY_VIM_LOCAL) ? g:my_dir . '/local' : $MY_VIM_LOCAL

" --- Préférences propres à la machine ----------------------------------------
" local/vimrc.local (jamais versionné) est lu tôt, pour pouvoir régler ce qui
" suit ; ~/.vimrc.local reste lu s'il existe encore (ancien emplacement) :
"   let g:my_theme          = 'lucius'   " thème par défaut
"   let g:my_background     = 'light'    " fond clair/sombre par défaut
"   let g:my_force_tier     = 'compat'   " forcer un niveau
"   let g:my_disabled       = ['ale']    " plugins à ne pas charger
"   let g:my_autoupdate_days = 0         " pas de mise à jour automatique
"   let g:my_powerline_fonts = 1         " polices patchées pour airline
"   let g:my_undercurl      = 1          " le terminal gère les soulignés ondulés
" Pour des réglages à appliquer en toute fin de démarrage :
"   autocmd VimEnter * …
for s:f in [g:my_local . '/vimrc.local', expand('~/.vimrc.local'), expand('~/_vimrc.local')]
  if filereadable(s:f)
    execute 'source ' . fnameescape(s:f)
    break
  endif
endfor
unlet! s:f

" --- Niveau de fonctionnement --------------------------------------------------
"   full    vim >= 8.0 avec jobs et timers : tout
"   compat  vim 7.3 à 7.4 : plugins en vimscript pur, sans tâches asynchrones
"   minimal plus vieux, ou vim-plug absent : options et raccourcis seulement
if v:version >= 800 && has('job') && has('timers') && has('lambda')
  let g:my_tier = 'full'
elseif v:version >= 703
  let g:my_tier = 'compat'
else
  let g:my_tier = 'minimal'
endif
if !filereadable(g:my_dir . '/autoload/plug.vim')
  let g:my_tier = 'minimal'
endif
if exists('g:my_force_tier') && index(['full', 'compat', 'minimal'], g:my_force_tier) >= 0
  let g:my_tier = g:my_force_tier
endif

" --- Terminal --------------------------------------------------------------------
let g:my_gui = has('gui_running')
" Console Linux (Ctrl+Alt+F1…) et autres terminaux très limités.
let g:my_tty = !g:my_gui && ($TERM ==# 'linux' || $TERM =~# '^\(cons\|vt\d\|dumb\)')

" Couleurs 24 bits : on se fie aux variables que posent les terminaux modernes.
let g:my_truecolor = g:my_gui || (has('termguicolors') && !g:my_tty && (
      \ $COLORTERM =~? 'truecolor\|24bit'
      \ || $TERM_PROGRAM =~# 'iTerm\|WezTerm\|vscode\|ghostty'
      \ || $TERM =~# 'kitty\|alacritty\|wezterm\|ghostty\|foot\|-direct'))
if exists('g:my_force_truecolor')
  let g:my_truecolor = g:my_force_truecolor
endif

" Nombre de couleurs utilisables.
if g:my_truecolor
  let g:my_colors = 16777216
else
  let g:my_colors = str2nr(&t_Co)
  if g:my_colors == 0
    let g:my_colors = g:my_gui ? 16777216 : 8
  endif
endif

" Soulignés ondulés (orthographe) : seulement sur les terminaux connus pour
" les gérer, sinon certains affichent la séquence comme souligné + italique.
if !exists('g:my_undercurl')
  let g:my_undercurl = !g:my_tty && empty($TMUX) && (
        \ $TERM_PROGRAM =~# 'iTerm\|WezTerm\|ghostty'
        \ || $TERM =~# 'kitty\|wezterm\|ghostty\|foot\|alacritty')
endif

" Symboles Unicode seulement si l'encodage le permet (sinon : ASCII).
let g:my_utf8 = &encoding ==# 'utf-8' && !g:my_tty

" --- Dossiers locaux -----------------------------------------------------------------
if exists('*mkdir')
  for s:d in ['undo', 'views', 'sessions', 'tmp']
    if !isdirectory(g:my_local . '/' . s:d)
      silent! call mkdir(g:my_local . '/' . s:d, 'p')
    endif
  endfor
  unlet! s:d
endif

" --- Historique (viminfo) dans local/ ----------------------------------------------------
" L'ancien ~/.viminfo est copié une fois, pour garder l'historique existant.
if has('viminfo')
  let s:vi = g:my_local . '/viminfo'
  if !filereadable(s:vi) && filereadable(expand('~/.viminfo')) && exists('*writefile')
    silent! call writefile(readfile(expand('~/.viminfo'), 'b'), s:vi, 'b')
  endif
  let &viminfo = substitute(&viminfo, ',\=n[^,]*', '', 'g') . ',n' . s:vi
  unlet s:vi
endif
