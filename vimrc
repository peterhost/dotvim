" vimrc — point d'entrée de la configuration (voir README.md)
"
" Organisation :
"   config/env.vim        détection : dossier, OS, niveau (full/compat/minimal), terminal
"   config/plugins.vim    liste des plugins (vim-plug) et conditions de chargement
"   config/options.vim    options générales
"   config/colors.vim     thème selon les capacités du terminal
"   config/highlights.vim surlignages maison (espaces, tabulations, lignes longues)
"   config/mappings.vim   raccourcis globaux
"   config/plugins/*.vim  réglages propres à chaque plugin
"   autoload/my/*.vim     fonctions (chargées à la demande)
"   after/ftplugin/*.vim  réglages par type de fichier
"
" Règle d'or : si quelque chose manque (plugin, option, outil externe),
" on le désactive sans bruit. Aucune erreur au démarrage, sur aucun vim.

" --- Socle lisible par tous les vim, y compris vim-tiny (sans +eval) -------
" vim-tiny ignore le contenu des blocs `if` : hors du bloc ci-dessous, on
" s'en tient à des `set` simples.
set nocompatible
set backspace=indent,eol,start
set hidden
set nowrap
set number
set autoindent
set expandtab
set tabstop=4
set shiftwidth=4
set shiftround
set smarttab
set ignorecase
set smartcase
set hlsearch
set incsearch
set showmatch
set showcmd
set scrolloff=6
set nobackup
set noswapfile
set laststatus=2
set visualbell
set noerrorbells

" --- Tout le reste nécessite +eval ------------------------------------------
if 1
  " Dossier réel de cette config (suit les liens symboliques) : permet de
  " l'utiliser depuis ~/.vim, ~/.vimnew, ~/vimfiles ou via `vim -u …/vimrc`.
  let g:my_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')

  " Hors du dossier standard (~/.vim ou ~/vimfiles), g:my_dir remplace ce
  " dernier dans 'runtimepath' : l'essai d'une nouvelle version n'utilise
  " alors rien de l'ancienne.
  let s:std = expand(has('win32') || has('win64') ? '~/vimfiles' : '~/.vim')
  if resolve(s:std) !=# g:my_dir
    let s:rtp = filter(split(&runtimepath, ','),
          \ 'v:val !=# s:std && v:val !=# s:std . "/after"')
    let &runtimepath = join([g:my_dir] + s:rtp + [g:my_dir . '/after'], ',')
    if exists('+packpath')
      let &packpath = &runtimepath
    endif
    " historique séparé, pour ne pas mélanger avec l'autre config
    set viminfo+=n~/.viminfo.vimnew
    unlet s:rtp
  endif
  unlet s:std

  function! s:source(name)
    let l:file = g:my_dir . '/config/' . a:name . '.vim'
    if filereadable(l:file)
      execute 'source ' . fnameescape(l:file)
    endif
  endfunction

  call s:source('env')
  call s:source('plugins')
  call s:source('options')
  call s:source('colors')
  call s:source('highlights')
  call s:source('mappings')
  for s:f in split(glob(g:my_dir . '/config/plugins/*.vim'), '\n')
    execute 'source ' . fnameescape(s:f)
  endfor
  unlet! s:f
endif
