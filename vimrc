"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"								web resources
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" http://objectmix.com/editors/394885-how-do-you-parameterize-your-vimrc-different-machines.html
" https://github.com/bronson/vim-update-bundles 
" LustyJuggler  screencast:     http://lococast.net/archives/185
" Command-T     screencast:     https://wincent.com/products/command-t
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""




"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"								PATHOGEN
"								
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"							Pathogen SETUP
"------------------------------------------------------------------------------


" This must be first, because it changes other options as side effect
set nocompatible

" PATHOGEN
"" Needed on some linux distros.
"" see http://www.adamlowe.me/2009/12/vim-destroys-all-other-rails-editors.html
"filetype off


"------------------------------------------------------------------------------
"                  Load/Unload plugins (VIM specificities)
"------------------------------------------------------------------------------
" CUSTOM logic
" To disable a plugin, add it's bundle name to the following list
let g:pathogen_disabled = []

" for some reason the csscolor plugin is very slow when run on the terminal
" but not in GVim, so disable it if no GUI is running
if !has('gui_running')
    call add(g:pathogen_disabled, 'csscolor')
	" csapprox needs vim to be compiled with GUI support
endif
	
if !has('gui') "need vim compiled with gui support to work
	call add(g:pathogen_disabled, 'csapprox')
endif
	
if  !has('ruby')
	call add(g:pathogen_disabled, 'LustyJuggler')
endif

" Gundo requires at least vim 7.3
if v:version < '703' || !has('python')
    call add(g:pathogen_disabled, 'Gundo')
endif


if v:version < '702'
    call add(g:pathogen_disabled, 'autocomplpop')
    call add(g:pathogen_disabled, 'fuzzyfinder')
    call add(g:pathogen_disabled, 'l9')
endif




" It is essential that these lines are called before enabling filetype detection
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()

"------------------------------------------------------------------------------
"							Pathogen BUNDLES
"------------------------------------------------------------------------------
"Bundle: https://github.com/tpope/vim-fugitive.git
"Bundle: https://github.com/taq/vim-git-branch-info.git
"Bundle: https://github.com/wookiehangover/jshint.vim.git
""Bundle-command: rake
"Bundle: https://github.com/scrooloose/nerdtree
"Bundle: https://github.com/godlygeek/csapprox.git
"Bundle: https://github.com/slack/vim-bufexplorer.git
"Bundle: https://github.com/vim-scripts/Gundo.git
"Bundle: https://github.com/vim-scripts/LustyJuggler.git
"Bundle: https://github.com/scrooloose/syntastic.git
"Bundle: https://github.com/vim-scripts/Gist.vim.git
"Bundle: https://github.com/mhz/vim-matchit.git
"Bundle: https://github.com/vim-scripts/taglist.vim.git
""Bundle: https://github.com/vim-scripts/ToggleComment.git
"Bundle: https://github.com/scrooloose/nerdcommenter.git
"Bundle: https://github.com/robgleeson/vim-markdown-preview.git

" ----------NOT SURE-------------------

"Bundle: https://github.com/ervandew/supertab.git
"Bundle: https://github.com/vim-scripts/SearchComplete.git
"Bundle: https://github.com/vim-scripts/ShowMarks.git
"Bundle: https://github.com/vim-scripts/buftabs.git
"Bundle: https://github.com/tpope/vim-markdown.git
"Bundle: https://github.com/vim-scripts/YankRing.vim.git




"Bundle: https://github.com/vim-scripts/snipMate.git
""" Replacement snippets for snipmate
"" Bundle: https://github.com/scrooloose/snipmate-snippets.git
"" Bundle-Command: rake deploy_local



"" COMMAND-T

	"" MACOS : conflict native Ruby / homebrew Ruby -> do this Manually
	"" (https://wincent.com/forums/command-t/topics/425#comment_6536)
	""	 Download the bundle, then :
	""	 $ cd ~/.vim/bundle/command-t/ruby/command-t/
	""	 Compile it with RUBY 1.8 !! (not homebrew's ruby)
	""	 $ /System/Library/Frameworks/Ruby.framework/Versions/Current/usr/bin/ruby extconf.rb
	""	 $ make
	" Static:  command-t
	"" Bundle: git://git.wincent.com/command-t.git
	"" Bundle-Command: rake make






"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"								GENERAL SETTINGS
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" UTF8 by default
set encoding=utf-8

"---------------------------------------------------------
" FROM : http://nvie.com/posts/how-i-boosted-my-vim/

" change the mapleader from \ to ,
let mapleader=","

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>
" Same for the statusLine
nmap <silent> <leader>ss :so $HOME/.vim/lib/statusbar.vim<CR>

" hide bufers instead of closing them
set hidden

" usefull stuff
set nowrap        " don't wrap lines
set tabstop=4     " a tab is four spaces
set backspace=indent,eol,start
                  " allow backspacing over everything in insert mode
                  " (needed on some linux systems - 
                  "  cf. http://vim.wikia.com/wiki/Backspace_and_delete_problems)
set autoindent    " always set autoindenting on
set copyindent    " copy the previous indentation on autoindenting
set number        " always show line numbers
set shiftwidth=4  " number of spaces to use for autoindenting
set shiftround    " use multiple of shiftwidth when indenting with '<' and '>'
set showmatch     " set show matching varenthesis
set ignorecase    " ignore case when searching
set smartcase     " ignore case if search pattern is all lowercase,
                  "    case-sensitive otherwise
set smarttab      " insert tabs on the start of a line according to
                  "    shiftwidth, not tabstop
set hlsearch      " highlight search terms
set incsearch     " show search matches as you type


" and some more
set history=10000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo
set wildignore=*.swp,*.bak,*.pyc,*.class
set title                " change the terminal's title
set visualbell           " don't beep
set noerrorbells         " don't beep

" no backups please, use git
set nobackup
set noswapfile

" filetype detection, plugin and indent : ON
filetype plugin indent on
"ex :

"if has('autocmd') "this is for compatibility with older vim versions
"	autocmd filetype python set expandtab
"endif




"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"								COLORING
"------------------------------------------------------------------------------
"
" GOTCHA : carefull to always do 'colorscheme'ing before declaring custom 
"          highlight groups, as the colorscheme directive resets them
"          (ex: status bar construction)
"
"------------------------------------------------------------------------------


" -------Syntax Highlightning----------

if &t_Co >= 256 || has("gui_running")
	colorscheme mustang
endif

if &t_Co > 2 || has("gui_running")
	" switch syntax highlighting on, when the terminal has colors
	syntax on
endif

" ----------Additional Syntax----------

" JSON : js syntax suffices
autocmd BufNewFile,BufRead *.json set ft=javascript


" ----------Long-Lines-Suck------------
"
" discrete marking of long lines (> 80)
" (http://stackoverflow.com/questions/235439/vim-80-column-layout-concerns#answer-235970)
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/


" -----------TAB Detection-------------
"
" mark non-indent tabs, except on commented lines
match errorMsg /[^"\t]\zs\t\+/




"--------non-printable-characters------
"
" Whitespaces, line-end
" more : h listchars
set nolist
set listchars=trail:.,extends:#,nbsp:.

" show tabs for specific files
if has('autocmd')
	autocmd filetype py set list
	autocmd filetype py set listchars=tab:┊_,trail:.,extends:#,nbsp:.
endif


" disable AUTOindenting when doing big pastes
set pastetoggle=<F2>



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"								STATUS-LINE
"------------------------------------------------------------------------------

source $HOME/.vim/lib/statusbar.vim






""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"							KEY REMAPING
"
"
"               (MODE)?     (NO-RECURSIVE)?     (MAP)
" nmap      =   [n]ormal                        [map]
" noremap   =               [nore]cursive       [map]
" nnoremap  =   [n]ormal    [nore]cursive       [map]
" vnoremap  =   [v]isual    [n,svore]cursive    [map]
"
" ... etc
"
" (http://stackoverflow.com/q/3776117) difference-between-the-remap-noremap...)
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"------------------------------------------------------------------------------
"							GENERAL
"------------------------------------------------------------------------------

" Use Q for formatting the current paragraph (or selection)
vmap Q gq
nmap Q gqap

" learn the bloody keys, don't use arrows
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>


" Easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Easy clear search : ,/
nmap <silent> <leader>/ :nohlsearch<CR>


" Forgot to sudo : save with w!!
cmap w!! w !sudo tee % >/dev/null

" hide buffer/split
nmap <leader>x   :clo<CR>


" map control-backspace to delete the previous word in edit mode
imap <C-BS> <C-W>

"------------------------------------------------------------------------------
"							HELP
"------------------------------------------------------------------------------

" this section has been moved to $VIMHOME/ftplugin/help.vim


"------------------------------------------------------------------------------
"							PLUGINS
"------------------------------------------------------------------------------

"--------------Gundo-------------------
if ! v:version < '703' || !has('python')
	nnoremap <leader>u :GundoToggle<CR>
endif

"-------------LustyJugler--------------
" ,l (shorter than default ,lj )
" unmap first to remove the 1 second delay
if hasmapto(":LustyJuggler")
	nunmap <leader>lj
endif
nmap <leader>l   :LustyJuggler<CR>


"-------------TagList------------------
" taglist to ,T
nmap <leader>T   :TlistToggle<CR>


"-------------FuGITive-----------------
" GIT (fugitive)
nmap <leader>gs  :Gstatus<CR>
nmap <leader>gc  :Gcommit<CR>
nmap <leader>gg  :Ggrep
nmap <leader>ga  :Gwrite<CR>           " git add current file
nmap <leader>gl  :Glog
nmap <leader>gdc :Gdiff --cached<CR>
nmap <leader>gdh :Gdiff HEAD<CR>
nmap <leader>gdo :Gdiff ORIG_HEAD<CR>
nmap <leader>gb  :Gbrowse<CR>





"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"						MACVIM SPECIFIC STUFF
"                   (that you wouldn't put in gvimrc)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has("gui_macvim") 
   " set macvim specific stuff 
endif





"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"						USERS' LOCAL CONFIG
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""



" Include user's local vim config
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"								MEMO
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"								PLUGINS
"------------------------------------------------------------------------------
"		BUFFER NAVIGATION
"
" LustyBuffers : ,lj   -> asdfg... or -> 12345...
" Bufexplorer  : ,be
" TagList      : ,T
" command-T    : ,t
" GundoToggle  : ,u
"
"
"		MACOS KeyRemap4Macbook
"
" EJECT     -> forward delete
" CAPS LOCK -> ESC
"
"
"------------------------------------------------------------------------------
"								MISC
"------------------------------------------------------------------------------
"
"		VIM DIFF MODE
"
" do : diff obtain --> Modify the current buffer to undo difference with another buffer
" dp : diff put    --> Modify another buffer to undo differences with th ecurrent buffer
