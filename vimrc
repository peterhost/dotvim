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

" CUSTOM logic
" To disable a plugin, add it's bundle name to the following list
let g:pathogen_disabled = []

" for some reason the csscolor plugin is very slow when run on the terminal
" but not in GVim, so disable it if no GUI is running
if !has('gui_running')
    call add(g:pathogen_disabled, 'csscolor')
	" csapprox needs vim to be compiled with GUI support
	call add(g:pathogen_disabled, 'csapprox')
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
"Bundle: https://github.com/scrooloose/nerdtree
"Bundle: https://github.com/godlygeek/csapprox.git
"Bundle: https://github.com/slack/vim-bufexplorer.git
"Bundle: https://github.com/vim-scripts/Gundo.git
"Bundle: https://github.com/vim-scripts/LustyJuggler.git
"Bundle: http://github.com/scrooloose/syntastic.git
"
"Bundle: https://github.com/vim-scripts/snipMate.git
""" Replacement snippets for snipmate
"" Bundle: https://github.com/scrooloose/snipmate-snippets.git
"" Bundle-Command rake deploy_local



"" COMMAND-T

	"" MACOS : conflict native Ruby / homebrew Ruby -> do this Manually
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

" filetype plugins
filetype plugin indent on
"ex :
"if has('autocmd') "this is for compatibility with older vim versions
"	autocmd filetype python set expandtab
"endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"								STATUS-LINE
"------------------------------------------------------------------------------
source $HOME/.vim/lib/statusbar.vim
" set statusline=%#StatusLineNC#\ Git\ %#ErrorMsg#\ %{GitBranchInfoTokens()[0]}\ %#StatusLine#




"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"								COLORING
"------------------------------------------------------------------------------


" Syntax Highlightning
if &t_Co >= 256 || has("gui_running")
	colorscheme mustang
endif

if &t_Co > 2 || has("gui_running")
	" switch syntax highlighting on, when the terminal has colors
	syntax on
endif



" discrete marking of long lines (> 80)
" (http://stackoverflow.com/questions/235439/vim-80-column-layout-concerns#answer-235970)
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/


" mark non-indent tabs, except on commented lines
match errorMsg /[^"\t]\zs\t\+/





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
nmap <silent> ,/ :nohlsearch<CR>


" Forgot to sudo : save with w!!
cmap w!! w !sudo tee % >/dev/null





""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"							KEY REMAPING
"
"
"               (MODE)?     (NO-RECURSIVE)?     (MAP)
" nmap      =    [n]ormal                        [map]
" noremap   =               [nore]cursive       [map]
" nnoremap  =   [n]ormal    [nore]cursive       [map]
" vnoremap  =   [v]isual    [n,svore]cursive    [map]
"
" ... etc
"
" (http://stackoverflow.com/q/3776117) difference-between-the-remap-noremap...)
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"							PLUGINS
"------------------------------------------------------------------------------

if v:version < '703' || !has('python')
	nnoremap <F5>:GundoToggle<CR>
endif

nmap <leader>G   :ToggleGitMenu<CR>

" shorter than default ,lj
nmap <leader>l   :LustyJuggler<CR>







"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"						MACVIM SPECIFIC STUFF
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has("gui_macvim") 
   " set macvim specific stuff 
endif






"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"								MEMO
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"								PLUGINS
"------------------------------------------------------------------------------
"		BUFFER NAVIGATION
" LustyBuffers : ,lj   -> asdfg... or -> 12345...
" Bufexplorer  : ,be
