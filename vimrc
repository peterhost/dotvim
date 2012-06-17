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


runtime bundle/vim-pathogen/autoload/pathogen.vim
" Bundle: tpope/vim-pathogen

" CUSTOM logic
" To disable a plugin, add it's bundle name to the following list
let g:pathogen_disabled = ['']
"let g:pathogen_disabled = ['Decho', 'svndiff', 'ManPageView', 'vim-blcose', 'SearchComplete', 'supertab', 'vim-fugitive', 'ShowTabs', 'vim-colors-solarized' ]


if !has('gui_running')
  "call add(g:pathogen_disabled, 'css-color')
  " for some reason the csscolor plugin is very slow when run on the terminal
  " but not in GVim, so disable it if no GUI is running
endif

if !has("gui_macvim")
  "the PEEPOPEN program is a Macos specific Command-T
  call add(g:pathogen_disabled, 'vim-peepopen')
end



"if !has('gui') || &t_Co < 256
"  call add(g:pathogen_disabled, 'csapprox')
"  "csapprox need Vim compiled with gui support to work
"endif


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
  call add(g:pathogen_disabled, 'FuzzyFinder')
  call add(g:pathogen_disabled, 'L9')
endif

if !has("signs")
  call add(g:pathogen_disabled, 'ShowMarks')
  call add(g:pathogen_disabled, 'svndiff')
endif


" It is essential that these lines are called before enabling filetype detection
call pathogen#infect()
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()





"1}}}
"------Pathogen-BUNDLES---------------{{{1
"
""Was : Static: tartify
""Bundle: git://github.com/peterhost/tartify.git
"Bundle: git://github.com/tpope/vim-fugitive.git
"Bundle: git://github.com/taq/vim-git-branch-info.git
"Bundle: git://github.com/wookiehangover/jshint.vim.git
""Bundle-command: rake
""Bundle: git://github.com/godlygeek/csapprox.git
"Bundle: git://github.com/slack/vim-bufexplorer.git
"Bundle: git://github.com/vim-scripts/LustyJuggler.git
"Bundle: git://github.com/scrooloose/syntastic.git
"DEPREC"Bundle: git://github.com/mhz/vim-matchit.git
"Bundle: git://github.com/tsaleh/vim-matchit.git
""Bundle: git://github.com/scrooloose/nerdcommenter.git
""WAS USED before scss & jade fixed  Bundle: git://github.com/peterhost/nerdcommenter.git
"Bundle: git://github.com/plasticboy/vim-markdown.git
"Bundle: git://github.com/tpope/vim-surround.git
"Bundle: git://github.com/tpope/vim-repeat.git
"""NO MORE UPDATED : Bundle: git://github.com/vim-scripts/YankRing.vim.git
"Bundle: git@github.com:peterhost/YankRing.vim.git
"Bundle: git://github.com/vim-scripts/session.vim--Odding.git
"Bundle: git://github.com/altercation/vim-colors-solarized.git
"Bundle: git://github.com/cespare/vim-bclose.git
"Bundle: git://github.com/vim-scripts/Decho.git
"Bundle: git://github.com/tpope/vim-unimpaired.git
"Bundle: git://github.com/tpope/vim-git.git
"(fuzzyFinder depends on L9)
"Bundle: git://github.com/vim-scripts/L9.git
"Bundle: git://github.com/vim-scripts/FuzzyFinder.git
"
" ..........SYNTAXES...................
"Bundle: git://github.com/cakebaker/scss-syntax.vim.git
"Bundle: git://github.com/digitaltoad/vim-jade.git
"Bundle: git://github.com/wavded/vim-stylus.git
"Bundle: git://github.com/othree/html5-syntax.vim.git
"Bundle: git://github.com/pangloss/vim-javascript.git
"Bundle: git://github.com/skammer/vim-css-color.git
"
" ..........PRECISEJUMP ...............
" Make this one static untill pull request is resolved
" https://github.com/vim-scripts/PreciseJump/pull/1
" was Bundle: git://github.com/vim-scripts/PreciseJump.git
" was Static: PreciseJump
" EDIT : use my fork instead
"Bundle: git@github.com:peterhost/PreciseJump.git
"
"
" ..........COMPLETION ................
"" Comprehnsive auto-completion system (does ALL)
""Bundle: git://github.com/Shougo/neocomplcache.git

""Bundle: git://github.com/vim-scripts/SearchComplete.git

" this is the latest supertab (supertab-continued on vim-script)
"Bundle: git://github.com/ervandew/supertab.git
"
"
" ..........MARKDOWN PREVIEW...........
" Best is markdown-preview, now called hammer. Only, I can't get hammer to
" work, so in the meantim, let's just go with markdown-preview (cloned repo,
" the original one does not exist anymore)
""Bundle: git://github.com/robgleeson/hammer.vim.git

"Bundle: git://github.com/peterhost/vim-markdown-preview.git

" This one works too, but has pbs with utf8
""Bundle: git://github.com/greyblake/vim-preview.git
"
"
" ..........TAGLIST.PLUS................
"  for JS goodness, you also need node.js & jsdoctor
"  installed on your system (jsdoctor = jsctags)
""Bundle: git://github.com/int3/vim-taglist-plus.git
"
"NOW USING TAGBAR
"Bundle: git://github.com/majutsushi/tagbar.git

" ----------NOT SURE-------------------
"
""Bundle: git://github.com/vim-scripts/AutoComplPop.git
""Bundle: git://github.com/vim-scripts/upAndDown.git
"Bundle: git://github.com/vim-scripts/Gist.vim.git

" ----------MANUAL-INSTALL-------------

" --------HAVE TO TRY IT SOON!!--------

" --------CANT-GET-IT-TO-WORK----------

" ------(NICE BUT PROBLEMATIC)---------

""Bundle: git://github.com/Raimondi/delimitMate.git
""Bundle: git://github.com/int3/vim-extradite.git           "extends fugitive

" ----------(NOT NEEDED)---------------
"
""Bundle: git://github.com/vim-scripts/ShowMarks.git

""Bundle: git://github.com/vim-scripts/Gundo.git
""Bundle: git://github.com/scrooloose/nerdtree
""Bundle: git://github.com/vim-scripts/Conque-Shell.git
""Bundle: git://github.com/peterhost/svndiff.git

"" ........AUTOALIGN SUITE.............
""Bundle: git://github.com/vim-scripts/Align.git
""Bundle: git://github.com/vim-scripts/AutoAlign.git

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
"set fillchars=vert:⏐


" Awesome TAB completion for Command Mode
"  ex :colorscheme TAB    to scroll through colorschemes
"      map TAB            to scroll through mappings
"      ...
set wildmode=full
set wildmenu

set formatoptions+=croql

"1}}}
" --------GUI FONT & size -------------{{{1

if has("gui")
  "
  " Default FONT
  "
  set guifont=Century\ Schoolbook\ Monospace\ BT:h14
  set guifont=set guifont=DejaVu\ Sans\ Mono:h11
  set guifont=Menlo\ Regular:h11
  nnoremap <silent> <leader>+ :silent! set guifont=Century\ Schoolbook\ Monospace\ BT:h14<CR>
  nnoremap <silent> <leader>_ :silent! set guifont=DejaVu\ Sans\ Mono:h11<CR>

  ""
  "" FONTSIZE changer
  "" from: http://vim.wikia.com/wiki/Change_font_size_quickly
  ""
  "nnoremap <silent> <S-Up> :silent! let &guifont = substitute(
  nnoremap <silent> <leader>= :silent! let &guifont = substitute(
  \ &guifont,
  \ ':h\zs\d\+',
  \ '\=eval(submatch(0)+1)',
  \ '')<CR>
  "nnoremap <silent> <S-Down> :silent! let &guifont = substitute(
  nnoremap <silent> <leader>- :silent! let &guifont = substitute(
  \ &guifont,
  \ ':h\zs\d\+',
  \ '\=eval(submatch(0)-1)',
  \ '')<CR>


endif
"1}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                               VIEW/SESSION
"------------------------------------------------------------------------------

" --------SessionOptions---------------{{{1

set sessionoptions=blank,buffers,curdir,folds,help,localoptions,tabpages,winsize
"set sessionoptions=blank,buffers,curdir,folds,help,options,tabpages,winsize
"set sessionoptions=blank,buffers,curdir,folds,help,localoptions,options,tabpages,winsize


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
  autocmd FileType html        setlocal foldmethod=marker
  autocmd BufRead *.html       setlocal foldmethod=marker
  autocmd FileType jade        setlocal foldmethod=marker
  autocmd BufRead *.jade       setlocal foldmethod=marker
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
" --------HTML-------------------------{{{1

" enable html tag folding with ,f
nnoremap <leader><C-space> Vatzf

"1}}}
" --------XML--------------------------{{{1

" enable html tag folding with ,f
let g:xml_syntax_folding=1
au FileType xml setlocal foldmethod=syntax

"1}}}
" --------Tabulation name&option-------{{{1
if version >= 700
    "set showtabline to show when more than one tab
    set showtabline=1
    "set tab labels to show at most 12 characters
    "set guitablabel=%-0.12t%M
endif

" don't show the toolbar in the GUI (only the menu)
set guioptions-=T

" don't show tear-off menus
"set guioptions-=t

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
  map <silent> <leader> <S-space>     :%s/\s\+$//g<CR>
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

" --------PHP autoindent----------------{{{1
" autoindent PHP code (included in vim 703,
" otherwise, try this module :
" https://github.com/2072/PHP-Indenting-for-VIm
"
if v:version >= '703'
  let g:PHP_autoformatcomment = 0
  let g:PHP_default_indenting = 1
  "let g:PHP_outdentphpescape = 0
endif

"1}}}
"--------JSON-autoindent-------------{{{1

" This will only work with the "yajl" package installed (MAcos brew, or linux)
" We first test for its existence
"
let __shellcmd = 'which json_reformat'
let __output=system(__shellcmd)
if !v:shell_error
  autocmd BufNewFile,BufRead *.json set equalprg=json_reformat
endif



"}}}1
"--------XML-autoindent--------------{{{1

" This will only work with the "xml-fmt" tool from  package "xml-coreutil"
" installed (MAcos brew, or linux)
" We first test for its existence
"
let __shellcmd = 'which xml-fmt'
let __output=system(__shellcmd)
if !v:shell_error
  autocmd BufNewFile,BufRead *.xml set equalprg=xml-fmt
endif



"}}}1
" --------re-indent anyfile------------{{{1
" map <F8> to reindent file
noremap <F8> mzgg=G`z
inoremap <F8> <ESC>mzgg=G`z<Insert>

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

"MESSY: not optimal!!! (todo)
function! s:lightenTrailingWhitespace()
  highlight ExtraWhitespace ctermbg=gray guibg=gray
  :autocmd ColorScheme * highlight ExtraWhitespace ctermbg=gray guibg=gray
endfunction


if has("autocmd")
  :autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red

  " make it lighter for formats which DO USE trailing spaces
  :autocmd BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn,jade} call s:lightenTrailingWhitespace()
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

" --------Color Scheme-------------------{{{1

" in terminal choose DARK background
if has("gui")
  if &t_Co >= 256 || has("gui_running")


    colorscheme solarized
    call togglebg#map("<F5>")       " F5 toggle background

  endif

else
  colorscheme mustang
  let &background = "dark"
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
" --------Special addit keywords (TODO,...)--{{{1
"
"

"WORKS NOT
"syn match   myTodo   contained   "\<\(TODO\|FIXME\|REMARK\|WARNING\|REMEMBER\):"
"hi def link myTodo Todo

" WORKS(sometimes) (http://superuser.com/questions/110054/custom-vim-highlighting)
highlight myHighlight1 guifg=red guibg=green
"syntax match myHighlight1 /WARN/
syntax match myHighlight1 /.*WARN.*/


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

" --------NeoComplCache----------------{{{1


let g:neocomplcache_enable_at_startup = 1

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

" Disable for HTML as it doesn't play nicely
" (cf. http://stackoverflow.com/questions/5237275/how-can-i-validate-html5-directly-in-vim)
" SEE HTML5 validation further on
    let g:syntastic_disabled_filetypes = ['html']

"1}}}
" --------Tartify ---------------------{{{1


let g:tartify_auto_enable = 1
map <silent> <leader>st    :call g:tartify_statusline_toggle()<CR>

" Overwrite statusline colors with your own
if exists("g:tartify_forceColor")
  let g:tartify_forceColor.light.9.hue = "red"
  let g:tartify_forceColor.light.9.format = "undercurl"
endif

let g:tartify_forceTheme = "solarized"



" SEQUENCE: the sequence of elements present in the statusline is by default
" defined by the plugin. If the current ColorScheme defines an alternative
" default sequence, it will be used instead. If the user defines his own
" sequence (a 'user' key exists in the g:tartify_sequence dictionnary), that
" sequence overrides the other two.
"
" In order to never use any theme's default squence, you can set the following
" variable :
"
"   let g:tartify_sequence_ignore   = "theme"
"
" NB: a "user" sequence will always overrride the default sequence
"
"

"let g:tartify_sequence_ignore   = "theme"



let g:tartify_disabled = ['git', 'longlines', 'path', ]
" StatusLine Elements :
"   git, longlines,path,...
" FileType statusline
"   help, plug:fugitive,plug:NERDTree,...
"

set statusline=%<%f%h%m%r%=%b\ 0x%B\ \ %l,%c%V\ %#warningmsg#%P

"1}}}
" --------xptemplate--------------------{{{1





"1}}}
" --------ShowMarks(x)-----------------{{{1


""let g:showmarks_enable=0       "ShowMarks - disable by default
"let g:Tlist_Use_SingleClick=1  "TagList   - single click to 'goto' tag

"1}}}
" --------Command-T(x)-----------------{{{1


""Command-T configuration
"let g:CommandTMaxHeight=20



"1}}}
" --------TagBar(TODO?)----------------{{{1

"if has("macunix")
"  au BufRead,BufNewFile *.js let g:tagbar_ctags_bin="/usr/local/bin/jsctags"
"endif

let g:tagbar_type_javascript ="jsctags"



"1}}}
" --------Supertab---------------------{{{1

"let supertab play well with other tools like snipmate, and xptemplate (?)
"FIXME : maybe this is not needed anymore

let g:SuperTabDefaultCompletionType = "context"



"1}}}


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                           FILES SPECIFIC CONFIGS
"------------------------------------------------------------------------------

"--------Markdow and Txt files---------{{{1
"
" from https://github.com/isaacs/.vim/blob/master/vimrc

function! s:setupWrapping()
  set wrap
  "set wm=2
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
"--------SCSS syntax ------------------{{{1
"
au BufRead,BufNewFile *.scss set filetype=scss

"1}}}
"--------Vim Diff tweaks---------------{{{1
if &diff
  colorscheme solarized
endif

"1}}}

"##############################################################################
"                           --MAPPING--
"##############################################################################
"------------------------------------------------------------------------------
"                           GENERAL
"------------------------------------------------------------------------------

" --------MISC-------------------------{{{1
" Use Q for formatting the current paragraph (or selection)
vmap Q gq
nmap Q gqap



" ALT+space to quickly switch colorschemes
"requires set wildmode=full   and set wildmenu
nmap <A-space> :colorscheme<space>

" Forgot to sudo : save with w!!
cmap w!! w !sudo tee % >/dev/null



" Buffer/Window closing
"
" Close buffer without closing window (using sequence Kwbd)
" (http://vim.wikia.com/wiki/VimTip165)
nmap <Leader>x      :Kwbd<CR>
" Close buffer & window
nmap <leader><S-x>      :bd<CR>
" Close window
nmap <leader><C-x>   :clo<CR>
"1}}}
" --------WINDOW RESIZING--------------{{{1

set winminheight=1     "minimized window only shows title

" Manual (horizontal) Resizing
" ( ",<" AND ",>" are shorter than "C-w C-<" AND "C-w C->" )
:nnoremap ,< <C-W><<C-W><<C-W><<C-W><
:nnoremap ,> <C-W>><C-W>><C-W>><C-W>>

" MINIMIZING
" Auto-collapsible minimized windows
"
" when a window is minimized, it will remember its state
" (w:autoCollapsible variable), then :
"
"     - when entered : it will be resized 16 line high
"     - when exited  : it will resume its minimized state
"

autocmd WinEnter * if winheight(0) <= &winminheight | let w:autoCollapsible = 1 | resize 16 | endif

autocmd WinLeave * if  exists("w:autoCollapsible") | resize 0 | endif


"autocmd WinEnter * if winheight(0) <= &winminheight | let w:autoCollapsible = 1 | resize 16 | endif

"autocmd WinLeave * if  exists("w:autoCollapsible") | resize 0 | endif
""autocmd WinLeave * if  exists("w:autoCollapsible") | resize 0 | unlet w:autoCollapsible | endif


" The following mappings reset w:autoCollapsible, as we
" chose to "unminimized" the window

function! g:wipeMinimizedState()
  unlet! w:autoCollapsible
  "call Decho("MINIMIZED state WIPED")
endfunction

function! g:toggleAutoCollapsible()
  if exists("w:autoCollapsible")
    unlet w:autoCollapsible
  else
    let w:autoCollapsible = 1
  endif
endfunction

"    Set Window to Auto-collapsible

nmap <leader>mc     :call g:toggleAutoCollapsible()<CR>
"nmap <leader>mc     :let w:autoCollapsible = 1<CR>

"    space to maximize current window
nmap <S-space>      :call g:wipeMinimizedState()<CR><C-W>_

nmap <leader>ml      :call g:wipeMinimizedState()<CR><C-W>_

"    Minimize current window
nmap <leader>mm    :call g:wipeMinimizedState()<CR><C-W>1_

"    set current window to 8 lines
nmap <leader>m&    :call g:wipeMinimizedState()<CR><C-W>8_

"    ctrl+shift+space to set current window to 16 lines
nmap <C-S-space>    :call g:wipeMinimizedState()<CR><C-W>16_

nmap <leader>mé    :call g:wipeMinimizedState()<CR><C-W>16_

"    ctrl+shift+alt+space to set current window to 32 lines
nmap <C-S-A-space>    :call g:wipeMinimizedState()<CR><C-W>32_

nmap <leader>m"    :call g:wipeMinimizedState()<CR><C-W>32_




"1}}}
" --------autoMAX window (DISABLED)----{{{1

"" automatically maximize active window
"
""minimized window only shows title
"set winminheight=0
"
""hack to avoid <C-W>_
"set winheight=999


"1}}}
" --------NAVIGATION-------------------{{{1
" use CTRL hjkl to navigate in different modes

" NORMAL : Window navigation
" (don't leave homerow)
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l
" VISUAL/SELECT : Window navigation
" (don't leave homerow)
vmap <C-h> <C-w>h
vmap <C-j> <C-w>j
vmap <C-k> <C-w>k
vmap <C-l> <C-w>l
" (also arrows, in all modes)
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

"WARN: abandonned I prefer to use <c-space> for xptemplate instead
"" map CTRL+SPACE to ESC in ALL modes
"" (normal, visual, select, operator pending)
"if has('unix') && !has('gui_running')
"  imap <Nul> <Esc>
"  vmap <Nul> <Esc>
"  nmap <Nul> <Esc>
"  cnoremap <Nul> <C-c>  "hacky, right ?
"else
"  imap <C-space> <Esc>
"  vmap <C-space> <Esc>
"  nmap <C-Space> <ESC>
"  cmap <C-Space> <C-c>
"endif

" remap jf to ESC in modes that don't use the 'j' key for navigation
" (insert, command, operator-pending)
imap jf <C-c>
cmap jf <C-c>
vmap jf <C-c>
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
nmap '  [
nmap -  ]
nmap §  {
nmap à  }

vmap '  [
vmap -  ]
vmap §  {
vmap à  }

nmap ù  %
vmap ù  %

"nnoremap ù  %
"vnoremap ù  %

nmap ; .
omap ; .

"last edit point
nmap `; `.

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
"--------gv & gV (select Visual mode)-{{{1



" Visually select the text that was last edited/pasted
" (more generic than gv)
nmap gV `[v`]





"1}}}
"--------Line Bubbling----------------{{{1
"
"SOURCE: http://vim.wikia.com/wiki/VimTip191
"
function! MoveLineUp()
  call MoveLineOrVisualUp(".", "")
endfunction

function! MoveLineDown()
  call MoveLineOrVisualDown(".", "")
endfunction

function! MoveVisualUp()
  call MoveLineOrVisualUp("'<", "'<,'>")
  normal gv
endfunction

function! MoveVisualDown()
  call MoveLineOrVisualDown("'>", "'<,'>")
  normal gv
endfunction

function! MoveLineOrVisualUp(line_getter, range)
  let l_num = line(a:line_getter)
  if l_num - v:count1 - 1 < 0
    let move_arg = "0"
  else
    let move_arg = a:line_getter." -".(v:count1 + 1)
  endif
  call MoveLineOrVisualUpOrDown(a:range."move ".move_arg)
endfunction

function! MoveLineOrVisualDown(line_getter, range)
  let l_num = line(a:line_getter)
  if l_num + v:count1 > line("$")
    let move_arg = "$"
  else
    let move_arg = a:line_getter." +".v:count1
  endif
  call MoveLineOrVisualUpOrDown(a:range."move ".move_arg)
endfunction

function! MoveLineOrVisualUpOrDown(move_arg)
  let col_num = virtcol(".")
  execute "silent! ".a:move_arg
  execute "normal! ".col_num."|"
endfunction

"nnoremap <silent> <S-k> :<C-u>call MoveLineUp()<CR>
"nnoremap <silent> <S-j> :<C-u>call MoveLineDown()<CR>
nnoremap <silent> <D-k> :<C-u>call MoveLineUp()<CR>
nnoremap <silent> <D-j> :<C-u>call MoveLineDown()<CR>
inoremap <silent> <D-k> <C-o>:<C-u>call MoveLineUp()<CR>
inoremap <silent> <D-j> <C-o>:<C-u>call MoveLineDown()<CR>
vnoremap <silent> <S-k> :<C-u>call MoveVisualUp()<CR>
vnoremap <silent> <S-j> :<C-u>call MoveVisualDown()<CR>
vnoremap <silent> <D-k> :<C-u>call MoveVisualUp()<CR>
vnoremap <silent> <D-j> :<C-u>call MoveVisualDown()<CR>





"1}}}
"--------Case -------------------------{{{1

function! TwiddleCase(str)
  if a:str ==# toupper(a:str)
    let result = tolower(a:str)
  elseif a:str ==# tolower(a:str)
    let result = substitute(a:str,'\(\<\w\+\>\)', '\u\1', 'g')
  else
    let result = toupper(a:str)
  endif
  return result
endfunction
vnoremap ~ ygv"=TwiddleCase(@")<CR>Pgv



"1}}}
"--------Edit ------------------------{{{1

map <S-Enter> O<ESC> " awesome, inserts new line without going into insert mode


"1}}}
"--------HTML5 validation--------------{{{1
"check html
map ,5 :!html5check %<CR>

"1}}}
"--------Create TMP buffer-tab IDfile--{{{1
"

function! g:tartify_list(arg)
  "if match(a:arg , 'plug|plugin|plugins')
    ""for f in split(glob('/Users/plhoste/.vim/bundle/tartify/*' ), '\n')
    "for f in split(glob(s:tart_pluginDir . "*"), '\n')
      "if s:production == 0
        "call Decho(f)
      "endif
    "endfor
    ""let l:dirlist = get(s:tart_pluginDir)
    ""let l:dirlist = split(glob("s:tart_pluginDir/*"), '\n')
    ""call Decho("Dir contains\n" .  l:dirlist )
  "else
    "if s:production == 0
      "call Decho("unknown arg for g:tart_pluginDir()")
    "endif
  "endif



endfunction




map ,NN :!createIDfile %<CR>

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

"" suppress LustyJuggler ruby warning
"let g:LustyJugglerSuppressRubyWarning = 1

"1}}}
"---------Syntastic-------------------{{{1

" Map :Errors command to <leader>E
nmap <leader>E  :Errors<CR>

"1}}}
"---------NERDTree--------------------{{{1
map <leader>t :execute 'NERDTreeToggle ' . getcwd()<CR>

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

" autoclean fugitive buffers
" (http://vimcasts.org/episodes/fugitive-vim-browsing-the-git-object-database/)
autocmd BufReadPost fugitive://* set bufhidden=delete


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
 :nmap <leader>fr     :FufRenewCache<CR>:echo "cache renewed"<CR>

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
let g:decho_winheight=10

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
" ---------Unimpaired Line Bubbl(x)-----{{{1


""FROM: http://vimcasts.org/episodes/bubbling-text/
"" Bubble single lines
"nmap <D-k> [e
"nmap <D-j> ]e
"nmap <S-Up> [e
"nmap <S-Down> ]e
""" (not working)Bubble in insert mode
""imap <D-k> <esc>[eki
""imap <D-j> <esc>]eji
"" Bubble multiple lines
"vmap <D-k> [egv
"vmap <D-j> ]egv
"vmap <S-Up> [egv
"vmap <S-Down> ]egv

"1}}}
"---------TagList(x)-------------------{{{1
"" taglist to ,T
"nmap <leader>T   :TlistToggle<CR>


"---------TagBAR-----------------------{{{1
"" tagbar to ,t
nmap <leader><C-t> :TagbarToggle<CR>

"---------Gist-------------------------{{{1

" Open the gist in browser after post
let g:gist_open_browser_after_post = 1

"QUIX: edit/save the QUIX (bookmarklets on steroids) config on gist.github.com
nmap <leader>eq      :Gist 1397755<CR>
nmap <leader>sq      :Gist -e<CR>
nmap <leader>Gq      :Gist 1397755<CR>
nmap <leader>Gs      :Gist -e<CR>

  ":Gist
    "post whole text to gist.

  ":'<,'>Gist
    "post selected text to gist.

  ":Gist -p
    "post whole text to gist with private.
    "if you got empty gist list, try :Gist --abandon

  ":Gist -a
    "post whole text to gist with anonymous.

  ":Gist -m
    "post multi buffer to gist.

  ":Gist -e
    "edit the gist. (shoud be work on gist buffer)
    "you can update the gist with :w command on gist buffer.

  ":Gist -e foo.js
    "edit the gist with name 'foo.js'. (shoud be work on gist buffer)

  ":Gist -d
    "delete the gist. (should be work on gist buffer)
    "password authentication is needed.

  ":Gist -f
    "fork the gist. (should be work on gist buffer)
    "password authentication is needed.

  ":Gist XXXXX
    "get gist XXXXX.

  ":Gist -c XXXXX.
    "get gist XXXXX and put to clipboard.

  ":Gist -l
    "list gists from mine.

  ":Gist -la
    "list gists from all.

"1}}}
"---------Repeat-----------------------{{{1
"
silent! call repeat#set("\<Plug>surround", v:count)
silent! call repeat#set("\<Plug>unimpaired", v:count)

"1}}}
" --------xptemplate---------------------{{{1


let g:xptemplate_key = '<s-Tab>'
"let g:xptemplate_key = '<c-space>'


"1}}}



"------------------------------------------------------------------------------
"                    MACOS SPECIFIC APPS
"------------------------------------------------------------------------------

" --------Marked(MD preview)-----------{{{1

if has("macunix")
  :nnoremap <leader>P :silent !open -a Marked.app '%:p'<cr>
endif




"1}}}


"------------------------------------------------------------------------------
"                    OTHER OS SPECIFIC APPS
"------------------------------------------------------------------------------

"--------GOOGLE CLosure Linting--{{{1
"



function! AutocmdJS()

  " javascript
  nnoremap ,jsl :!gjslint --custom_jsdoc_tags 'xtype,event,singleton' %<CR>
  nnoremap ,jsf :!fixjsstyle --custom_jsdoc_tags 'xtype,event,singleton' %<CR>
  :command! FJS :call FixJS()

endf



" Let Google Linter autofix the js errors in the current buffer
function! FixJS()
  setlocal autoread
  execute('silent !fixjsstyle --strict --nojsdoc %')
  execute(retab)
  "execute('silent !fixjsstyle --strict --nojsdoc %')
endfunction


if has("autocmd")
  au filetype javascript call AutocmdJS()
endif



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
" CAPS LOCK -> LEFT CTRL
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
