"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
"       Filename:  statusbar.vim
"
"    Description:  STATUS LINE with GIT support
"
"                  Colored status line adapted to GIT repository. VERY
"                  colorfull, not for the faint hearted
"
"  Configuration:  source this file in your .vimrc
"
"                     source /path/to/statusbar.vim
"
"   Dependencies:  REQUIRED : you need to have the "bashps1" file
"                  sourced in your ".bashrc" or ".bash_profile", as this
"                  vimscript calls external shell functions it depends
"                  on
"
"                  Depends on GIT, might work on windows with Cygwin

"
"   GVIM Version:  1.7+ (?)
"
"         Author:  Pierre Lhoste
"        Twitter:  http://twitter.com/peterhost
"
"        Version:  0.1
"        Created:  01.05.2011
"        License:  WTFPL V2
"
" DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE Version 2, December 2004
"
" Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>
"
" Everyone is permitted to copy and distribute verbatim or modified
" copies of this license document, and changing it is allowed as long as
" the name is changed.
"
"            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE TERMS AND
"            CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
"
"  0. You just DO WHAT THE FUCK YOU WANT TO.
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""



"-------------------------------TRIVIA-----------------------------------------
" Authoritative References in the matter of Status Line for Vim :
" http://got-ravings.blogspot.com/2008/08/vim-pr0n-making-statuslines-that-own.html
" http://got-ravings.blogspot.com/2008/10/vim-pr0n-statusline-whitespace-flags.html
" http://www.reddit.com/r/vim/comments/e19bu/whats_your_status_line/
"------------------------------------------------------------------------------



" -------- Preliminay Checks ----------{{{1
" Check if we should continue loading
"if exists( "loaded_tartify" )
"  finish
"endif
"let loaded_tartify= 1


function! s:errmsg(msg)
  echohl ErrorMsg
  echo a:msg
  echohl None
endfunction



" Bail if Vim isn't compiled with status line support.
if has( "statusline" ) == 0
  call s:errmsg("Tartify requires Vim to have +statusline support.")
  finish
endif


"TODO: DO that with an ENV variable, STUPID!
" Bail if we can't find our friggin shell functions
let s:tartifyTestShell = [ "__gitps1_branch",
                         \ "__gitps1_remote",
                         \ "__gitps1_repo_name",
                         \ "__gitps1_stash"
                         \  ]
for s:test in s:tartifyTestShell
  if system("type " . s:test . " >/dev/null 2>&1; echo $?") == 1
    call s:errmsg("shell function " . s:test . " not found. Not loading Tartify")
    finish
  endif
endfo







"1}}}


" -------- User Defined Colors --------{{{1
" -------- StatusLine TARTIFICATION ----{{{2
" --------------------------------------------------------------------------
"
" PROBLEM1: When coloring Vim's StatusLine, we have two options :
"
"     - Use predefined (default) Highlight Groups and hope the
"     "Tartification" is not too extreme
"
"     - Define our own User{N} highlight groups
"
" PROBLEM2: However hard you try, you always break the default
"           statusline's background color, creating UGLY HOLES in it
"           that break its visual continuity, hence destroying it's
"           "STATUSLINE-NESS"
"
" PROBLEM3: When using standard Highlight groups, there is no way of
"           handling the fact that the background color for the
"           statusline changes according to the window being current or
"           not (StatusLine & StatusLineNC). On the other hand,
"           "User{N}" highlight groups handle that automatically
"           (:helpg The difference between User{N})
"
" SOLUTION: Define "User{N}" highlight groups which adapt to
"
"  - Dark/Light background (maximize our chances of them looking good
"    everywhere)
"
"  - Use the current Colorcheme's own predefined StatusLine parameters
"    (especially background color) for our custom "User{N}" highlight
"    groups
"
"
" WARN: BIG GOTCHA
"       if the StatusLine Highlight contains :
"         - term=reverse
"         - cterm=reverse
"         - gui=reverse
"        the termfg/termbg, ctermfg/ctermbg, and guifg/guibg couples
"        have to be substituted one for another
"
"

"We need to be able to change the text's color on the statusline without
"modifying the background. As we need to do that with "User defined"
"Highlights, we need to store :
" - active window's number
" - current Colorscheme's StatusLine color
" - current Colorscheme's StatusLineNC color



"2}}}
" -------- Leech current ColorScheme --{{{2

"autocmd WinEnter * let s:activeWindow = winnr()
"autocmd Colorscheme * let g:currWinSLg = synIDattr(synIDtrans(hlID("StatusLine")), "bg")
"autocmd Colorscheme * let g:currWinSLgNC =  synIDattr(synIDtrans(hlID("StatusLineNC")), "bg")
"let s:activeWindow = winnr()
let g:currWinSLg =              synIDattr(synIDtrans(hlID("StatusLine")), "bg")
let g:currWinSLgNC =            synIDattr(synIDtrans(hlID("StatusLineNC")), "bg")


autocmd Colorscheme * let g:HighlightCurrStatusLine = synIDattr(synIDtrans(hlID("StatusLine")), "bg")
call Decho(g:currWinSLg . " - " g:currWinSLgNC)

" term=bold,reverse cterm,bold,reverse gui=bold,reverse guifg=#586e75 guibg=#eee8d5

let s:listSynIDattrWhat = ["name","fg","bg","font","sp","fg#","bg#","sp#","bold","italic",
                          \"reverse","inverse","standout","underline","undercurl"]
let s:listSynIDattrMode = ["term", "cterm", "gui"]

for s:tmpMode in s:listSynIDattrMode
  for s:tmpWhat in s:listSynIDattrWhat
    let s:tmpStyle =   synIDattr(synIDtrans(hlID("StatusLine")), s:tmpWhat, s:tmpMode)
    if s:tmpStyle
      call Decho(s:tmpMode . s:tmpWhat . "=" . s:tmpStyle)
    endif
  endfo
endfo


"call s:errmsg(synIDtrans(hlID("StatusLine")))
call Decho("--------------end--------------")
"call Decho(synIDattr(synIDtrans(hlID("StatusLine")), "bg")






"2}}}
" -------- Auto-Update User{N} --------{{{2
let s:customColors= []

function! s:lightVSdark()
  " get the window's current StatusLine & StatusLineNC Background highligths

  if &background == "light"
    let l:customColors= [
        \"hi User1 ctermbg=darkgreen ctermfg=darkred   guibg=darkgreen guifg=red",
        \"hi User2 ctermbg=darkgrey   ctermfg=darkblue guibg=darkgrey guifg=darkblue",
        \"hi User8 ctermbg=darkgrey   ctermfg=darkblue guibg=" . g:currWinSLg . " guifg=lightred",
        \"hi User9 ctermbg=darkgrey   ctermfg=darkblue guibg=" . g:currWinSLgNC . " guifg=lightred"
        \]
  else
    let l:customColors = [
        \"hi User1 ctermbg=darkgreen ctermfg=darkred   guibg=darkgreen guifg=red",
        \"hi User2 ctermbg=darkgrey   ctermfg=darkblue guibg=darkgrey guifg=darkblue",
        \"hi User8 ctermbg=darkgrey   ctermfg=darkblue guibg=" . g:currWinSLg . " guifg=darkred",
        \"hi User9 ctermbg=darkgrey   ctermfg=darkblue guibg=" . g:currWinSLgNC . " guifg=darkred"
        \]
  endif

  " load 'em
  for l:thisHilight in s:customColors
    execute l:thisHilight
  endfo
endfunction



" Shit happens -> Persist custom colors through shit
if has("autocmd")
  autocmd ColorScheme * call s:lightVSdark()
endif
call s:lightVSdark()


"2}}}





"WARN: A VIRER!!
hi User8 term=bold,reverse cterm=bold,reverse gui=bold,reverse guifg=#586e75 guibg=#ff7917




"1}}}
" -------- StatusLine directives ------{{{1
"
" help  *statusline*
" help  *filename-modifiers*

"statusline setup
set statusline=

"marker for minimized window
set statusline+=%5*
set statusline+=%{IsMinimized()}
set statusline+=%*

"set statusline+=%f       "tail of the filename
set statusline+=%.30{CleverInsert('%t')}

"display a warning if fileformat isnt unix
set statusline+=%#warningmsg#
set statusline+=%{&ff!='unix'?'['.&ff.']':''}
set statusline+=%*

"display a warning if file encoding isnt utf-8
set statusline+=%#warningmsg#
set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}
set statusline+=%*

set statusline+=%h      "help file flag

set statusline+=%y      "filetype
"set statusline+=%{strlen(&ft)?&ft:'ZOMG'}
set statusline+=%8*
set statusline+=%y


"set statusline+=%{CleverInsert('%y')}      "filetype
"set statusline+=%{CleverInsert('%y','TOTO')}      "filetype
set statusline+=%r      "read only flag
set statusline+=%#warningmsg#
set statusline+=%m      "modified flag
"set statusline+=%{CleverInsert('%m')}      "modified flag
set statusline+=%*


"" display current git branch
"set statusline+=%2*
"set statusline+=%{fugitive#statusline()}
"set statusline+=%*


set statusline+=%#ModeMsg#
set statusline+=%{StatuslineGitTartify('repository')}

" here I wished to reproduct the colored approach to showing the
" 'extras' (unstaged files, uncommited changes,...) in a colored
" way, as is done in the bashps1 shell script, instead of using
" the usual *+%^ symbols usual in GIT_PS1, as I never can
" remember which is which.
" So this too will be "**Tartified**"
"
set statusline+=%#DiffAdd#
set statusline+=%{StatuslineGitTartify('branch','unstaged')}
set statusline+=%{StatuslineGitTartify('branch','unstagedWithUntracked')}
set statusline+=%{StatuslineGitTartify('branch','uncommited')}
set statusline+=%{StatuslineGitTartify('branch','TOTOLESALAUD')}
set statusline+=%{StatuslineGitTartify('branch','uncommitedWithUntracked')}
set statusline+=%{StatuslineGitTartify('branch','unpushed')}
set statusline+=%{StatuslineGitTartify('branch','unpushedWithUntracked')}
set statusline+=%{StatuslineGitTartify('branch','ok')}
set statusline+=%{StatuslineGitTartify('branch','okWithUntracked')}

set statusline+=%#DiffText#
set statusline+=%{StatuslineGitTartify('remotes')}

set statusline+=%#NonText#
set statusline+=%{StatuslineGitTartify('stash')}

set statusline+=%*

        "        > this will return a "M" symbol which will be prepended
        "          to the branchname
        "
        "         "unmerged"

"
" 25 ITEMS LEFT
"

"display a warning if &et is wrong, or we have mixed-indenting
set statusline+=%#error#
set statusline+=%{StatuslineTabWarning()}
set statusline+=%*

set statusline+=%{StatuslineTrailingSpaceWarning()}

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

"display a warning if &paste is set
set statusline+=%#error#
set statusline+=%{&paste?'[paste]':''}
set statusline+=%*



if  exists("*SyntasticStatuslineFlag")
"ADDED
  let g:syntastic_stl_format = '[%E{Err: %fe #%e}%B{, }%W{Warn: %fw #%w}]'
  set statusline+=%#warningmsg#
  set statusline+=%{SyntasticStatuslineFlag()}
  set statusline+=%*
endif


set statusline+=%=      "left/right separator
set statusline+=%{StatuslineLongLineWarning()}
set statusline+=%{StatuslineCurrentHighlight()}\ \ "current highlight
set statusline+=%9*     "custom color 9
set statusline+=%c     "cursor column
set statusline+=%*,      "reset color
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file
set laststatus=2        " Always show status line

"1}}}
" -------- Functions ------------------{{{1


" Only way I've found to gather in one function a branching condition
" for the displaying of the %f,%h,... items in the statusline. Not
" optimal, but does the job

let s:buffNameToAvoid = '__Tag_List__\|COMMIT_EDITMSG'

"TODO: try use the ":~" modifier for path pattern
function! CleverInsert(expandme, ...)
  let l:fname = expand("%f")
  if match(l:fname, s:buffNameToAvoid) >= 0
    return ""
  endif

  "if expand('%H') >= 0
  ""if expand("%H") == "HLP" && a:1 == "TOTO"
  " return "HLP&" . expand("%H") . "]"
  "endif

  "help  *filename-modifiers*
  "return strpart(expand( "%:f" ) . " ", 0, 30)
  return expand( a:expandme ) . " "
endfunction






"visual marker if minimized window
function! IsMinimized()
  if winheight(0) <= &winminheight
    return '[↓]'
  else
    return ''
  endif
endfunction






function! StatuslineGitTartify(item, ...)

  let l:fname = expand("%f")
  if match(l:fname, s:buffNameToAvoid) >= 0
    return ""
  endif

  " CACHING
  " as the pr0n master once said, "we gawts to cache"
  " (all this calling external bash function is resource intensive and
  " suboptimall too)
  if !exists("b:statusline_tartify_repo")
    let l:cdlocaldir = "cd `dirname " . shellescape(expand('%:p')) . "`; "
    "
    " These shell functions have to exist in Vim's environment
    " ie : you have sourced "/bin/bashps1" in your bashrc
    "
    " nota:
    "
    " 1) the "TRUE" arguments passed to the shell functions tell them
    " to strip the ANSI color codes they throw by default for the PS1,
    " from the return value
    "
    " 2) the second "TRUE" argument taken by __gitps1_branch tells it
    " to also return additional infos about the branch (unstaged
    " files,...)
    "
    let b:statusline_tartify_repo     = system( l:cdlocaldir . "__gitps1_repo_name TRUE")
    let b:statusline_tartify_branch   = system( l:cdlocaldir . "__gitps1_branch TRUE TRUE"   )
    let b:statusline_tartify_remotes  = system( l:cdlocaldir . "__gitps1_remote TRUE"  )
    let b:statusline_tartify_stash    = system( l:cdlocaldir . "__gitps1_stash TRUE"    )
  endif

  "PROCESSING
  "
  "no a git repo
  if b:statusline_tartify_repo == ""
    return ""

  "Catchall :unexpected error from shell function (report please)
  elseif !v:shell_error == 0
    return " -ERROR- "

  "git repo, all fine
  else
    if a:item == "repository"
      return b:statusline_tartify_repo
    elseif a:item == "remotes"
      return b:statusline_tartify_remotes
    elseif a:item == "stash"
      return b:statusline_tartify_stash
    elseif a:item == "branch"
      "
      " "branch" calls for a second argument!
      "
      if len(a:000) != 1
        return " -NEED 2nd ARG- "

      " proceed
      else
        let l:branchstate = a:1
        "
        "   l:branchstate can have one of these values :
        "
        "       > each of the following, return the branchname and the
        "         "set laststatus" command will apply a different color
        "         to the result. The resulting status line snippet is
        "         only the branchname + colors
        "
        "
        "         "unstaged",   "unstagedWithUntracked",
        "         "uncommited", "uncommitedWithUntracked",
        "         "unpushed",   "unpushedWithUntracked",
        "         "ok",         "okWithUntracked"
        "
        "
        "        > this will return a "M" symbol which will be prepended
        "          to the branchname
        "
        "         "unmerged"
        "
        "
        "   the return value of shell function __gitps1_branch followed by two
        "   "TRUE" arguments, is of the form :
        "
        "   "$nocolor_info|$branch_name"
        "
        "   where $nocolor_info is a string between 1 and 3 characters:
        "
        "     nocolor_info = "(S|C|P|O)(U)?(M)?"
        "
        "         S "unstaged", C "uncommited", P "unpushed", O "allisOK",
        "         U "untracked", M "unmerged"
        "
        "

         let l:arglist =
                     \"unstaged|unstagedWithUntracked|
                     \uncommited|uncommitedWithUntracked|
                     \unpushed|unpushedWithUntracked|
                     \ok|okWithUntracked|
                     \unmerged"
        if  !match(l:branchstate, l:arglist)
          return "BAD arg" . l:branchstate
        else
            " 1) separate $nocolor_info from $branch_name
          let l:args = split(b:statusline_tartify_branch, '|')

          " 2) split $nocolor_info
          let l:commit_status     = ""
          let l:untracked_status  = ""
          let l:unmerged_status   = ""

          for b:tmp_str in split(l:args[0], '\zs')
            if match(b:tmp_str, '^[SCPO]$')
              let l:commit_status = b:tmp_str
            endif
            if match(b:tmp_str, '^U$')
              let l:untracked_status = b:tmp_str
            endif
            if match(b:tmp_str, '^M$')
              let l:unmerged_status = b:tmp_str
            endif
          endfo

          if l:branchstate == "unstaged" && l:commit_status == "S"
            return l:args[1]
          endif
        endif
      endif
    endif
  endif
  return ""

endfunction




"recalculate the Gitps1 when idle, and after saving
autocmd cursorhold,CursorHoldI,bufwritepost * unlet! b:statusline_tartify_repo

"next one too slow for my taste :
"recalculate Gitps1 when idle, after saving, on window change
"autocmd cursorhold,CursorHoldI,bufwritepost,InsertLeave,WinEnter,WinLeave * unlet! b:statusline_tartify_repo







"return the syntax highlight group under the cursor ''
function! StatuslineCurrentHighlight()
    let name = synIDattr(synID(line('.'),col('.'),1),'name')
    if name == ''
        return ''
    else
        return '[' . name . ']'
    endif
endfunction

"recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning

"return '[\s]' if trailing white space is detected
"return '' otherwise
function! StatuslineTrailingSpaceWarning()
    if !exists("b:statusline_trailing_space_warning")
        if search('\s\+$', 'nw') != 0
            let b:statusline_trailing_space_warning = '[\s]'
        else
            let b:statusline_trailing_space_warning = ''
        endif
    endif
    return b:statusline_trailing_space_warning
endfunction

"return '[&et]' if &et is set wrong
"return '[mixed-indenting]' if spaces and tabs are used to indent
"return an empty string if everything is fine
function! StatuslineTabWarning()
    if !exists("b:statusline_tab_warning")
        let tabs = search('^\t', 'nw') != 0
        let spaces = search('^ ', 'nw') != 0

        if tabs && spaces
            let b:statusline_tab_warning =  '[mixed-indenting]'
        elseif (spaces && !&et) || (tabs && &et)
            let b:statusline_tab_warning = '[&et]'
        else
            let b:statusline_tab_warning = ''
        endif
    endif
    return b:statusline_tab_warning
endfunction

"return a warning for "long lines" where "long" is either &textwidth or 80 (if
"no &textwidth is set)
"
"return '' if no long lines
"return '[#x,my,$z] if long lines are found, were x is the number of long
"lines, y is the median length of the long lines and z is the length of the
"longest line
function! StatuslineLongLineWarning()
    if !exists("b:statusline_long_line_warning")
        let long_line_lens = s:LongLines()

        if len(long_line_lens) > 0
            let b:statusline_long_line_warning = "[" .
                        \ '#' . len(long_line_lens) . "," .
                        \ 'm' . s:Median(long_line_lens) . "," .
                        \ '$' . max(long_line_lens) . "]"
        else
            let b:statusline_long_line_warning = ""
        endif
    endif
    return b:statusline_long_line_warning
endfunction

"return a list containing the lengths of the long lines in this buffer
function! s:LongLines()
    let threshold = (&tw ? &tw : 80)
    let spaces = repeat(" ", &ts)

    let long_line_lens = []

    let i = 1
    while i <= line("$")
        let len = strlen(substitute(getline(i), '\t', spaces, 'g'))
        if len > threshold
            call add(long_line_lens, len)
        endif
        let i += 1
    endwhile

    return long_line_lens
endfunction

"find the median of the given array of numbers
function! s:Median(nums)
    let nums = sort(a:nums)
    let l = len(nums)

    if l % 2 == 1
        let i = (l-1) / 2
        return nums[i]
    else
        return (nums[l/2] + nums[(l/2)-1]) / 2
    endif
endfunction


"1}}}
