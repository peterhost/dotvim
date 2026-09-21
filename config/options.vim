" options.vim — options générales
"
" Les options de base (tabulations, recherche…) sont au début du vimrc, pour
" vim-tiny. Ici : ce qui demande +eval ou une fonctionnalité optionnelle.
scriptencoding utf-8

let mapleader = ','
let maplocalleader = '='

" --- Fichiers et historique ----------------------------------------------------------
set history=10000
set undolevels=1000
set fileencodings=ucs-bom,utf-8,default,latin1
set wildignore=*.swp,*.bak,*.pyc,*.class,*.o,.DS_Store
set wildmenu
set wildmode=full
if exists('+wildignorecase')
  set wildignorecase
endif
set title
set shortmess+=tI
set sessionoptions=buffers,curdir,folds,localoptions,tabpages,winsize
let &viewdir = g:my_local . '/views'

" Annulation persistante : l'historique d'annulation survit à la fermeture.
if has('persistent_undo')
  let &undodir = g:my_local . '/undo'
  set undofile
endif

" --- Affichage ---------------------------------------------------------------------------
set showtabline=1
set winminheight=1
set formatoptions+=croql
if v:version > 703 || v:version == 703 && has('patch541')
  set formatoptions+=j   " fusion de lignes : retire les marques de commentaire
endif
if exists('+breakindent')
  set breakindent
endif
set nospell
set spelllang=fr

" Caractères invisibles : tabulations discrètes, espaces en fin de ligne marqués.
set list
if g:my_utf8
  set listchars=tab:\ \ ,extends:#,trail:⋅,nbsp:⋅
else
  set listchars=tab:\ \ ,extends:#,trail:.,nbsp:.
endif

" Mode collage (désactive l'indentation automatique) — option retirée des vim récents.
if exists('+pastetoggle')
  set pastetoggle=<F10>
endif

" --- Repliage --------------------------------------------------------------------------
if has('folding')
  set foldenable
  set foldmethod=syntax
endif
let g:vimsyn_folding = 'afmpPrt'
let g:is_bash = 1
let g:sh_fold_enabled = 7
let g:xml_syntax_folding = 1

" --- Langages (variables lues par les fichiers de syntaxe/indentation de vim) --------------
let g:PHP_autoformatcomment = 0
let g:PHP_default_indenting = 1
let g:markdown_fenced_languages = ['python', 'javascript', 'js=javascript',
      \ 'sh', 'bash=sh', 'vim', 'json', 'yaml', 'html', 'css', 'sql']

" --- Forme du curseur dans le terminal ---------------------------------------------------
" Barre en insertion, bloc sinon (séquences DECSCUSR, gérées par tmux et par
" la plupart des terminaux). Pas en console Linux, qui ne les connaît pas.
if !g:my_gui && !g:my_tty && exists('&t_SI')
  let &t_SI = "\<Esc>[6 q"
  let &t_EI = "\<Esc>[2 q"
  if exists('&t_SR')
    let &t_SR = "\<Esc>[4 q"
  endif
endif

" --- Autocommandes générales -----------------------------------------------------------
augroup my_options
  autocmd!
  " Revenir à la dernière position connue dans le fichier.
  autocmd BufReadPost *
        \ if &filetype !~# 'commit' && line("'\"") > 0 && line("'\"") <= line('$')
        \ |   execute 'normal! g`"'
        \ | endif
  " Ligne du curseur surlignée seulement dans la fenêtre active.
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
  " Redessiner au retour dans le terminal (évite les caractères fantômes).
  autocmd FocusGained * silent! redraw!
augroup END
