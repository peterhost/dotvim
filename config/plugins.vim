" plugins.vim — liste des plugins (vim-plug)
"
" Installation / mise à jour : `make update`, ou :PlugInstall / :PlugUpdate.
" Chaque plugin a une condition : si elle est fausse, il est déclaré mais pas
" chargé (voir autoload/my/plug.vim). Aucun plugin ne doit pouvoir faire
" échouer le démarrage.

if g:my_tier ==# 'minimal'
  filetype plugin indent on
  if has('syntax')
    syntax on
  endif
  finish
endif

let s:full  = g:my_tier ==# 'full'
let s:node  = executable('node')

" raccourci local (function() sur une fonction autoload échoue en vim 7.3)
function! s:P(...)
  call call('my#plug#add', a:000)
endfunction

call plug#begin(g:my_dir . '/plugged')

" --- Édition -------------------------------------------------------------------
call s:P('tpope/vim-repeat', 1)
call s:P('tpope/vim-surround', 1)
call s:P('tpope/vim-unimpaired', 1)
call s:P('godlygeek/tabular', 1)
call s:P('preservim/nerdcommenter', 1)
call s:P('ervandew/supertab', 1)
call s:P('mbbill/undotree', 1)
call s:P('junegunn/vim-peekaboo', 1)
" snippets (remplace xptemplate)
call s:P('hrsh7th/vim-vsnip', s:full)
call s:P('rafamadriz/friendly-snippets', s:full)

" --- Fichiers, buffers, fenêtres ---------------------------------------------------
call s:P('preservim/nerdtree', 1)
call s:P('ctrlpvim/ctrlp.vim', 1)
call s:P('junegunn/fzf', s:full, {'do': ':call fzf#install()'})
call s:P('junegunn/fzf.vim', s:full)
call s:P('cespare/vim-bclose', 1)
call s:P('wesQ3/vim-windowswap', 1)
call s:P('roman/golden-ratio', 1)
call s:P('christoomey/vim-tmux-navigator', exists(':tnoremap') == 2)
call s:P('tpope/vim-obsession', v:version >= 704)
call s:P('vim-scripts/LargeFile', 1)

" --- Git ------------------------------------------------------------------------------
call s:P('tpope/vim-fugitive', v:version >= 704)
call s:P('tpope/vim-rhubarb', v:version >= 704)
call s:P('mattn/webapi-vim', 1)
call s:P('mattn/vim-gist', 1)

" --- Barre d'état ---------------------------------------------------------------------
call s:P('vim-airline/vim-airline', v:version >= 704)
call s:P('vim-airline/vim-airline-themes', v:version >= 704)
call s:P('edkolev/tmuxline.vim', v:version >= 704)

" --- Code : vérification, correction, navigation ------------------------------------------
call s:P('dense-analysis/ale', s:full)
call s:P('preservim/tagbar', 1)

" --- Langages ---------------------------------------------------------------------------
call s:P('pangloss/vim-javascript', 1)
call s:P('heavenshell/vim-jsdoc', s:full && s:node,
      \ executable('npm') ? {'do': 'make install'} : {})
call s:P('othree/html5.vim', 1)
call s:P('ap/vim-css-color', v:version >= 704,
      \ {'for': ['css', 'scss', 'sass', 'less', 'stylus', 'html', 'vim']})
call s:P('chrisbra/csv.vim', has('lambda'))
call s:P('preservim/vim-markdown', 1)
call s:P('iamcco/markdown-preview.nvim', s:full && s:node,
      \ {'do': ':call mkdp#util#install()'})
call s:P('itspriddle/vim-jekyll', 1)
call s:P('digitaltoad/vim-pug', 1, {'for': ['pug', 'jade']})
call s:P('iloginow/vim-stylus', 1, {'for': 'stylus'})
" syntaxes livrées avec les vim récents : chargées seulement si absentes
call s:P('cespare/vim-toml', my#plug#missing_syntax('syntax/toml.vim'))
call s:P('cakebaker/scss-syntax.vim', my#plug#missing_syntax('syntax/scss.vim'))
call s:P('tpope/vim-git', my#plug#missing_syntax('syntax/gitrebase.vim'))

" --- Écriture ----------------------------------------------------------------------------
call s:P('junegunn/goyo.vim', 1)
call s:P('junegunn/limelight.vim', 1)
call s:P('preservim/vim-pencil', 1)
call s:P('dpelle/vim-Grammalecte', exists('*json_decode'))

" --- Thèmes (voir config/colors.vim) ------------------------------------------------------
" PaperColor, lucius et noctu sont copiés dans colors/ : ils marchent sans
" plugins (machine sans git, vim-tiny…).
call s:P('sainnhe/everforest', v:version >= 800)
call s:P('sainnhe/edge', v:version >= 800)
call s:P('catppuccin/vim', v:version >= 800, {'as': 'catppuccin'})
call s:P('lifepillar/vim-solarized8', v:version >= 800)
call s:P('preservim/vim-colors-pencil', 1)

call plug#end()
" plug#end() active `filetype plugin indent on` et `syntax enable`.

" matchit : extension de % (balises HTML, if/endif…), livrée avec vim.
if !exists('g:loaded_matchit')
  if exists(':packadd')
    silent! packadd! matchit
  else
    runtime macros/matchit.vim
  endif
endif

" Mise à jour des plugins en arrière-plan, au plus une fois par semaine
" (g:my_autoupdate_days dans ~/.vimrc.local ; 0 = désactivé).
augroup my_update
  autocmd!
  autocmd VimEnter * call my#update#start()
augroup END
command! PluginsUpdateLog execute 'split ' . fnameescape(g:my_local . '/update.log')

unlet s:full s:node
delfunction s:P
