"                               web resources
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" http://objectmix.com/editors/394885-how-do-you-parameterize-your-vimrc-different-machines.html
" https://github.com/bronson/vim-update-bundles
" LustyJuggler  screencast:     http://lococast.net/archives/185
" Command-T     screencast:     https://wincent.com/products/command-t
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""




"##############################################################################
"                               PATHOGEN
"##############################################################################



" This must be first, because it changes other options as side effect
set nocompatible

"" Needed on some linux distros for proper pathogen loading
"" see http://www.adamlowe.me/2009/12/vim-destroys-all-other-rails-editors.html
filetype off


" ----- Load/Unload plugins RULES -----{{{1

" CUSTOM logic
" To disable a plugin, add it's bundle name to the following list
"let g:pathogen_disabled = ['command-t']
let g:pathogen_disabled = ['']
"let g:pathogen_disabled = ['Decho', 'svndiff', 'ManPageView', 'vim-blcose', 'SearchComplete', 'supertab', 'vim-fugitive', 'ShowTabs', 'vim-colors-solarized' ]


if !has('gui_running')
  call add(g:pathogen_disabled, 'css-color')
  " for some reason the csscolor plugin is very slow when run on the terminal
  " but not in GVim, so disable it if no GUI is running
endif


if has('gui_running')
  call add(g:pathogen_disabled, 'buftabs')
  " we don't want tabs in statusbar when using GUI
endif


if !has('gui') || &t_Co < 256
  call add(g:pathogen_disabled, 'csapprox')
  "csapprox need Vim compiled with gui support to work
endif


if  !has('ruby')
  call add(g:pathogen_disabled, 'LustyJuggler')
  call add(g:pathogen_disabled, 'command-t')
  " All those need ruby support
endif


if  !has('python')
  call add(g:pathogen_disabled, 'simplenote.vim')
  " All those need python support
endif


if v:version < '703' || !has('python')
  call add(g:pathogen_disabled, 'Gundo')
  " Gundo requires at least Vim 7.3
endif


if v:version < '702'
  call add(g:pathogen_disabled, 'autocomplpop')
  call add(g:pathogen_disabled, 'fuzzyfinder')
  call add(g:pathogen_disabled, 'l9')
endif

if !has("signs")
  call add(g:pathogen_disabled, 'ShowMarks')
  call add(g:pathogen_disabled, 'svndiff')
endif


" It is essential that these lines are called before enabling filetype detection
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()






"1}}}
"-----------Pathogen-BUNDLES-----------{{{1
"
"Static: tartify
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
"Bundle: https://github.com/tpope/vim-surround.git
"Bundle: https://github.com/vim-scripts/repeat.vim.git
"Bundle: https://github.com/skammer/vim-css-color.git
"Bundle: http://github.com/pangloss/vim-javascript.git
"Bundle: https://github.com/vim-scripts/Conque-Shell.git
"Bundle: https://github.com/vim-scripts/YankRing.vim.git
"Bundle: https://github.com/vim-scripts/session.vim--Odding.git
"Bundle: https://github.com/altercation/vim-colors-solarized.git
"Bundle: https://github.com/cespare/vim-bclose.git
"Bundle: https://github.com/vim-scripts/ManPageView.git
"Bundle: https://github.com/vim-scripts/Decho.git
"Bundle: https://github.com/peterhost/svndiff.git
" Make this one static untill pull request is resolved
" https://github.com/vim-scripts/PreciseJump/pull/1
"Static: PreciseJump
""Bundle: https://github.com/vim-scripts/PreciseJump.git
"
" ..........MARKDOWN PREVIEW...........
" Best is markdown-preview, now called hammer. Only, I can't get hammer to
" work, so in the meantim, let's just go with markdown-preview (cloned repo,
" the original one does not exist anymore)
""Bundle: https://github.com/robgleeson/hammer.vim.git
"Bundle: https://github.com/peterhost/vim-markdown-preview.git
" This one works too, but has pbs with utf8
""Bundle: https://github.com/greyblake/vim-preview.git


" ..........TAGLIST.PLUS................
"  for JS goodness, you also need node.js & jsdoctor
"  installed on your system (jsdoctor = jsctags)
""Bundle: https://github.com/vim-scripts/taglist.vim.git
"Bundle: https://github.com/int3/vim-taglist-plus.git


" ..........SNIPMATE...................
"Bundle: https://github.com/vim-scripts/snipMate.git
""" Replacement snippets for snipmate
"" Bundle: https://github.com/scrooloose/snipmate-snippets.git
"" Bundle-Command: rake deploy_local

" ..........COMMAND.T..................
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
" this is the latest supertab (supertab-continued on vim-script)
"Bundle: https://github.com/ervandew/supertab.git
"
"Bundle: https://github.com/vim-scripts/SearchComplete.git
"Bundle: https://github.com/vim-scripts/ShowMarks.git
""Bundle: https://github.com/vim-scripts/AutoComplPop.git
"Bundle: https://github.com/vim-scripts/L9.git
"Bundle: https://github.com/vim-scripts/FuzzyFinder.git


" ----------MANUAL-INSTALL-------------


" --------HAVE TO TRY IT SOON!!--------
"" Comprehnsive auto-completion system (does ALL)
"Bundle: https://github.com/Shougo/neocomplcache.git

" --------CANT-GET-IT-TO-WORK----------
"
""Bundle: https://github.com/mrtazz/simplenote.vim.git


" ------(NICE BUT PROBLEMATIC)---------

""Bundle: https://github.com/Raimondi/delimitMate.git
""Bundle: https://github.com/int3/vim-extradite.git           "extends fugitive

" ----------(NOT NEEDED)---------------
"
"" ........AUTOALIGN SUITE.............
""Bundle: https://github.com/vim-scripts/Align.git
""Bundle: https://github.com/vim-scripts/AutoAlign.git

"1}}}






"##############################################################################
"                             GENERAL SETTINGS
"##############################################################################


"{{{1

" UTF8 by default
set encoding=utf-8

"---------------------------------------------------------
" FROM : http://nvie.com/posts/how-i-boosted-my-vim/

" change the mapleader from \ to ,
let mapleader=","


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

set showcmd             " show abbrev command in command line as you type them

" no backups please, use git
set nobackup
set noswapfile

" See more context when scrolling
:set scrolloff=6

" Show position in lower right
":set ruler

" Better centered pipe symbol for window separation in Term & CTerm Vim
set fillchars=vert:⏐


" Awesome TAB completion for Command Mode
"  ex :colorscheme TAB    to scroll through colorschemes
"      map TAB            to scroll through mappings
"      ...
set wildmode=full
set wildmenu



"1}}}


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                               VIEW/SESSION
"------------------------------------------------------------------------------

" --------SessionOptions---------------{{{1

set sessionoptions=blank,buffers,curdir,folds,help,options,tabpages,winsize


"1}}}
" --------View dir, options,cursor pos-{{{1


" Remember last location in file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif

" DIR to store views
set viewdir=$HOME/.vim/views

if has ("autocmd")

  "automatically save a view/load it when switching buffers
  "autocmd BufWinLeave * silent! mkview
  "autocmd BufWinEnter * silent! loadview


  ""This session stuff conflicts with plugins --> disabled
  ""Automatically save a session when exiting VIM
  "autocmd VimLeavePre * silent mksession!
endif

"" if there's a session in the working dir, load it
"silent! source Session.vim



"1}}}


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                               FOLDING
"------------------------------------------------------------------------------

" --------General----------------------{{{1

set foldenable
set foldmethod=syntax

"1}}}
" --------VIM,VIMRC-------------------{{{1
if has("autocmd")
  autocmd FileType vim        setlocal foldmethod=marker
  autocmd BufRead *.vim       setlocal foldmethod=marker
endif

"au BufReadPre * setlocal foldmethod=indent
"au BufWinEnter * if &fdm == 'indent' | setlocal foldmethod=manual | endif

let g:vimsyn_folding="afmpPrt"


"1}}}
" --------BASH, SH,...-----------------{{{1

"default shell to bash
let g:is_bash=1
" fold everything please
"The syntax/sh.vim file provides several levels of syntax-based folding:
" (octal notation)
"let g:sh_fold_enabled= 0     (default, no syntax folding)
"let g:sh_fold_enabled= 1     (enable function folding)
"let g:sh_fold_enabled= 2     (enable heredoc folding)
"let g:sh_fold_enabled= 4     (enable if/do/for folding)

let g:sh_fold_enabled=7
"1}}}


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                               SPELLCHECK
"------------------------------------------------------------------------------
"
set nospell

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                              INDENTATION
"------------------------------------------------------------------------------

" --------Expantab---------------------{{{1
" filetype detection, plugin and indent : ON
filetype plugin indent on


set expandtab "soft tabs, except for languages where it makes sense (python)


" actually show tabs for specific files
if has('autocmd')
  " make and python use real tabs
  autocmd FileType make        set noexpandtab
  autocmd FileType python      set noexpandtab
endif

"1}}}
"--------non-printable-characters------{{{1
"
" help: h listchars

set list
"set nolist

"set listchars=trail:.,extends:#,nbsp:.
set listchars=tab:\ \ ,extends:#,trail:⋅,nbsp:⋅

" show tabs more strongly for specific files
if has('autocmd')
  autocmd filetype py set list
  "␣␣
  autocmd filetype py set listchars=tab:▷⋅,trail:.,extends:#,nbsp:.
endif

"1}}}
"--------WhitespaceWipers--------------{{{1



" delete all trailing whitespaces
" * carefull with MarkDown or any file which
"   have meaningful trailing whitespaces
" * carefull with commits so as not to scramble diffs : do this
"   only once in a while
function! s:enableWhitespaceWipers()
  " in WHOLE FILE
  map <silent> <S-F7>                 :%s/\s\+$//g<CR>
  " on CURRENT LINE
  nnoremap <silent> <leader><space>   :s/\s\+$//g<CR>
  vnoremap <silent> <leader><space>   :s/\s\+$//g<CR>
endfunction

" remove mappings wich suppress whitespace
" (used later on for Markdown and Txt files)
function! s:removeWhitespaceWipers()
  " in WHOLE FILE
  silent! map <S-F7>   :echo "disabled for markdown"<CR>
  " on CURRENT LINE
  silent! nnoremap <leader><space>   :echo "disabled for markdown"<CR>
  silent! vnoremap <leader><space>   :echo "disabled for markdown"<CR>
endfunction


call s:enableWhitespaceWipers()

"1}}}
" --------Pase-in-insert-mode----------{{{1
" disable AUTOindenting when doing big pastes
set pastetoggle=<F10>


"1}}}



"##############################################################################
"                               COLORING
"##############################################################################
"
" GOTCHA : carefull to always declare User defined Colorscheme Groups such as
" those you would use in a statusline (named "User1" to "User9" and called by
" "set statusline+=%1*"), or others AFTER all the :colorscheme directives
" present in your .vimrc
"
"------------------------------------------------------------------------------

"
" ~~~~~~~~~~~~~~~~~~PRE~ColorScheming~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" --------Custom Color Groups----------{{{1
" http://vim.wikia.com/wiki/Highlight_unwanted_spaces

" be aware that future colorscheme commands may clear all user-defined
" highlight groups. Using,the following autocmds, before the first colorscheme
" command will ensure that the highlight group gets created and is not cleared
" by future colorscheme commands. Other option is to use an "autocmd" on
" "ColorScheme" :help :colorscheme


" --------|__Trailing Whitespace-------{{{2


if has("autocmd")
  :autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
endif

highlight ExtraWhitespace ctermbg=red guibg=red


"2}}}
" --------|__Long Lines (>80)----------{{{2


" discrete marking of long lines (> 80)
" (http://stackoverflow.com/questions/235439/vim-80-column-layout-concerns#answer-235970)
" and make that compatible with colorschemes which have background (light,
" dark) setup

function! s:setupLongLines()
  if &background == "light"
    highlight OverLength ctermbg=red ctermfg=white guibg=#efe9d6
  else
    highlight OverLength ctermbg=red ctermfg=white guibg=#592929
  endif
endfunction


if has("autocmd")
  "au ColorScheme match OverLength /\%81v.\+/
  autocmd ColorScheme * call s:setupLongLines()
endif

call s:setupLongLines()




" NB : warning : for some reason, put this AFTER the 'set list' command
" otherwise it won't work
" match OverLength /\%81v.\+/


"2}}}
" --------|__TABS----------------------{{{2


" discrete marking of TABS when they are not used ONLY for indenting
" and make that compatible with colorschemes which have background (light,
" dark) setup

function! s:setupInappropriateTabs()
  if &background == "light"
    highlight InappropriateTabs ctermbg=darkred ctermfg=white guibg=#e1d9bf
  else
    highlight InappropriateTabs ctermbg=darkred ctermfg=white guibg=#431616
  endif
endfunction


if has("autocmd")
  "au ColorScheme match OverLength /\%81v.\+/
  autocmd ColorScheme * call s:setupInappropriateTabs()
endif

call s:setupInappropriateTabs()




" NB : warning : for some reason, put this AFTER the 'set list' command
" otherwise it won't work
" match OverLength /\%81v.\+/


"2}}}


"1}}}
" --------Match, 2match, 3match--------{{{1

" Any ":match highlighting" applies only to the "current window". With the
" following in your vimrc, the command will be applied to the first window,
" and to any subsequent windows. The pattern * applies the highlight to all
" files.
" NB "only 3 matches" can be used (match, 2match, 3match)
"
" --------|__Trailing Whitespace-------{{{2

  "" Show leading whitespace that includes spaces, and trailing whitespace.
  "autocmd BufWinEnter * match ExtraWhitespace /^\s* \s*\|\s\+$/

  " highlight trailing whitespaces so they are easier to spot
if has("autocmd")
  autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
  autocmd InsertLeave * match ExtraWhitespace /\s\+$/
  autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
endif


match ExtraWhitespace /\s\+\%#\@<!$/
match ExtraWhitespace /\s\+$/
match ExtraWhitespace /\s\+$/


"2}}}
" --------|__Long Lines (>80)----------{{{2


if has("autocmd")
  autocmd BufwinEnter * 2match OverLength /\%81v.\+/
endif

2match OverLength /\%81v.\+/



"2}}}
" --------|__TAB Detection-------------{{{2
"
" mark non-indent tabs, except on commented lines where we can do WTF we want

if has("autocmd")
  autocmd BufwinEnter * 3match InappropriateTabs /[^"\t]\zs\t\+/
  autocmd BufwinEnter *.txt 3match none
endif

3match InappropriateTabs /[^"\t]\zs\t\+/


"2}}}
"1}}}
" --------ClearMatches on BufWinLeave--{{{1
"
"
" It seems that vim does not handle sucessive calls of the match command
" gracefully. Since BufWinEnter commands are executed every time a buffer is
" displayed (i.e., switching to another file), the match command is executed
" many times during a vim session. This seems to lead to a memory leak which
" slowly impacts performance (for example scrolling and writing become
" unbearable slow). Include the following line to fix the issue:
autocmd BufWinLeave * call clearmatches()



"1}}}

" ------Color Scheme-------------------{{{1

if &t_Co >= 256 || has("gui_running")

  "colorscheme mustang

  colorscheme solarized
  call togglebg#map("<F5>")       " F5 toggle background

endif



"1}}}


" ~~~~~~~~~~~~~~~~~~POST~ColorScheming~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" --------Additional Syntax (JSON)-----{{{1
" JSON : js syntax suffices
autocmd BufNewFile,BufRead *.json set ft=javascript


"1}}}
" --------CursorLine-------------------{{{1
if has("gui_running") && has("autocmd")

  "only highlight line in GUI mode (in terminal, it's distracting)
  autocmd WinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline

else
  set nocursorline
endif
"1}}}
" --------Syntax Highlightning---------{{{1
" switch syntax highlighting on, when the terminal has colors
" this has to happen AFTER the "set background" commands
if &t_Co > 2 || has("gui_running")
  ""this one resets all current color settings ('highlight' " command)
  syntax on

  "doesn't reset user defined highlights
  "syntax enable
endif


"1}}}



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                               STATUS LINE
"------------------------------------------------------------------------------

" --------(DEPREC)Source the StatusLine Script-{{{1


"if has("statusline") && has("autocmd")
"  autocmd Colorscheme * source $HOME/.vim/lib/statusbar.vim
"  "source $HOME/.vim/lib/statusbar.vim
"  "au FocusLost * source $HOME/.vim/lib/statusbar.vim
"endif


"source $HOME/.vim/lib/statusbar.vim


"1}}}



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                           PLUGIN SPECIFIC CONFIGS
"------------------------------------------------------------------------------

" --------ShowMarks--------------------{{{1
let g:showmarks_enable=0       "ShowMarks - disable by default
let g:Tlist_Use_SingleClick=1  "TagList   - single click to 'goto' tag

"1}}}
" --------Command-T--------------------{{{1
"Command-T configuration
let g:CommandTMaxHeight=20



"1}}}
" --------Syntastic--------------------{{{1

"Use this option to tell syntastic to use the |:sign| interface to mark syntax
"errors:
    let g:syntastic_enable_signs=1

"Enable this option if you want the cursor to jump to the first detected error
"when saving or opening a file:
    let g:syntastic_auto_jump=1

"Use this option to tell syntastic to automatically open and/or close the
"|location-list| (see |syntastic-error-window|).

"When set to 1 the error window will be automatically opened when errors are
"detected, and closed when none are detected. >
    let g:syntastic_auto_loc_list=1

"When set to 2 the error window will be automatically closed when no errors
"are detected, but not opened automatically.
    let g:syntastic_auto_loc_list=2



"1}}}
" --------Tartify --------------------{{{1


let g:tartify_auto_enable = 1
map <silent> <leader>st    :call g:tartify_statusline_toggle()<CR>

let g:tartify_adaptativeHighlights.light.9.hue = "red"

let g:tartify_disabled = ['git', 'longlines', 'path', ]
"call g:tartify_update_colors()

"set statusline=%<%f%h%m%r%=%b\ 0x%B\ \ %l,%c%V\ %#warningmsg#%P

"1}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                           FILES SPECIFIC CONFIGS
"------------------------------------------------------------------------------

"--------Markdow and Txt files---------{{{1
"
" from https://github.com/isaacs/.vim/blob/master/vimrc

function! s:setupWrapping()
  set wrap
  set wm=2
  set textwidth=72
  if has ("gui_running")
    set spell
    set spelllang=en
  endif
endfunction

function! s:setupMarkup()
  call s:setupWrapping()
  nmap <buffer> <Leader>p :Mm <CR>
  imap <buffer> <C-p> :Mm <CR>
endfunction


if has("autocmd")
  " md, markdown, and mk are markdown and define buffer-local preview
  au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn} call s:setupMarkup()
  au BufRead,BufNewFile *.txt call s:setupWrapping()

  " unset/re-set "whitespace removing mappings" when entering/leaving MD buffer
  au BufEnter *.{md,markdown,mdown,mkd,mkdn} call s:removeWhitespaceWipers()
  au BufLeave *.{md,markdown,mdown,mkd,mkdn} call s:enableWhitespaceWipers()
endif

"1}}}



"##############################################################################
"                           --MAPING--
"##############################################################################
"------------------------------------------------------------------------------
"                           GENERAL
"------------------------------------------------------------------------------

" --------autoMAX window (DISABLED)----{{{1
"" automatically maximize active window
"set winminheight=0     "minimized window only shows title"

"set winheight=999     "hack to avoid <C-W>_

"1}}}
" --------MISC-------------------------{{{1
" Use Q for formatting the current paragraph (or selection)
vmap Q gq
nmap Q gqap


" Quick window-size changers
nmap <S-space>      <C-W>_      " space to maximize current window
nmap <C-S-space>    <C-W>16_    " ctrl+shift+space to set current window to 16 lines


" ALT+space to quickly switch colorschemes
"requires set wildmode=full   and set wildmenu
nmap <A-space> :colorscheme<space>

" Forgot to sudo : save with w!!
cmap w!! w !sudo tee % >/dev/null


" Buffer/Window closing
"
" Close buffer without closing window (using plugin function Kwbd)
" (http://vim.wikia.com/wiki/VimTip165)
nmap <Leader>x      :Kwbd<CR>
" Close buffer & window
nmap <leader>X      :bd<CR>
" Close window
nmap <leader><s-x>   :clo<CR>
"1}}}
" --------WINDOW RESIZING--------------{{{1

"Vertical resizing to ,< AND ,>, and faster
" (shorter than C-w C-<, C-w C->)
:nnoremap ,< <C-W><<C-W><<C-W><<C-W><
:nnoremap ,> <C-W>><C-W>><C-W>><C-W>>



"1}}}
" --------NAVIGATION-------------------{{{1
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



"nmap <C-left> <C-w>h<C-W>_
"nmap <C-down> <C-w>j<C-W>_
"nmap <C-up> <C-w>k<C-W>_
"nmap <C-right> <C-w>l<C-W>_

"map <up> <C-w>k<C-W>_
"map <down> <C-w>j<C-W>_
"map <left> <C-w>h<C-W>_
"map <right> <C-w>l<C-W>_


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
:nnoremap <leader><Left>    :cprev<CR>
:nnoremap <leader><Right>   :cnext<CR>
:nnoremap <leader><Up>      :cpfile<CR>
:nnoremap <leader><Down>    :cnfile<CR>
":nnoremap <leader><S-Up>    :cfirst<CR>
":nnoremap <leader><S-Down>  :clast<CR>



"" this IS REALLY questionnable :
"" Replicate textmate shift arrow/movement in order to select stuff
"nmap <S-up> vk
"vmap <S-up> k
"nmap <S-k> vk
"vmap <S-k> k

"nmap <S-right> vl
"vmap <S-right> l
"nmap <S-l> vl
"vmap <S-l> l

"nmap <S-down> vj
"vmap <S-down> j
"nmap <S-j> vj
"vmap <S-j> j

"nmap <S-left> v
"vmap <S-left> h
"nmap <S-h> vh
"vmap <S-h> h



"1}}}
" --------ESC is too far away----------{{{1
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

" remap fj to ESC in modes that don't use the 'j' key for navigation
" (insert, command, operator-pending)
imap fj <C-c>
cmap fj <C-c>
vmap fj <C-c>

"1}}}
"--------SEARCH------------------------{{{1

" Easy clear search : ,/
nmap <silent> <leader>/ :nohlsearch<CR>
" french keyboard : ,; easier than ,/
nmap <silent> <leader>; :nohlsearch<CR>


" map control-backspace to delete the previous word in edit mode
imap <C-BS> <C-W>

"1}}}
"--------AZERTY-TO-QWERTY--------------{{{1
"
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

nmap ; .
omap ; .
"1}}}
"--------help-buffer------------------{{{1

" these are i$ VIMHOME/ftplugin/help.vim
" (mappings specific to help buffer for easy navigation)

nmap <leader>h        :help <C-R>=expand("<cword>")<CR><CR>
nmap <leader>H        :helpg  <C-R>=expand("<cword>")<CR><CR>


"1}}}
" --------PERL-(mapping : ,h)----------{{{1
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
  autocmd filetype perl map <leader>h :call PerlDoc()<CR>:set nomod<CR>:set filetype=man<CR>:echo "perldoc"<CR>
endif



"1}}}
" --------SOURCE/EDIT vimrc,bashrc-----{{{1
" open real file instead of symlink
function! UnSymLinkEdit(path)
  let l:filetoedit = system( "ttmp=" . shellescape(a:path) . "; [ -L $ttmp ] && echo $(readlink $ttmp) || echo $ttmp" )
  execute "edit " . l:filetoedit
endfunction



" Edit vimrc
nmap <silent> <leader>ev :call UnSymLinkEdit($MYVIMRC)<CR>
"nmap <silent> <leader>ev :e $MYVIMRC<CR>
" Quickly edit/reload the vimrc file
" (mapc & mapc! to clear all mappings before reloading)
nmap <silent> <leader>sv :mapc<CR>:mapc!<CR>:so $MYVIMRC<CR>
" Quickly edit/reload the bashrc file
nmap <silent> <leader>eb :call UnSymLinkEdit($HOME . "/.bashrc")<CR>
" Same for the statusLine
nmap <silent> <leader>es :e $HOME/.vim/bundle/tartify/plugin/tartify.vim<CR>
nmap <silent> <leader>ss :so $HOME/.vim/bundle/tartify/plugin/tartify.vim<CR>



" display all Highlight Groups in a separate window
nmap <silent> <leader>sc  :so $VIMRUNTIME/syntax/hitest.vim<CR>


"1}}}
" --------INDENT in visual mode--------{{{1
" https://github.com/mikewest/homedir/blob/master/.vimrc
" Indent in visual mode remains in visual mode: allows multiple indents
    vnoremap <silent> > >gv
    vnoremap <silent> < <gv


"1}}}
" --------SEARCH in visual mode-------{{{1
" Really useful!
"  In visual mode when you press * or # to search for the current selection
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>


"TODO : inquire how this works, lol
" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSearch('gv')<CR>
map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>


function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

" From an idea by Michael Naumann
function! VisualSearch(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction


"1}}}
" --------Folding----------------------{{{1


"space to toggle FOLD
nnoremap <space>  za
"
"BACKSPACE to FULL toggle fold
nnoremap <BS>     zA
"
"SHIFT+BACKSPACE to expand ALL folds 1 level
nnoremap <S-BS>   zr
"
"CMD+BACKSPACE to contract ALL folds 1 level
nnoremap <C-BS>   zm

"CMD+SHIFT+BACKSPACE to toggle ALL folds
nnoremap <S-C-BS>   zi



"1}}}

"------------------------------------------------------------------------------
"                           PLUGINS
"------------------------------------------------------------------------------

"---------Gundo------------------------{{{1
if ! v:version < '703' || !has('python')
  nnoremap <leader>u :GundoToggle<CR>
endif
"1}}}
"---------LustyJugler------------------{{{1
" ,l (shorter than default ,lj )
" unmap first to remove the 1 second delay
if hasmapto(":LustyJuggler")
  silent! nunmap <leader>lj
endif
nmap <leader>l   :LustyJuggler<CR>

"1}}}
"---------TagList----------------------{{{1
" taglist to ,T
nmap <leader>T   :TlistToggle<CR>


"---------NERDTree--------------------{{{1
map <leader><C-t> :execute 'NERDTreeToggle ' . getcwd()<CR>

"1}}}
"---------FuGITive---------------------{{{1
" GIT (fugitive)
"
""  20_ --> give status window height
"nmap <leader>gs  :Gstatus<CR><C-w>20_
nmap <leader>gs  :Gstatus<CR>

nmap <leader>gc  :Gcommit<CR>
nmap <leader>gg  :Ggrep
nmap <leader>ga  :Gwrite<CR>
nmap <leader>gl  :Glog
nmap <leader>gdc :Gdiff --cached<CR>
nmap <leader>gdh :Gdiff HEAD<CR>
nmap <leader>gdo :Gdiff ORIG_HEAD<CR>
nmap <leader>gb  :Gbrowse<CR>

"1}}}
"---------YankRing---------------------{{{1
nmap <leader>y :YRShow<CR>
nmap <leader>Y :YRToggle<CR>
" last one : yankring conflicts with lustyjuggler and possibly delimmate
" (https://github.com/sjbach/lusty/issues/16)
" to resolve the issue, issue <leader>Y two times to let
" dd & such work again

"1}}}
"---------FuzzyFinder------------------{{{1

 :nmap <leader>fb     :FufBuffer<CR>
 :nmap <leader>ff     :FufFile<CR>
":nmap <leader>fco    :FufCoverageFile<CR>
 :nmap <leader>fd     :FufDir<CR>
":nmap <leader>fmf    :FufMruFile<CR>
":nmap <leader>fcc    :FufMruCmd<CR>
":nmap <leader>fbf    :FufBookmarkFile<CR>
":nmap <leader>fbd    :FufBookmarkDir<CR>
 :nmap <leader>ft     :FufTag<CR>
":nmap <leader>ftb    :FufBufferTag<CR>
":nmap <leader>fft    :FufTaggedFile<CR>
 :nmap <leader>fj     :FufJumpList<CR>
 :nmap <leader>fc     :FufChangeList<CR>
":nmap <leader>fq     :FufQuickfix<CR>
":nmap <leader>fl     :FufLine<CR>
 :nmap <leader>fh     :FufHelp<CR>

let g:fuf_keyOpenSplit = '<C-j>'
let g:fuf_keyOpenVsplit = '<C-k>'
let g:fuf_keyOpenTabpage = '<C-l>'


"1}}}
"---------vim-session------------------{{{1

nmap <leader>ws       :SaveSession 

nmap <leader>wo       :OpenSession 
nmap <leader>ww       :OpenSession 
nmap <leader>wl       :OpenSession<CR>
nmap <leader>wx       :CloseSession<CR>
nmap <leader>wd       :DeleteSession 
nmap <leader>wv       :ViewSession<CR>
nmap <leader>wr       :RestartVim<CR>

let g:session_autosave=1
"let g:session_autoload=1
"1}}}
"---------ConqueTerm-------------------{{{1
"
if has("win32") || has("win64")
  nmap <leader>q      :ConqueTermTab Powershell.exe<CR>
else
  nmap <leader>q      :ConqueTermTab bash<CR>
endif
"1}}}
" ---------SvnDiff---------------------{{{1
"

nmap <leader>dd       :call Svndiff("next")<CR>
nmap <leader>dn       :call Svndiff("next")<CR>
nmap <leader>du       :call Svndiff("prev")<CR>
nmap <leader>dp       :call Svndiff("prev")<CR>
nmap <leader>dc       :call Svndiff("clear")<CR>
nmap <leader>dh       :call Svndiff("clear")<CR>
nmap <leader>ds       :call Svndiff("show")<CR>


let g:svndiff_autoupdate=1

"1}}}
" -------- Decho Debugger -------------{{{1


nmap <leader>Dh     :Dhide<CR>
nmap <leader>Ds     :Dshow<CR>
nmap <leader>Do     :DechoOn<CR>
nmap <leader>DO     :DechoOff<CR>
let g:decho_winheight=16

"  1}}}
" ---------PreciseJump-----------------{{{1
"

" set this to 1 if you want PreciseJump to overrride default "f" and "F"
" mappings
" "f" : whole file
" "F" : line
let g:PreciseJump_I_am_brave=1

"set of "target keys" better suited to an AZERTY keyboard
let g:PreciseJump_target_keys = "abcdefghijklmnopqrstuwxz123456789;',./ABCDEFGHIJKLMNOPQRSTUWXZ:\"<>?!@#$%^&*()_+é§èçàù"
"1}}}


"##############################################################################
"                       --ADDITIONAL RC files--
"##############################################################################

" --------LOCAL VIMRC(s)---------------{{{1
" Include user's local vim config
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif








"1}}}
" --------MACVIM SPECIFIC STUFF--------{{{1

if has("gui_macvim")
  " set macvim specific stuff
endif


"1}}}

"##############################################################################
"                               --MEMO--
"##############################################################################

" -------- PLUGINS---------------------{{{1
"
" --------------BUFFERS----------------
" LustyBuffers  : ,lj   -> asdfg... or -> 12345...
" Bufexplorer   : ,be
" FuzzyFinder   : open=<CR>   Hsplit=<C-j>  Vsplit=<C-k>  newTab=<C-l>
"                 ,ff=file    ,fd=dir   ,fb=bufer   ,ft=tag   ,fj=jumplist
"                 ,fc=changelist        ,fh=help
"
"
" -------------TOGGLE------------------
" TagList      : ,T
" command-T    : ,t
" NERDTree     : ,CMD+t
"
" GundoToggle  : ,u
" ShowMarks    : ,mt  -> toggle ShowMarks
"
" YankRing     : ,y
"
"
"----------SURROUND--------------------
" cs("    -> change surrounding parne to quotes
"
"
"----------SESSIONS--------------------
" ,wl  (load)   ,wS  (saveas)
" ,wL  (last)   ,wo  (open)
" ,ws  (save)   ,wx  (close)
"
"
" -------MACOS KeyRemap4Macbook--------
"
" EJECT     -> forward delete
" CAPS LOCK -> ESC
"
"1}}}
" -------- MISC------------------------{{{1
"
"       VIM DIFF MODE
"
" do : diff obtain --> Modify the current buffer to undo difference with another buffer
" dp : diff put    --> Modify another buffer to undo differences with th ecurrent buffer
"1}}}
" vim:foldmethod=marker
