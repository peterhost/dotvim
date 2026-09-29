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

" Raison de l'écart, affichée par « vrc greffons » : ce qui MANQUE sur cette machine,
" et non la condition telle qu'elle est écrite. Un greffon écarté sans raison dite est
" un oubli, et test/probe.vim le refuse.
let s:r_full = 'niveau complet requis (vim ≥ 8 avec tâches de fond)'
let s:r_74   = 'vim ≥ 7.4 requis'
let s:r_80   = 'vim ≥ 8 requis'
let s:r_node = 'niveau complet et node requis'
let s:r_deja = 'inutile ici : vim fournit déjà cette syntaxe'

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
" historique des copies (remplace YankRing) : vim 8+
call s:P('svermeulen/vim-yoink', exists('##TextYankPost'), 'vim sans l''événement TextYankPost (vim 8+)')
" snippets (remplace xptemplate)
call s:P('hrsh7th/vim-vsnip', s:full, s:r_full)
call s:P('rafamadriz/friendly-snippets', s:full, s:r_full)

" --- Fichiers, buffers, fenêtres ---------------------------------------------------
call s:P('preservim/nerdtree', 1)
call s:P('ctrlpvim/ctrlp.vim', 1)
call s:P('jlanzarotta/bufexplorer', v:version >= 704, s:r_74)
call s:P('junegunn/fzf', s:full, {'do': ':call fzf#install()'}, s:r_full)
call s:P('junegunn/fzf.vim', s:full, s:r_full)
call s:P('cespare/vim-bclose', 1)
call s:P('wesQ3/vim-windowswap', 1)
call s:P('roman/golden-ratio', 1)
call s:P('christoomey/vim-tmux-navigator', exists(':tnoremap') == 2, 'vim sans :terminal')
call s:P('tpope/vim-obsession', v:version >= 704, s:r_74)
call s:P('vim-scripts/LargeFile', 1)

" --- Git ------------------------------------------------------------------------------
call s:P('tpope/vim-fugitive', v:version >= 704, s:r_74)
call s:P('tpope/vim-rhubarb', v:version >= 704, s:r_74)
call s:P('mattn/webapi-vim', 1)
call s:P('mattn/vim-gist', 1)

" --- Barre d'état ---------------------------------------------------------------------
call s:P('vim-airline/vim-airline', v:version >= 704, s:r_74)
call s:P('vim-airline/vim-airline-themes', v:version >= 704, s:r_74)
call s:P('edkolev/tmuxline.vim', v:version >= 704, s:r_74)

" --- Code : vérification, correction, navigation ------------------------------------------
call s:P('dense-analysis/ale', s:full, s:r_full)
call s:P('preservim/tagbar', 1)

" --- Langages ---------------------------------------------------------------------------
call s:P('pangloss/vim-javascript', 1)
" objets et déplacements classe/fonction en python (remplace python-mode)
call s:P('jeetsukumaran/vim-pythonsense', v:version >= 704, s:r_74)
" npm_config_cache : le cache de npm reste dans le dossier du plugin, jamais
" dans ~/.npm (rien ne doit être écrit hors de ~/.vim)
call s:P('heavenshell/vim-jsdoc', s:full && s:node, s:r_node,
      \ executable('npm') ? {'do': 'npm_config_cache=./.npm-cache make install'} : {})
call s:P('othree/html5.vim', 1)
call s:P('ap/vim-css-color', v:version >= 704, s:r_74,
      \ {'for': ['css', 'scss', 'sass', 'less', 'stylus', 'html', 'vim']})
call s:P('chrisbra/csv.vim', has('lambda'), 'vim sans +lambda')
call s:P('preservim/vim-markdown', 1)
call s:P('iamcco/markdown-preview.nvim', s:full && s:node, s:r_node,
      \ {'do': ':call mkdp#util#install()'})
call s:P('itspriddle/vim-jekyll', 1)
call s:P('digitaltoad/vim-pug', 1, {'for': ['pug', 'jade']})
call s:P('iloginow/vim-stylus', 1, {'for': 'stylus'})
" syntaxes livrées avec les vim récents : chargées seulement si absentes
call s:P('cespare/vim-toml', my#plug#missing_syntax('syntax/toml.vim'), s:r_deja)
call s:P('cakebaker/scss-syntax.vim', my#plug#missing_syntax('syntax/scss.vim'), s:r_deja)
call s:P('tpope/vim-git', my#plug#missing_syntax('syntax/gitrebase.vim'), s:r_deja)

" --- Écriture ----------------------------------------------------------------------------
call s:P('junegunn/goyo.vim', 1)
call s:P('junegunn/limelight.vim', 1)
call s:P('preservim/vim-pencil', 1)
call s:P('dpelle/vim-Grammalecte', exists('*json_decode'), 'vim sans json_decode (vim 8+)')

" --- Thèmes (voir config/colors.vim) ------------------------------------------------------
" PaperColor, lucius et noctu sont copiés dans colors/ : ils marchent sans
" plugins (machine sans git, vim-tiny…).
call s:P('sainnhe/everforest', v:version >= 800, s:r_80)
call s:P('sainnhe/edge', v:version >= 800, s:r_80)
call s:P('catppuccin/vim', v:version >= 800, {'as': 'catppuccin'}, s:r_80)
call s:P('lifepillar/vim-solarized8', v:version >= 800, s:r_80)
" palettes communes avec le shell (voir config/colors.vim) : gruvbox, nord, tokyonight
call s:P('lifepillar/vim-gruvbox8', v:version >= 800, s:r_80)
call s:P('arcticicestudio/nord-vim', v:version >= 800, s:r_80)
call s:P('ghifarit53/tokyonight-vim', v:version >= 800, s:r_80)
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
  " message après l'affichage initial (sinon effacé par le premier rendu)
  if exists('*timer_start')
    autocmd VimEnter * call timer_start(300, 'my#update#notify')
  else
    autocmd VimEnter * call my#update#notify()
  endif
augroup END
"= greffons | ouvrir le journal des mises à jour de greffons
command! PluginsUpdateLog execute 'split ' . fnameescape(g:my_local . '/update.log')

unlet s:full s:node s:r_full s:r_74 s:r_80 s:r_node s:r_deja
delfunction s:P
