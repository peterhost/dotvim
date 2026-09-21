" autoload/my/edit.vim — fonctions d'édition (reprises de l'ancien vimrc)

" --- Espaces en fin de ligne ---------------------------------------------------------
" En markdown/texte, deux espaces finaux forcent un retour à la ligne : on
" les garde, et on ne retire que 1 ou 3+ espaces (et les lignes blanches).
function! my#edit#strip_whitespace(line1, line2)
  let l:view = winsaveview()
  let l:search = @/
  if &filetype =~# '^\(markdown\|text\|mail\)$'
    let l:pattern = '\(\S\zs\(\s\|\s\{3,}\)\|^\s\+\)$'
  else
    let l:pattern = '\s\+$'
  endif
  silent! execute a:line1 . ',' . a:line2 . 's/' . l:pattern . '//e'
  let @/ = l:search
  call winrestview(l:view)
endfunction

" --- Déplacer des lignes (source : vim.wikia.com, VimTip191) ------------------------------
function! s:move(range, target)
  let l:col = virtcol('.')
  silent! execute a:range . 'move ' . a:target
  execute 'normal! ' . l:col . '|'
endfunction

" nombre de lignes : le préfixe numérique du raccourci (au moins 1 ; vim 7.3
" donne 0 hors d'un raccourci)
function! s:count()
  return max([v:count1, 1])
endfunction

function! my#edit#move_line(dir)
  if a:dir < 0
    call s:move('', max([line('.') - s:count() - 1, 0]))
  else
    call s:move('', min([line('.') + s:count(), line('$')]))
  endif
endfunction

function! my#edit#move_selection(dir)
  if a:dir < 0
    call s:move("'<,'>", max([line("'<") - s:count() - 1, 0]))
  else
    call s:move("'<,'>", min([line("'>") + s:count(), line('$')]))
  endif
  normal! gv
endfunction

" --- Casse : minuscules -> Capitalisées -> MAJUSCULES -> minuscules ------------------------
function! my#edit#twiddle_case(str)
  if a:str ==# toupper(a:str)
    return tolower(a:str)
  elseif a:str ==# tolower(a:str)
    return substitute(a:str, '\(\<\w\+\>\)', '\u\1', 'g')
  endif
  return toupper(a:str)
endfunction

" --- Recherche de la sélection visuelle (* et #) et vimgrep (gv) ----------------------------
function! my#edit#visual_search(direction)
  let l:saved = @"
  normal! gvy
  let l:pattern = '\V' . substitute(escape(@", '\/'), '\n', '\\n', 'g')
  let @" = l:saved
  let @/ = l:pattern
  call histadd('/', l:pattern)
  if a:direction ==# 'grep'
    call feedkeys(':vimgrep /' . l:pattern . '/ **/*.', 'n')
    return
  endif
  call search(l:pattern, a:direction ==# 'b' ? 'b' : '')
  if exists('v:hlsearch')
    let v:hlsearch = 1
  endif
endfunction

" --- Tableaux markdown alignés à la frappe de | (tabular) ----------------------------------
" Source : tpope, https://gist.github.com/287147
function! my#edit#align_table()
  let l:p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|'
        \ && (getline(line('.') - 1) =~# l:p || getline(line('.') + 1) =~# l:p)
    let l:column = strlen(substitute(getline('.')[0:col('.')], '[^|]', '', 'g'))
    let l:position = strlen(matchstr(getline('.')[0:col('.')], '.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|', l:column) . '\s\{-\}' . repeat('.', l:position), 'ce', line('.'))
  endif
endfunction
