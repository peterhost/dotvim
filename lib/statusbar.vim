"------------------------------------------------------------------------------
" STATUS BAR
"------------------------------------------------------------------------------
" http://got-ravings.blogspot.com/2008/08/vim-pr0n-making-statuslines-that-own.html
" http://got-ravings.blogspot.com/2008/10/vim-pr0n-statusline-whitespace-flags.html
" http://www.reddit.com/r/vim/comments/e19bu/whats_your_status_line/


" First, define some colors

"define (up to 9) custom highlight groups (mandatory name : UserN)
hi User1 ctermbg=darkgreen ctermfg=darkred   guibg=green guifg=red
"hi User1 ctermbg=green ctermfg=red   guibg=green guifg=red
hi User2 ctermbg=darkgrey   ctermfg=darkblue guibg=darkgrey guifg=darkblue
hi User3 ctermbg=blue  ctermfg=green guibg=blue  guifg=green

" use them with %N* : %1*, %2*,...
"set statusline+=%1*  "switch to User1 highlight







" {{{ Nice statusbar
"statusline setup
set statusline=

"marker for minimized window
set statusline+=%1*
set statusline+=%{IsMinimized()}
set statusline+=%*

set statusline+=%f       "tail of the filename

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
set statusline+=%r      "read only flag
set statusline+=%m      "modified flag

"" display current git branch
"set statusline+=%2*
"set statusline+=%{fugitive#statusline()}
"set statusline+=%*

" display __git_ps1
set statusline+=%2*
set statusline+=%{StatuslineGitps1()}
set statusline+=%*

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

set statusline+=%=      "left/right separator
set statusline+=%{StatuslineCurrentHighlight()}\ \ "current highlight
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file
set laststatus=2        " Always show status line


"visual marker if minimized window
function! IsMinimized()
  if winheight(0) <= &winminheight
    return '[↓]'
  else
    return ''
  endif
endfunction


"bash's git_ps1's wrapper
function! StatuslineGitps1()
  "caching
  if !exists("b:statusline_gitps1_prompt")
    let b:statusline_gitps1_prompt = system( "__git_prompt_vim " .  shellescape(expand('%:p')) )
  endif

  "no a git repo
  if b:statusline_gitps1_prompt == ""
    return ""
  " git repo and unexpected error (report please)
  elseif !v:shell_error == 0
    return " -ERROR- "
  "git repo, all fine
  else
    "BRANCH
    "   branchname
    "EXTRAS
    "   Count Strings
    "     (-nb)
    "     (+nb)
    "   Working Dir Symbols
    "     * unstaged changes
    "     + staged changes
    "     % untracked files
    "     ^ stashed files
    "TIME LAST COMMIT
    "   [xd,xh,xm]

    let b:tmp_str = ""
    let b:statusline_gitps1_result = ""
    for b:tmp_str in split(b:statusline_gitps1_prompt, '|')
      " Count String
      if match(b:tmp_str, '[+-]\d') >= 0
        let b:statusline_gitps1_result .= b:tmp_str
      " Time of last Commit
      elseif match(b:tmp_str, '\[[^\]]\+\]') >= 0
        let b:statusline_gitps1_result .= b:tmp_str
      " Working dir symbols
      elseif match(b:tmp_str, '[*+%\^]\+') >= 0
        let b:statusline_gitps1_result .= b:tmp_str
      " Branch Name
      elseif match(b:tmp_str, '[\w\s]\+') >= 0
        let b:statusline_gitps1_result .= b:tmp_str
      endif

      "let b:statusline_gitps1_result .= b:tmp_str
    endfo

  endif

  return b:statusline_gitps1_result . " - " . b:statusline_gitps1_prompt
endfunction


"Better wrapper using FUGITIVE
function! StatuslineGit()
  if !exists('b:git_dir')
    return ''
  endif
endfunction

"recalculate the Gitps1 when idle, and after saving
autocmd cursorhold,CursorHoldI,bufwritepost,InsertLeave,WinEnter,WinLeave * unlet! b:statusline_gitps1_prompt








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



