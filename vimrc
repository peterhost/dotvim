"                               web resources
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" http://objectmix.com/editors/394885-how-do-you-parameterize-your-vimrc-different-machines.html
" https://github.com/bronson/vim-update-bundles
" LustyJuggler  screencast:     http://lococast.net/archives/185
" Command-T     screencast:     https://wincent.com/products/command-t
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"##############################################################################
"                               MEMO CARD
"##############################################################################
"
" :changes -> view undo history for buffer/file
" :history -> view history of commands
"
"
"
"
"
"
"
"
"
"
"
"
"
"
"
"
"
"
"
"
"
"
"
"

"##############################################################################
"                               PATHOGEN/VUNDLE
"##############################################################################


" ---Vundle INITIALISATION------------{{{1
" This must be first, because it changes other options as side effect
set nocompatible

"" Needed on some linux distros for proper pathogen/vundle loading
"" see http://www.adamlowe.me/2009/12/vim-destroys-all-other-rails-editors.html
filetype off


""~~~ VUNDLE ~~~
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

"1}}}
" ------Load/Unload plugins RULES -----{{{1

" the VUNDLE plugin manager has to be able and manange itself
Plugin 'gmarik/vundle'



"-------------------------------------
"              UNUSED
"
"-------------------------------------


" -------------------------------------
" MODULES LOADED IN ANY CASE
"
" -------------------------------------

" CSS Cleaner
Plugin 'miripiruni/CSScomb-for-Vim'
" PHP debuger
Plugin 'brookhong/DBGPavim'
" Vim Debugger
Plugin 'Decho'
" Advanced encoding detector
Plugin 'vim-scripts/FencView.vim'
" edit/post gists
Plugin 'vim-scripts/Gist.vim'
" Large files loading
Plugin 'vim-scripts/LargeFile'
" Copy / Paste with history
Plugin 'YankRing.vim'
" Vim syntax highlight for asp.net ...
Plugin 'aspnetcs'
" Resize workspace with golden ratio
Plugin 'roman/golden-ratio'
" HTML5 syntax highlight with microdata, rdf,... support
Plugin 'othree/html5.vim'
" awesome commenting plugin
Plugin 'scrooloose/nerdcommenter'
" file browser
Plugin 'scrooloose/nerdtree'
" Session handling for VIM
Plugin 'session.vim--Odding'

" Completion tool on TAB
Plugin 'ervandew/supertab'

" Syntax checking
Plugin 'scrooloose/syntastic'
" the TABULARIZE fonction for fast re-aligning of code
Plugin 'godlygeek/tabular'
" Close buffer but leave window alone : adds Kwbd command (see below)
Plugin 'cespare/vim-bclose'
" lists buffers in new tab/window (for ex)
Plugin 'jlanzarotta/bufexplorer'
" display colors inline in CSS
Plugin 'skammer/vim-css-color'
" colorscheme based on github
Plugin 'endel/vim-github-colorscheme.git'
" Tpope's GIT for vim
Plugin 'tpope/vim-fugitive'
" Tpope syntax,... for editing git related files
Plugin 'tpope/vim-git'

" JavaScript bundle provides syntax and indent plugin
Plugin 'pangloss/vim-javascript'
" syntaxe additionnelle pour vim-javascript (underscore, jquery,...)
Plugin 'crusoexia/vim-javascript-lib'

" manage Jekull blog from within Vim
Plugin 'itspriddle/vim-jekyll'
" matchit.zip : extended % matching for HTML, LaTeX, and many other languages  | DEPREC ?
Plugin 'eshock/vim-matchit'

"------- STATUS LINE ------
" DISABLED (unmaintained)
"Plugin 'Lokaltog/vim-powerline'
"
" REPLACES vim-powerline
Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'edkolev/tmuxline.vim'
" ------------------------
"
" tpope,'s better repeat for vim
Plugin 'tpope/vim-repeat'
" surround by tpope
Plugin 'tpope/vim-surround'
" tpope too
Plugin 'tpope/vim-unimpaired'
" powerfull TAB templates ala textmate
Plugin 'drmingdrmer/xptemplate'
" alternate buffer explorer
Plugin 'fholgado/minibufexpl.vim'

" ----- PYTHON ------
Plugin 'klen/python-mode'
Plugin 'davidhalter/jedi-vim'

if  has('python')
  " Powerfull completion tool, including CTAGS (replacement for tagbar)
  "Plugin 'Valloric/YouCompleteMe'
endif

" ----- JAVASCRIPT --
" jshint check for js                      | DEPENDS nodejs
Plugin 'wookiehangover/jshint.vim'
" insert jsdoc tags
Plugin 'heavenshell/vim-jsdoc'

" ----- SYNTAXES ----
" Syntax highlighting, matching rules and mappings for Markdown.
"Plugin 'plasticboy/vim-markdown'

" this one allows concealing of markdown markers while editing,
" and is compatible with conceiling in 'limelight' plugin.
Plugin 'tpope/vim-markdown'

" Linux only : markdown previewer
if has('unix') && !has('macunix')
    Plugin 'suan/vim-instant-markdown'
endif

" syntax highlight for SCSS templates
Plugin 'cakebaker/scss-syntax.vim'
" syntax highlight for Jade templates
Plugin 'digitaltoad/vim-jade'
" Syntax highlighting for Stylus.
Plugin 'wavded/vim-stylus'
" CSV files
Plugin 'chrisbra/csv.vim'

" .toml syntax
Plugin 'cespare/vim-toml'
Plugin 'maralla/vim-toml-enhance'

" ----- TMUX ----
Plugin 'christoomey/vim-tmux-navigator'

" ----- MOVEMENT ---
"Plugin 'matze/vim-move'
" swap pane content without ruining layout
Plugin 'wesQ3/vim-windowswap'

" ------ TEXT EDITING ------
Plugin 'reedes/vim-pencil'
Plugin 'junegunn/limelight.vim'
Plugin 'junegunn/goyo.vim'


" ------ COLORSCHEMES ------
" the Solarized colorscheme
Plugin 'altercation/vim-colors-solarized'
Plugin 'junegunn/seoul256.vim'
Plugin 'reedes/vim-colors-pencil'

"-------------------------------------
"        CONDITIONAL LOADING
"
"-------------------------------------


Plugin 'majutsushi/tagbar'
" TAGBAR & JAVASCRIPT : Use the 'tern' javascript ctags engine replacing the
"                       original doctorjs jsctags
" https://github.com/majutsushi/tagbar/wiki#javascript
" https://github.com/ramitos/jsctags (ctags generator using node 'tern')
" https://github.com/marijnh/tern_for_vim ('tern' plugin for vim)
"
" 1 : `npm install -g git+https://github.com/ramitos/jsctags.git`
" 2 : `sudo npm install tern -g` (or `npm install tern -g`on mac)


if executable('node')
  if executable('jsctags')
    if executable('tern')
      Plugin 'marijnh/tern_for_vim'
    else
      "do nothing
      echo "tern is not installed (ctags for javascript, read .vimrc)"
    endif
  else
    " do nothing
      echo "jsctags is not installed (ctags for javascript, read .vimrc)"
  endif
endif



if has("gui_macvim")
  "the PEEPOPEN program is a Macos specific Command-T

  " integration with peepopen for macos
  Plugin 'shemerey/vim-peepopen'
end

if v:version >= '702'
  " (required by fuzzyfinder)
  Plugin 'L9'
  " Fuzzy file/dir/tag/... finder
  Plugin 'FuzzyFinder'
endif

" All those need ruby support
if  has('ruby')
  " provides LustyJuggler, LustyExplorer        | DEPENDS ruby
  Plugin 'sjbach/lusty'
endif




if v:version >= '703' && !has('python')
  " Gundo requires at least Vim 7.3

  " Undo with tree, branching, history
  Plugin 'Gundo'
endif



if !has("signs")
  "
endif






"1}}}
" ---Vundle POST-INIT-----------------{{{1


""~~~ VUNDLE ~~~
filetype plugin indent on     " required!
" "
" " Brief help
" " :BundleList          - list configured bundles
" " :BundleInstall(!)    - install(update) bundles
" " :BundleSearch(!) foo - search(or refresh cache first) for foo
" " :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
" "
" " see :h vundle for more details or wiki for FAQ
" " NOTE: comments after Plugin command are not allowed..


"1}}}



"##############################################################################
"                             GENERAL SETTINGS
"##############################################################################


" --------GENERAL SETTINGS -------------{{{1

" UTF8 by default
set encoding=utf-8

"---------------------------------------------------------
" FROM : http://nvie.com/posts/how-i-boosted-my-vim/

" change the mapleader from \ to ,
let mapleader=","
let maplocalleader="="


" hide bufers instead of closing them
set hidden

" usefull stuff
set nowrap        " don't wrap lines
set tabstop=4     " a tab is two spaces
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
set undodir=~/.vim/undodir " dir to store history between sessions
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


" Cursor : different in insert mode for terminal vim
" (with handling of tmux)
" source : https://gist.github.com/andyfowler/1195581
if has("gui")
  " nothing here
else
  " tmux will only forward escape sequences to the terminal if surrounded by a
  " DCS sequence
  " "
  " http://sourceforge.net/mailarchive/forum.php?thread_name=AANLkTinkbdoZ8eNR1X2UobLTeww1jFrvfJxTMfKSq-L%2B%40mail.gmail.com&forum_name=tmux-users
  "
   if exists('$TMUX')
     let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
     let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
   else
     let &t_SI = "\<Esc>]50;CursorShape=1\x7"
     let &t_EI = "\<Esc>]50;CursorShape=0\x7"
   endif
endif


" REDRAW in terminal VIM each time a buffer gains focus, to prevent
" the 'ghost characters' from showing up in 'plugin heavy' situations
" (lots of system calls)
" SEE : https://unix.stackexchange.com/questions/58941/how-to-automatically-refresh-vim-on-buffer-window-focus
" ANS : https://stackoverflow.com/questions/22250690/in-terminal-vim-how-do-i-prevent-ghost-echoing-while-running-a-shell-command-vi
:au FocusGained * :redraw!
nnoremap <silent> <leader>rr :silent! redraw!<CR>

"1}}}
" --------GUI FONT & size -------------{{{1

if has("gui")
    if has("gui_macvim")

        " Default FONT

        "set guifont=Menlo\ Regular:h11
        set guifont=SourceCodePro-ExtraLight:h13

        "set guifont=set guifont=DejaVu\ Sans\ Mono:h11
        "set guifont=Century\ Schoolbook\ Monospace\ BT:h14
        "set guifont=Nitti\ Normal:h12
        nnoremap <silent> <leader>1 :silent! set guifont=Century\ Schoolbook\ Monospace\ BT:h14<CR>
        nnoremap <silent> <leader>2 :silent! set guifont=DejaVu\ Sans\ Mono:h11<CR>
        nnoremap <silent> <leader>3 :silent! set guifont=Menlo\ Regular:h11<CR>
        nnoremap <silent> <leader>4 :silent! set guifont=Nitti\ Light:h12<CR>
        nnoremap <silent> <leader>7 :silent! set guifont=Nitti\ Normal:h12<CR>
        nnoremap <silent> <leader>8 :silent! set guifont=Nitti\ Bold:h12<CR>
        nnoremap <silent> <leader>9 :silent! set guifont=SourceCodePro-ExtraLight:h14<CR>

    else

        " Default FONT

        "set guifont=Century\ Schoolbook\ Monospace\ BT:h14
        "set guifont=set guifont=DejaVu\ Sans\ Mono:h11
        "set guifont=Menlo\ Regular:h11
        set guifont="Meslo LG M DZ":10
        "set guifont=Nitti\ Normal:h12
        nnoremap <silent> <leader>1 :silent! set guifont=Century\ Schoolbook\ Monospace\ BT:h14<CR>
        nnoremap <silent> <leader>2 :silent! set guifont=DejaVu\ Sans\ Mono:h11<CR>
        nnoremap <silent> <leader>3 :silent! set guifont="Meslo LG M DZ":10<CR>
        nnoremap <silent> <leader>6 :silent! set guifont=Nitti\ Light:h12<CR>
        nnoremap <silent> <leader>7 :silent! set guifont=Nitti\ Normal:h12<CR>
        nnoremap <silent> <leader>8 :silent! set guifont=Nitti\ Bold:h12<CR>

    endif


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

set sessionoptions=buffers,curdir,folds,localoptions,tabpages,winsize

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
  autocmd FileType vim         setlocal foldmethod=marker
  autocmd BufRead *.vim        setlocal foldmethod=marker
  autocmd FileType html        setlocal foldmethod=marker
  autocmd BufRead *.html       setlocal foldmethod=marker
  autocmd FileType jade        setlocal foldmethod=marker
  autocmd BufRead *.jade       setlocal foldmethod=marker
  autocmd BufRead *.js         setlocal foldmethod=indent
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
au FileType xml set tabstop=4     " a tab is four spaces for XML files
au FileType xml set shiftwidth=4     " a tab is four spaces for XML files

"1}}}
" --------Tabulation de 4--------------------------{{{1

au FileType js, cpp, python set shiftwidth=4     " a tab is four spaces for those

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
  " make use real tabs
  autocmd FileType make        set noexpandtab

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
  "plhoste 2012-06-30 22:23:08 : disable that, it's useful, even in markdown
  silent! nnoremap <leader><space>   :echo "disabled for markdown"<CR>
  silent! vnoremap <leader><space>   :echo "disabled for markdown"<CR>
endfunction

function! s:markdownWhitespaceWipers()
  " in WHOLE FILE: in the case of Markdown, 2 whitespaces at end of line
  " mean : "force line break", so we only wipe out psaces if there are 3
  " or more of them at EOL
  map <silent> <S-F7>                 :%s/\s\s\s\+$//g<CR>

  " on CURRENT LINE : no different than normal Whitespacewiper. On a
  " single line, you can hardly make unrecoverable mistakes
  nnoremap <silent> <leader><space>   :s/\s\+$//g<CR>
  vnoremap <silent> <leader><space>   :s/\s\+$//g<CR>
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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                              OTHER
"------------------------------------------------------------------------------

" --------Delete Empty Buffers------------{{{1

function! g:CleanEmptyBuffers()
  let buffers = filter(range(0, bufnr('$')), 'buflisted(v:val) && empty(bufname(v:val)) && bufwinnr(v:val)<0')
  if !empty(buffers)
    exe 'bw '.join(buffers, ' ')
  endif
endfunction

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
  " dont highlight for CSV
  if (&ft=='csv' || &ft=='csv')
      highlight OverLength ctermbg=transparent ctermfg= guibg=
  else
    if &background == "light"
      highlight OverLength ctermbg=red ctermfg=white guibg=#efe9d6
    else
      highlight OverLength ctermbg=red ctermfg=white guibg=#592929
    endif
  endif
endfunction


if has("autocmd")
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
  " dont highlight for CSV
  if (&ft=='csv' || &ft=='csv')
    autocmd BufwinEnter * 2match OverLength /\%81v.\+/
  endif
endif

if (&ft=='csv' || &ft=='csv')
  2match OverLength /\%81v.\+/
endif



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
if has("gui") &&   has("gui_running")
  "if &t_Co >= 256 && has("gui_running")
  "if  has("gui_running")


    "colorscheme solarized
    if has("gui_macvim")
      silent! set background=dark
      let g:lucius_style='dark'
      g:lucius_contrast='normal'
      let g:lucius_contrast_bg='normal'
      colorscheme lucius
    else
      colorscheme jellybeans
    endif

    call togglebg#map("<F5>")       " F5 toggle background

    "DARK
    nnoremap <silent> <leader>@& :silent! colorscheme solarized   <bar>set background=dark <CR> <CR> " @ 1
    nnoremap <silent> <leader>@é :silent! colorscheme mustang     <bar>set background=dark <CR> <CR> " @ 2
    nnoremap <silent> <leader>@" :silent! colorscheme vibrantink2 <bar>set background=dark <CR> <CR> " @ 3
    nnoremap <silent> <leader>@' :silent! colorscheme jellybeans  <bar>set background=dark <CR> <CR> " @ 4
    nnoremap <silent> <leader>@( :silent! colorscheme smyck       <bar>set background=dark <CR> <CR> " @ 5
    nnoremap <silent> <leader>@a :silent! colorscheme festoon     <bar>set background=dark <CR> <CR> " @ a
    nnoremap <silent> <leader>@z :silent! colorscheme freya       <bar>set background=dark <CR> <CR> " @ z
    nnoremap <silent> <leader>@e :silent! colorscheme inkpot      <bar>set background=dark <CR> <CR> " @ e

    "LIGHT
    nnoremap <silent> <leader>@§ :silent! colorscheme mayansmoke  <bar>set background=light <CR> " @ 6
    nnoremap <silent> <leader>@è :silent! colorscheme proton      <bar>set background=light <CR> " @ 7
    nnoremap <silent> <leader>@! :silent! colorscheme pyte        <bar>set background=light <CR> " @ 8
    nnoremap <silent> <leader>@ç :silent! colorscheme louver      <bar>set background=light <CR> " @ 9
    nnoremap <silent> <leader>@à :silent! colorscheme festoon     <bar>set background=light <CR> " @ 0
    nnoremap <silent> <leader>@) :silent! colorscheme solarized   <bar>set background=light <CR> " @ 1

    "LUCIUS (has it's own keyboard row all to itself)
    nnoremap <silent> <leader>@q :silent! set background=dark <bar> let g:lucius_style='dark' <bar> let g:lucius_contrast='high'   <bar> let g:lucius_contrast_bg='normal' <bar> colorscheme lucius <CR> " @ s
    nnoremap <silent> <leader>@s :silent! set background=dark <bar> let g:lucius_style='dark' <bar> let g:lucius_contrast='normal' <bar> let g:lucius_contrast_bg='normal' <bar> colorscheme lucius <CR> " @ s
    nnoremap <silent> <leader>@d :silent! set background=dark <bar> let g:lucius_style='dark' <bar> let g:lucius_contrast='low'    <bar> let g:lucius_contrast_bg='normal' <bar> colorscheme lucius <CR> " @ s
    nnoremap <silent> <leader>@f :silent! set background=dark <bar> let g:lucius_style='dark' <bar> let g:lucius_contrast='high'   <bar> let g:lucius_contrast_bg='high'   <bar> colorscheme lucius <CR> " @ s
    nnoremap <silent> <leader>@g :silent! set background=dark <bar> let g:lucius_style='dark' <bar> let g:lucius_contrast='normal' <bar> let g:lucius_contrast_bg='high'   <bar> colorscheme lucius <CR> " @ s
    nnoremap <silent> <leader>@h :silent! set background=dark <bar> let g:lucius_style='dark' <bar> let g:lucius_contrast='low'    <bar> let g:lucius_contrast_bg='high'   <bar> colorscheme lucius <CR> " @ s

    nnoremap <silent> <leader>@j :silent! set background=light <bar> let g:lucius_style='light' <bar> let g:lucius_contrast='high'   <bar> let g:lucius_contrast_bg='high'   <bar> colorscheme lucius <CR> " @ s
    nnoremap <silent> <leader>@k :silent! set background=light <bar> let g:lucius_style='light' <bar> let g:lucius_contrast='normal' <bar> let g:lucius_contrast_bg='normal' <bar> colorscheme lucius <CR> " @ s
    nnoremap <silent> <leader>@l :silent! set background=light <bar> let g:lucius_style='light' <bar> let g:lucius_contrast='low'    <bar> let g:lucius_contrast_bg='normal' <bar> colorscheme lucius <CR> " @ s


    "nnoremap <silent> <leader>@  :echoerr "colorscheme not parameterd" <CR> " @ a
    nnoremap <silent> <leader>@  :colorscheme<CR> " @ a

  "endif


" Terminal, old Vim => dante, which works everywhere
elseif v:version < '703'
  colorscheme dante
" GNU Screen
elseif $STY != ""
  colorscheme moria
else
  "colorscheme mustang
  "colorscheme smyck
  colorscheme dante
  "let &background = "dark"
  colorscheme lucius
  let g:lucius_style='light'
  let g:lucius_contrast='high'
  let g:lucius_contrast_bg='high'
endif




"1}}}


" ~~~~~~~~~~~~~~~~~~POST~ColorScheming~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" --------Additional Syntax (JSON)-----{{{1
" JSON : js syntax suffices
autocmd BufNewFile,BufRead *.json set ft=javascript


"1}}}
" --------CursorLine-------------------{{{1

"if has("gui_running") && has("autocmd")

"  "only highlight line in GUI mode (in terminal, it's distracting)
"  autocmd WinEnter * setlocal cursorline
"  autocmd WinLeave * setlocal nocursorline

"else
"  set nocursorline
"endif

"ENABLED in TERM => with light theme, it's ok
  autocmd WinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline

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

" --------jedi-vim (python)------------{{{1

" Macos with pyenv : http://stackoverflow.com/a/2086309
" to check :
"
"   :python import sys
"   :python print sys.path
"
if has("gui_macvim")
  if has('python3')

    "let g:pyenvPath=system('python -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())"')
    "python3 sys.path.append(vim.command("echo g:pyenvPath"))

    "python3 sys.path.append("/usr/local/opt/pyenv/versions/3.3.2/lib/python3.3/site-packages")
    python3 sys.path.append("/usr/local/opt/pyenv/versions/3.4.1/lib/python3.4/site-packages")

  elseif has('python')
    python sys.path.append("/usr/local/opt/pyenv/versions/2.7.3/lib/python2.7/site-packages")
  endif
endif


"1}}}
" --------[DEPREC] youCompleteMe----------------{{{1



"" WARNING : on OSX, or any environment where python is managed with PYENV,
"" make sur to compile youCompleteMe with the system python (do that in ZSH for
"" ex to avoid loading specific PATH modifications of .bashrc)
"if has("gui_macvim")
"    let g:ycm_path_to_python_interpreter = '/usr/bin/python'
"endif

"1}}}
" --------NeoComplCache----------------{{{1


let g:neocomplcache_enable_at_startup = 1

"1}}}
" --------Syntastic--------------------{{{1

"Use this option to tell syntastic to use the |:sign| interface to mark syntax
"errors:
    let g:syntastic_enable_signs=1

"Enable this option if you want the cursor to jump to the first detected error
"when saving or opening a file:
    let g:syntastic_auto_jump=0

"Use this option to tell syntastic to automatically open and/or close the
"|location-list| (see |syntastic-error-window|).

"When set to 1 the error window will be automatically opened when errors are
"detected, and closed when none are detected. >

    "let g:syntastic_auto_loc_list=1

"When set to 2 the error window will be automatically closed when no errors
"are detected, but not opened automatically.
    let g:syntastic_auto_loc_list=2

" Disable for HTML as it doesn't play nicely
" (cf. http://stackoverflow.com/questions/5237275/how-can-i-validate-html5-directly-in-vim)
" SEE HTML5 validation further on
    let g:syntastic_disabled_filetypes = ['html']

" --------JSHINT conf-------------------{{{2
let g:syntastic_javascript_jshint_conf = "~/.jshintrc"
"2}}}

"1}}}
" --------Tartify ---------------------{{{1


"let g:tartify_auto_enable = 1
"map <silent> <leader>st    :call g:tartify_statusline_toggle()<CR>

"" Overwrite statusline colors with your own
"if exists("g:tartify_forceColor")
"  let g:tartify_forceColor.light.9.hue = "red"
"  let g:tartify_forceColor.light.9.format = "undercurl"
"endif

"let g:tartify_forceTheme = "solarized"



"" SEQUENCE: the sequence of elements present in the statusline is by default
"" defined by the plugin. If the current ColorScheme defines an alternative
"" default sequence, it will be used instead. If the user defines his own
"" sequence (a 'user' key exists in the g:tartify_sequence dictionnary), that
"" sequence overrides the other two.
""
"" In order to never use any theme's default squence, you can set the following
"" variable :
""
""   let g:tartify_sequence_ignore   = "theme"
""
"" NB: a "user" sequence will always overrride the default sequence
""
""

""let g:tartify_sequence_ignore   = "theme"



"let g:tartify_disabled = ['git', 'longlines', 'path', ]
"" StatusLine Elements :
""   git, longlines,path,...
"" FileType statusline
""   help, plug:fugitive,plug:NERDTree,...
""

"set statusline=%<%f%h%m%r%=%b\ 0x%B\ \ %l,%c%V\ %#warningmsg#%P

"1}}}
" --------xptemplate--------------------{{{1





"1}}}
" --------Command-T(x)-----------------{{{1


""Command-T configuration
"let g:CommandTMaxHeight=20



"1}}}
" --------TagBar()----------------{{{1

"" ########## FIRST ITERATION #############
"if has("macunix")
"  au BufRead,BufNewFile *.js let g:tagbar_ctags_bin="/usr/local/bin/jsctags"
"endif

"let g:tagbar_type_javascript ="jsctags"

"" ########## SECOND ITERATION #############
"" retour à Ctags, car le jsctags (doctorjs) originel n'est plus maintenu

"" also, cf. https://stackoverflow.com/questions/8570357/ctags-and-tagbar-configuration-are-out-of-sync
"let g:tagbar_type_javascript = {
"    \ 'ctagstype' : 'JavaScript',
"    \ 'kinds'     : [
"        \ 'o:objects',
"        \ 'f:functions',
"        \ 'a:arrays',
"        \ 's:strings'
"    \ ]
"\ }

"" ########## THIRD ITERATION #############
"" use the nodejs jsctags, which wraps the maintained 'tern' javascript
"" engine
"" TODO : inutile ??
if executable('node') && executable('jsctags') && executable('tern')
  if has('unix') && !has('gui_running')
    "let g:tagbar_type_javascript ="jsctags"
    let g:tagbar_type_javascript = {
        \ 'ctagsbin' : '/usr/bin/jsctags'
        \ }
  elseif has("macunix")
    let g:tagbar_type_javascript = {
        \ 'ctagsbin' : '/usr/local/bin/jsctags'
        \ }
  endif
endif


"1}}}
" --------Supertab---------------------{{{1

"let supertab play well with other tools like snipmate, and xptemplate (?)
"FIXME : maybe this is not needed anymore

let g:SuperTabDefaultCompletionType = "context"



"1}}}
" --------Tabularize------------------{{{1
"
"let tabularize automatically tablularize "|" delimited arrays (markdown,
"tests,...) in INSERT MODE !
"
"SRC : tpope : https://gist.github.com/287147
"VIMCAST : http://vimcasts.org/episodes/aligning-text-with-tabular-vim/
"

inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a

function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction


"1}}}
" --------FencView (encoding)---------{{{1
"
" Great ENCODING TOOL
"
let g:fencview_autodetect=1
let g:fencview_auto_patterns='*.txt,*.js,*.css,*.c,*.cpp,*.h,*.java,*.cs,*.htm{l\=}'
let g:fencview_checklines=20
" couldn't compile it on macos
"let $FENCVIEW_TELLENC='tellenc'

"1}}}
"" --------Powerline (STATUSBAR) [DEPREC]-------{{{1
""
"" Great alternative to TARTIFY
""
""Fancy needs patched fonts installed
"if has("gui_macvim")
"  let g:Powerline_symbols = 'fancy'
"else
"  let g:Powerline_symbols = 'unicode'
"endif

""let g:Powerline_theme = 'skwp'
"set laststatus=2   " Always show the statusline


""short filenames
"let g:Powerline_stl_path_style = 'filename'
""let g:Powerline_stl_path_style = 'short'
""let g:Powerline_stl_path_style = 'relative'
""let g:Powerline_stl_path_style = 'full'

"" add trailing whitespace info
"call Pl#Theme#InsertSegment('ws_marker', 'after', 'lineinfo')
""1}}}
" --------Airline (STATUSBAR)---------{{{1
"

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

if has("gui_macvim")
  "let g:airline_theme = 'solarized'
  let g:airline_powerline_fonts=1

  "following need patched fonts installed
  " powerline symbols
  let g:airline_left_sep = ''
  let g:airline_left_alt_sep = ''
  let g:airline_right_sep = ''
  let g:airline_right_alt_sep = ''
  let g:airline_symbols.branch = ''
  let g:airline_symbols.readonly = ''
  let g:airline_symbols.linenr = ''



else
  let g:airline_theme = 'jellybeans'

  " unicode symbols
  let g:airline_left_sep = '»'
  let g:airline_left_sep = '▶'
  let g:airline_right_sep = '«'
  let g:airline_right_sep = '◀'
  let g:airline_symbols.linenr = '␊'
  let g:airline_symbols.linenr = '␤'
  let g:airline_symbols.linenr = '¶'
  let g:airline_symbols.branch = '⎇'
  let g:airline_symbols.paste = 'ρ'
  let g:airline_symbols.paste = 'Þ'
  let g:airline_symbols.paste = '∥'
  let g:airline_symbols.whitespace = 'Ξ'
endif

set laststatus=2   " Always show the statusline


" TABLINE at top of window
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#tab_nr_type = 2

" MINI BUFFER
" Don't collapse inactive windows
let g:airline_inactive_collapse=1

map <Leader>at :AirlineToggle <CR>
"1}}}
" --------DBGPavim (php xdebug plug)--{{{1
"
"
let g:dbgPavimPort = 9000
let g:dbgPavimBreakAtEntry = 0
"1}}}
" --------(clj)rainbow-parentheses ---{{{1
"
if has("autocmd")
  :autocmd BufRead,BufNewFile *.{clj} RainbowParenthesesToggle
  :autocmd BufRead,BufNewFile *.{clj} RainbowParenthesesLoadRound
  :autocmd BufRead,BufNewFile *.{clj} RainbowParenthesesLoadSquare
  :autocmd BufRead,BufNewFile *.{clj} RainbowParenthesesLoadBraces
endif

let g:rbpt_colorpairs = [
  \ ['brown',       'RoyalBlue3'],
  \ ['Darkblue',    'SeaGreen3'],
  \ ['darkgray',    'DarkOrchid3'],
  \ ['darkgreen',   'firebrick3'],
  \ ['darkcyan',    'RoyalBlue3'],
  \ ['darkred',     'SeaGreen3'],
  \ ['darkmagenta', 'DarkOrchid3'],
  \ ['brown',       'firebrick3'],
  \ ['gray',        'RoyalBlue3'],
  \ ['black',       'SeaGreen3'],
  \ ['darkmagenta', 'DarkOrchid3'],
  \ ['Darkblue',    'firebrick3'],
  \ ['darkgreen',   'RoyalBlue3'],
  \ ['darkcyan',    'SeaGreen3'],
  \ ['darkred',     'DarkOrchid3'],
  \ ['red',         'firebrick3'],
  \ ]

"1}}}
" --------CSV----------------------{{{1
"
"
let g:csv_highlight_column = 'y'
"1}}}
" --------vim-jsdoc----------------------{{{1
"

let g:jsdoc_allow_input_prompt          = 1   " Allow prompt for interactive input.
let g:jsdoc_input_description           = 1   " Prompt for a function description
let g:jsdoc_additional_descriptions     = 1   " Prompt for a value for @name, add it to the JSDoc block comment along with the @function tag.
let g:jsdoc_return                      = 1   " Add the @return tag.
let g:jsdoc_return_type                 = 1   " Prompt for and add a type for the aforementioned @return tag.
let g:jsdoc_return_description          = 0   " Prompt for and add a description for the @return tag.
let g:jsdoc_access_descriptions         = 1   " Set value to 1 to turn on access tags like @access <private|public>. Set value to 2 to turn on access tags like @<private|public>
let g:jsdoc_underscore_private          = 1   " Set value to 1 to turn on detecting underscore starting functions as private convention
let g:jsdoc_allow_shorthand             = 0   " Set value to 1 to allow ECMAScript6 shorthand syntax.
let g:jsdoc_param_description_separator = ' ' " Characters used to separate @param name and description.
let g:jsdoc_custom_args_hook            = {}  " Override default type and description. See help more detail.

" Generate jsdocs in TRANSMIT for macosX temp directory
nnoremap <localleader>D :exec "!cd '%:p:h' ;jsdoc --configure ~/.jsdoc.json --template /usr/local/lib/node_modules/ink-docstrap/template/ app.js; echo \$\(pwd\)'/out/index.html' \| pbcopy"<CR>
nnoremap <localleader>d :JsDoc<CR>



" 1}}}
" --------windowswap---------------------{{{1
"

let g:windowswap_map_keys = 0 "prevent default bindings
"nnoremap <silent> <leader>yw :call WindowSwap#MarkWindowSwap()<CR>
"nnoremap <silent> <leader>pw :call WindowSwap#DoWindowSwap()<CR>
nnoremap <silent> <leader>sw :call WindowSwap#EasyWindowSwap()<CR>


" 1}}}
" --------GoYo---------------------------{{{1
"

" automatically turn limelight on when entering Goyo mode

function! s:goyo_enter()
  silent !tmux set status off
  set noshowmode
  set noshowcmd
  set scrolloff=999
  Limelight
  PencilSoft
  "colorscheme pencil
  "set background=dark
  let g:airline_theme = 'pencil'
  " ...
endfunction

function! s:goyo_leave()
  silent !tmux set status on
  set showmode
  set showcmd
  set scrolloff=5
  Limelight!
  PencilOff
  "colorscheme lucius
  " ...
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()


" 1}}}
" --------Vim-Color-Pencil---------------{{{1
"

" automatically personalize the pencil colorscheme when used
let g:pencil_terminal_italics = 1

" 1}}}
" --------vim-instant-markdown----------{{{1

let g:instant_markdown_autostart = 0

"Linux only : map for preview in browser
if has('unix') && !has('macunix')
  :nnoremap <leader>P :InstantMarkdownPreview<cr>
endif


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
  nmap <buffer> <Leader><C-p> :Mm <CR>
  imap <buffer> <C-p> :Mm <CR>
endfunction


if has("autocmd")
  " All txt files are NOW considered markdown, period
  au BufRead,BufNewFile *.txt set filetype=markdown

  " md, markdown, and mk are markdown and define buffer-local preview
  au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn} call s:setupMarkup()
  au BufRead,BufNewFile *.txt call s:setupWrapping()

  " unset/re-set "whitespace removing mappings" when entering/leaving MD buffer
  au BufEnter *.{txt,md,markdown,mdown,mkd,mkdn} call s:markdownWhitespaceWipers()
  au BufLeave *.{txt,md,markdown,mdown,mkd,mkdn} call s:enableWhitespaceWipers()
endif

"1}}}
"--------SCSS syntax ------------------{{{1
"
au BufRead,BufNewFile *.scss set filetype=scss

"1}}}
"--------MQL4 syntax ------------------{{{1
"
au BufRead,BufNewFile *.mq[54h]      set filetype=mql4

"1}}}
"--------Vim Diff tweaks---------------{{{1
if &diff
  colorscheme solarized
endif

"1}}}
"--------Vim Diff MAPPING--------------{{{1
nnoremap Dp :diffput<CR>
nnoremap Dg :diffget<CR>
nnoremap Du :diffupdate<CR>
nnoremap Dt :diffthis<CR>
nnoremap Do :diffoff<CR>


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

"plhoste 2012-06-30 22:31:18 : DISABLED
"" MINIMIZING
"" Auto-collapsible minimized windows
""
"" when a window is minimized, it will remember its state
"" (w:autoCollapsible variable), then :
""
""     - when entered : it will be resized 16 line high
""     - when exited  : it will resume its minimized state
""

"autocmd WinEnter * if winheight(0) <= &winminheight | let w:autoCollapsible = 1 | resize 16 | endif

"autocmd WinLeave * if  exists("w:autoCollapsible") | resize 0 | endif


""autocmd WinEnter * if winheight(0) <= &winminheight | let w:autoCollapsible = 1 | resize 16 | endif

""autocmd WinLeave * if  exists("w:autoCollapsible") | resize 0 | endif
"""autocmd WinLeave * if  exists("w:autoCollapsible") | resize 0 | unlet w:autoCollapsible | endif


"" The following mappings reset w:autoCollapsible, as we
"" chose to "unminimized" the window

"function! g:wipeMinimizedState()
"  unlet! w:autoCollapsible
"  "call Decho("MINIMIZED state WIPED")
"endfunction

"function! g:toggleAutoCollapsible()
"  if exists("w:autoCollapsible")
"    unlet w:autoCollapsible
"  else
"    let w:autoCollapsible = 1
"  endif
"endfunction

""    Set Window to Auto-collapsible

"nmap <leader>mc     :call g:toggleAutoCollapsible()<CR>
""nmap <leader>mc     :let w:autoCollapsible = 1<CR>

""    space to maximize current window
"nmap <S-space>      :call g:wipeMinimizedState()<CR><C-W>_

"nmap <leader>ml      :call g:wipeMinimizedState()<CR><C-W>_

""    Minimize current window
"nmap <leader>mm    :call g:wipeMinimizedState()<CR><C-W>1_

""    set current window to 8 lines
"nmap <leader>m&    :call g:wipeMinimizedState()<CR><C-W>8_

""    ctrl+shift+space to set current window to 16 lines
"nmap <C-S-space>    :call g:wipeMinimizedState()<CR><C-W>16_

"nmap <leader>mé    :call g:wipeMinimizedState()<CR><C-W>16_

""    ctrl+shift+alt+space to set current window to 32 lines
"nmap <C-S-A-space>    :call g:wipeMinimizedState()<CR><C-W>32_

"nmap <leader>m"    :call g:wipeMinimizedState()<CR><C-W>32_




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

" ---- WINDOW NAVIGATION ---
"
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

" ---- TAB NAVIGATION ---
"
if has('gui_running')
  " [Vim GUI] TAB NAVIGATION
  " alt+arrow left/right in all mode
  map <A-up> :tabfirst<CR>
  map <A-down> :tablast<CR>
  map <A-left> :tabprev<CR>
  map <A-right> :tabnext<CR>
  map <A-k> :tabfirst<CR>
  map <A-j> :tablast<CR>
  map <A-h> :tabprev<CR>
  map <A-l> :tabnext<CR>
endif

" [terminal vim] open new TAB in LAST position
map <localleader>t :$tabnew<CR>
map <localleader>w :$tabclose<CR>
map <localleader>j :tabfirst<CR>
map <localleader>k :tablast<CR>
map <localleader>h :tabprev<CR>
map <localleader>l :tabnext<CR>

" ---- OTHER NAVIGATION ---
"
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

"" remap jf to ESC in modes that don't use the 'j' key for navigation
"" (insert, command, operator-pending)
imap jf <C-c>
cmap jf <C-c>
imap fj <C-c>
cmap fj <C-c>

" and in visual mode : space
vmap <space> <C-c>


"1}}}
"--------SEARCH------------------------{{{1

" Easy clear search : ,/
nmap <silent> <leader>/ :nohlsearch<CR>
" french keyboard : ,; easier than ,/
nmap <silent> <leader>; :nohlsearch<CR>


" map control-backspace to delete the previous word in edit mode
"imap <C-BS> <C-W>

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
"--------empty-buffers----------------{{{1

" these are i$ VIMHOME/ftplugin/help.vim
" (mappings specific to help buffer for easy navigation)

nmap <leader>bc        :call g:CleanEmptyBuffers()<CR>

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
" Quickly edit/reload the hydra file (MacOS windows manager)
nmap <silent> <leader>eh :call UnSymLinkEdit($HOME . "/.hydra/init.lua")<CR>
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
"--------GF open file in new window --{{{1

"map gf :e <cfile><CR>

" even better : in a vertical split
map gf :vertical wincmd f<CR>

"1}}}
"--------Edit ------------------------{{{1

map <S-Enter> O<ESC> " awesome, inserts new line without going into insert mode


"1}}}
"--------Create TMP buffer-tab IDfile--{{{1
"

"function! g:tartify_list(arg)
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
"endfunction




map ,NN :!createIDfile %<CR>

"1}}}
" ---(clj)vim-clojure-static ---------{{{1
"
"
""let vimclojure#SplitPos = "right"
""let vimclojure#SplitSize = 30
"let g:vimclojure#HighlightBuiltins = 1
"let g:vimclojure#ParenRainbow = 1
"
"
"" from https://groups.google.com/forum/?fromgroups=#!topic/vimclojure/4a1q8czmL8Q
"if exists("*PareditInitBuffer")
"  call PareditInitBuffer()
"endif



"1}}}
" ---(clj)rainbow-parentheses --------{{{1
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
nmap <leader>ll   :LustyJuggler<CR>

"" suppress LustyJuggler ruby warning
"let g:LustyJugglerSuppressRubyWarning = 1

"1}}}
"---------LustyExplorer------------------{{{1
"
"nothing to do. Mappings are :
"
"  <Leader>lf  - Opens filesystem explorer.
"  <Leader>lr  - Opens filesystem explorer at the directory of the current file.
"  <Leader>lb  - Opens buffer explorer.
"  <Leader>lg  - Opens buffer grep.
"
"1}}}
"---------Syntastic-------------------{{{1

" Map :Errors command to <leader>E
nmap <leader>E  :Errors<CR>

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
nmap <leader><c-y> :YRClear<CR>
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

"let g:session_autosave=1
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
nmap <leader>T :TagbarToggle<CR>
"nmap <leader><C-t> :TagbarToggle<CR>

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
" ---------xptemplate-----------------{{{1


let g:xptemplate_key = '<s-Tab>'
"let g:xptemplate_key = '<c-space>'


"1}}}
" ---------FencView (encoding)--------{{{1
"
" Great ENCODING TOOL
"

" Open the ENCODING CHOOSER menu
nnoremap <leader><C-e>   :FencView<CR>
"1}}}
" ---------LINE NUMBERING----------------{{{1
"
" Toggle relative line numbering on/off
" Video tutorial http://myusuf3.github.com/numbers.vim/

nnoremap <F3> :NumbersToggle<CR>

"1}}}
" ---------TABULAR (text align)-------{{{1
"
" Just a shortcut
"

nnoremap <leader><C-t>   :Tabularize /
"1}}}
" ---------GOLDEN RATIO (resize)---------{{{1
"
" Resize current wiondow to Golden Ration Proportions
"

" Enable autocommand (enabled by default) on GUI Vim
" (gvim, macvim,...)

"if has('gui_running')
  "let g:golden_ratio_autocommand = 0
"endif

let g:golden_ratio_autocommand = 0
"And map autoresize toggle to a F key:
nnoremap <S-F5> :GoldenRatioToggle<CR>

" This would disable the plugin globally
"let g:loaded_golden_ratio = 0

"1}}}
" ---------DBGPavim (PHP debug)---------{{{1

"let g:dbgPavimKeyHelp = '<F1>'
"let g:dbgPavimKeyStepInto = '<F2>'
"let g:dbgPavimKeyStepOver = '<F3>'
"let g:dbgPavimKeyStepOut = '<F4>'
"let g:dbgPavimKeyRun = '<F5>'
"let g:dbgPavimKeyQuit = '<F6>'
"let g:dbgPavimKeyEval = '<F7>'
"let g:dbgPavimKeyRelayout = '<F9>'
"let g:dbgPavimKeyToggleBae = '<F8>'
"let g:dbgPavimKeyToggleBp = '<F10>'
"let g:dbgPavimKeyContextGet = '<F11>'
"let g:dbgPavimKeyPropertyGet = '<F12>'

let g:dbgPavimKeyHelp = '<leader>&'
let g:dbgPavimKeyStepInto = '<leader>é'
let g:dbgPavimKeyStepOver = '<leader>"'
let g:dbgPavimKeyStepOut = "<leader>'"
let g:dbgPavimKeyRun = '<leader>('
let g:dbgPavimKeyQuit = '<leader>§'
let g:dbgPavimKeyEval = '<leader>è'
let g:dbgPavimKeyRelayout = '<leader>!'
let g:dbgPavimKeyToggleBae = '<leader>ç'
let g:dbgPavimKeyToggleBp = '<leader>à'
let g:dbgPavimKeyContextGet = '<leader>1'
let g:dbgPavimKeyPropertyGet = '<leader>2'



"1}}}
" ---------JEKYLL (blog engine)--------{{{1
let g:jekyll_post_template =  [
  \ '---',
  \ 'layout: post',
  \ 'title: "JEKYLL_TITLE"',
  \ 'categories: "[category1, category2]"',
  \ 'tags: "[tag1,tag2]"',
  \ 'intro-img: "<img alt=\"pain-in-the-ass\" src=\"http://barkingcode.peterhost.fr/img/covers/date-covername.jpg\"/>"',
  \ 'intro: "Short Description<br/><br/><strong>Use Case:</strong> define use case"',
  \ '---',
  \ '']

"1}}}
" ---------python-mode------------------{{{1


" Automatically fix PEP8 errors in the current buffer:
" (overwrite the general purpuse autoindent defined earlier)
autocmd FileType python      noremap <F8> :PymodeLintAuto<CR>

"" Automatically fix PEP8 errors in the current buffer
"" when saving:
"if has("autocmd")
"    autocmd BufWritePost *.py !autopep8 -i expand("%")
"endif

let g:pymode_lint_mccabe_complexity = 20
let g:pymode_rope = 0
"1}}}
" ---------mini-bufexplorer-------------{{{1

let g:miniBufExplAutoStart = 0 " only open with key mappings
map <Leader>aa :MBEToggle <CR>:MBEFocus <CR>
map <Leader>az :MBEFocus <CR>
let g:miniBufExplVSplit = 20   " column width in chars
"1}}}


"------------------------------------------------------------------------------
"                    MACOS SPECIFIC APPS
"------------------------------------------------------------------------------

" --------Marked(MD preview)-----------{{{1

if has("macunix")
  "" ne marche plus pour je ne sais quelle raison 2014-12-22
  ":nnoremap <leader>P :silent !open -a Marked\ 2.app '%:p'<cr>
  "" employer cela à la place :
  :nnoremap <leader>P :silent !open -a /Applications/Marked\ 2.app '%:p'<cr>
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
