"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                               web resources
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" http://objectmix.com/editors/394885-how-do-you-parameterize-your-vimrc-different-machines.html
" https://github.com/bronson/vim-update-bundles
" LustyJuggler  screencast:     http://lococast.net/archives/185
" Command-T     screencast:     https://wincent.com/products/command-t
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""




"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                               PATHOGEN
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" This must be first, because it changes other options as side effect
set nocompatible

"" Needed on some linux distros for proper pathogen loading
"" see http://www.adamlowe.me/2009/12/vim-destroys-all-other-rails-editors.html
filetype off


"------------------------------------------------------------------------------
"                      Load/Unload plugins RULES
"------------------------------------------------------------------------------
" CUSTOM logic
" To disable a plugin, add it's bundle name to the following list
let g:pathogen_disabled = []


if !has('gui_running')
  call add(g:pathogen_disabled, 'css-color')
  " for some reason the csscolor plugin is very slow when run on the terminal
  " but not in GVim, so disable it if no GUI is running
endif


if has('gui_running')
  call add(g:pathogen_disabled, 'buftabs')
  " we don't want tabs in statusbar when using GUI
endif


if !has('gui')
  call add(g:pathogen_disabled, 'csapprox')
  "csapprox need vim compiled with gui support to work
endif


if  !has('ruby')
  call add(g:pathogen_disabled, 'LustyJuggler')
  " All those need ruby support
endif


if v:version < '703' || !has('python')
  call add(g:pathogen_disabled, 'Gundo')
  " Gundo requires at least vim 7.3
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
"                           Pathogen BUNDLES
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
"Bundle: https://github.com/scrooloose/nerdcommenter.git
"Bundle: https://github.com/plasticboy/vim-markdown.git
"Bundle: https://github.com/robgleeson/vim-markdown-preview.git
"Bundle: https://github.com/tpope/vim-surround.git
"Bundle: https://github.com/vim-scripts/repeat.vim.git
"Bundle: https://github.com/skammer/vim-css-color.git
"Bundle: https://github.com/vim-scripts/Conque-Shell.git
"Bundle: https://github.com/vim-scripts/YankRing.vim.git

" ----------TAGLIST-PLUS----------------
"  for JS goodness, you also need node.js & jsdoctor
"  installed on your system (jsdoctor = jsctags)
""Bundle: https://github.com/vim-scripts/taglist.vim.git
"Bundle: https://github.com/int3/vim-taglist-plus.git


" ----------SNIPMATE-------------------
"Bundle: https://github.com/vim-scripts/snipMate.git
""" Replacement snippets for snipmate
"" Bundle: https://github.com/scrooloose/snipmate-snippets.git
"" Bundle-Command: rake deploy_local


" ----------COMMAND-T------------------
"" MACOS : conflict native Ruby / homebrew Ruby -> do this Manually
"" (https://wincent.com/forums/command-t/topics/425#comment_6536)
""      Download the bundle, then :
""      $ cd ~/.vim/bundle/command-t/ruby/command-t/
""      Compile it with RUBY 1.8 !! (not homebrew's ruby)
""      $ /System/Library/Frameworks/Ruby.framework/Versions/Current/usr/bin/ruby extconf.rb
""      $ make
""
"" Bundle: git://git.wincent.com/command-t.git
"" Bundle-Command: rake make
" Static:  command-t


" --------(DISABLED in GUI mode)-------
"Bundle: https://github.com/vim-scripts/buftabs.git


" ----------NOT SURE-------------------
"Bundle: https://github.com/ervandew/supertab.git
"Bundle: https://github.com/vim-scripts/SearchComplete.git
"Bundle: https://github.com/vim-scripts/ShowMarks.git
"Bundle: http://github.com/pangloss/vim-javascript.git 

" ------(NICE BUT PROBLEMATIC)---------

""Bundle: https://github.com/Raimondi/delimitMate.git
""Bundle: https://github.com/int3/vim-extradite.git           "extends fugitive

" ----------(NOT NEEDED)---------------
"" --------AUTOALIGN SUITE-------------
""Bundle: https://github.com/vim-scripts/Align.git
""Bundle: https://github.com/vim-scripts/AutoAlign.git



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                               GENERAL SETTINGS
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
set tabstop=2     " a tab is four spaces
set backspace=indent,eol,start
                  " allow backspacing over everything in insert mode
                  " (needed on some linux systems -
                  "  cf. http://vim.wikia.com/wiki/Backspace_and_delete_problems)
set autoindent    " always set autoindenting on
set copyindent    " copy the previous indentation on autoindenting
set number        " always show line numbers
set shiftwidth=2  " number of spaces to use for autoindenting
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
set shortmess=t          " short messages in status line (filepath)

" no backups please, use git
set nobackup
set noswapfile





"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                               COLORING
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



" ----------------MISC-----------------

set cursorline


" -----------TAB Detection-------------
"
" mark non-indent tabs, except on commented lines
match errorMsg /[^"\t]\zs\t\+/



" ----------Long-Lines-Suck------------
"
" discrete marking of long lines (> 80)
" (http://stackoverflow.com/questions/235439/vim-80-column-layout-concerns#answer-235970)
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/
" NB : warning : for some reason, put this BEFORE the 'set list' command
" otherwise it won't work




"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                              INDENTATION
"------------------------------------------------------------------------------


" filetype detection, plugin and indent : ON
filetype plugin indent on


set expandtab " tabs suck, no tabs, except for nazis like python


" actually show tabs for specific files
if has('autocmd')
  " make and python use real tabs
  autocmd FileType make        set noexpandtab
  autocmd FileType python      set noexpandtab
endif

"--------non-printable-characters------
"
" help: h listchars

set list
"set nolist

"set listchars=trail:.,extends:#,nbsp:.
set listchars=tab:\ \ ,extends:#,trail:⋅,nbsp:⋅

" show tabs more strongly for specific files
if has('autocmd')
  autocmd filetype py set list
  autocmd filetype py set listchars=tab:▷⋅,trail:.,extends:#,nbsp:.
endif


"----------trailing-whitespaces--------

" highlight trailing whitespaces so they are easier to spot
match Todo /\s\+$/


" delete all trailing whitespaces
" * carefull with MarkDown or any file which
"   have meaningful trailing whitespaces
" * carefull with commits so as not to scramble diffs : do this
"   only once in a while
:map <S-F7> :%s/\s\+$//g<CR>



" -----------Pase-in-insert-mode-------
" disable AUTOindenting when doing big pastes
set pastetoggle=<F10>






"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                               STATUS LINE
"------------------------------------------------------------------------------

source $HOME/.vim/lib/statusbar.vim
"au FocusLost * source $HOME/.vim/lib/statusbar.vim







"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                           PLUGIN SPECIFIC CONFIGS
"------------------------------------------------------------------------------
let g:showmarks_enable=0       "ShowMarks - disable by default
let g:Tlist_Use_SingleClick=1  "TagList   - single click to 'goto' tag

"Command-T configuration
let g:CommandTMaxHeight=20








""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                           --MAPING--
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
"                           GENERAL
"------------------------------------------------------------------------------

" Use Q for formatting the current paragraph (or selection)
vmap Q gq
nmap Q gqap


" space to maximize current window
"nmap <space>    <C-W>_

" automatically maximize active window
set winminheight=0     "minimized window only shows title"
set winheight=999


" -----------NAVIGATION----------------
" use CTRL hjkl to navigate in different modes

" NORMAL : Window navigation
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

map <up> <C-w>k
map <down> <C-w>j
map <left> <C-w>h
map <right> <C-w>l


" COMMAND : jk navigate history - hl move cursor
cmap <C-h> <left>
cmap <C-j> <down>
cmap <C-k> <up>
cmap <C-l> <right>


" INSERT : move cursor
imap <C-h> <left>
imap <C-j> <down>
imap <C-k> <up>
imap <C-l> <right>


"" learn the bloody keys, don't use arrows
"map <up> <nop>
"map <down> <nop>
"map <left> <nop>
"map <right> <nop>


" QUICKFIX list navigation (helpgrep,...)
":nnoremap <S-F1>  :cc<CR>
":nnoremap <S-Left>    :cnext<CR>
":nnoremap <S-Right>  :cprev<CR>
":nnoremap <F3>    :cnfile<CR>
":nnoremap <S-F3>  :cpfile<CR>
":nnoremap <F4>    :cfirst<CR>
":nnoremap <S-F4>  :clast<CR>



" ---------ESC is too far away---------
" and capslock is better used for CTRL
"
" GOTCHAS:
"     1) remap to <C-c> instead of <ESC> in map! modes (insert, command) to avoid the
"        'E492: Not an editor command:foo'   error
"     see ":h c_<Esc>"
"     see http://www.mail-archive.com/vim_mac@googlegroups.com/msg00858.html
"
"    2) on *NIX (linux, macosX,...) in terminal, remap to <Nul> instead of <C-Space>
"

" map CTRL+SPACE to ESC in ALL modes
" (normal, visual, select, operator pending)
if has('unix') && !has('gui_running')
  imap <Nul> <Esc>
  vmap <Nul> <Esc>
  nmap <Nul> <Esc>
  cnoremap <Nul> <C-c>  "hacky, right ?
else
  imap <C-space> <Esc>
  vmap <C-space> <Esc>
  nmap <C-Space> <ESC>
  cmap <C-Space> <C-c>
endif

" remap jj to ESC in modes that don't use the 'j' key for navigation
" (insert, command, operator-pending)
imap jj <C-c>
cmap jj <C-c>





" Easy clear search : ,/
nmap <silent> <leader>/ :nohlsearch<CR>
nmap <silent> <leader>: :nohlsearch<CR>  " french keyboard : ,, easier than ,/


" Forgot to sudo : save with w!!
cmap w!! w !sudo tee % >/dev/null

" hide buffer/ close split
nmap <leader>x   :clo<CR>
nmap <leader>X   :bd<CR>


" map control-backspace to delete the previous word in edit mode
imap <C-BS> <C-W>


" DIRECT ACCESS to usefull keys on AZERTY keyboards
" in NORMAL and VISUAL mode
nmap è  [
nmap ç  ]
nmap §  {
nmap à  }

vmap è  [
vmap ç  ]
vmap §  {
vmap à  }

nmap ù  %
vmap ù  %

"nnoremap ù  %
"vnoremap ù  %

"------------help-buffer--------------

" these are i$ VIMHOME/ftplugin/help.vim
" (mappings specific to help buffer for easy navigation)

" --------PERL-(mapping : ,h)----------
function! PerlDoc()
  normal yy
  let l:this = @
  if match(l:this, '^ *\(use\|require\) ') >= 0
    exe ':new'
    exe ':resize'
    let l:this = substitute(l:this, '^ *\(use\|require\) *', "", "")
    let l:this = substitute(l:this, ";.*", "", "")
    let l:this = substitute(l:this, " .*", "", "")
    exe ':0r!perldoc -t ' . l:this
    exe ':0'
    return
  endif
  normal yiw
  exe ':new'
  exe ':resize'
  exe ':0r!perldoc -t -f ' . @
  exe ':0'
endfunction

if has('autocmd')
  "Display PERL docs for built-in functions when cursor is on function name
  "or for modules when cursor is on 'use' or 'require' line.
  autocmd filetype perl map ,h :call PerlDoc()<CR>:set nomod<CR>:set filetype=man<CR>:echo "perldoc"<CR>
endif





"------------------------------------------------------------------------------
"                           PLUGINS
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


"--------------YankRing----------------
nmap <leader>y :YRShow<CR>
nmap <leader>Y :YRToggle<CR>
" last one : yankring conflicts with lustyjuggler and possibly delimmate
" (https://github.com/sjbach/lusty/issues/16)
" to resolve the issue, issue <leader>Y two times to let
" dd & such work again


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                       MACVIM SPECIFIC STUFF
"                   (that you wouldn't put in gvimrc)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has("gui_macvim")
  " set macvim specific stuff
endif





"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                       USERS' LOCAL CONFIG
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""



" Include user's local vim config
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                               MEMO
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                               PLUGINS
"------------------------------------------------------------------------------
"       BUFFER NAVIGATION
"
" LustyBuffers : ,lj   -> asdfg... or -> 12345...
" Bufexplorer  : ,be
" TagList      : ,T
" command-T    : ,t
" GundoToggle  : ,u
" ShowMarks    : ,mt  -> toggle ShowMarks
"
"       MACOS KeyRemap4Macbook
"
" EJECT     -> forward delete
" CAPS LOCK -> ESC
"
"
"------------------------------------------------------------------------------
"                               MISC
"------------------------------------------------------------------------------
"
"       VIM DIFF MODE
"
" do : diff obtain --> Modify the current buffer to undo difference with another buffer
" dp : diff put    --> Modify another buffer to undo differences with th ecurrent buffer
