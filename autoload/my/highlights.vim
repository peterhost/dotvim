" autoload/my/highlights.vim — surlignages maison
"
"   ExtraWhitespace   espaces en fin de ligne (rouge ; discret en markdown,
"                     où deux espaces finaux = retour à la ligne)
"   InappropriateTabs tabulations ailleurs qu'en début de ligne
"   OverLength        texte au-delà de la 80e colonne (désactivé par défaut :
"                     :LongLinesToggle)
"
" Les motifs sont posés par fenêtre avec matchadd() et retirés proprement
" (l'ancien vimrc empilait des :match à chaque changement de buffer).

" Couleurs, recalculées à chaque changement de thème (selon le fond).
function! my#highlights#define()
  let l:light = &background ==# 'light'
  highlight ExtraWhitespace ctermbg=red guibg=#d75f5f
  highlight ExtraWhitespaceSoft ctermbg=gray guibg=#a8a8a8
  if l:light
    highlight InappropriateTabs ctermbg=darkred ctermfg=white guibg=#e1d9bf
    highlight OverLength ctermbg=red ctermfg=white guibg=#efe9d6
  else
    highlight InappropriateTabs ctermbg=darkred ctermfg=white guibg=#431616
    highlight OverLength ctermbg=red ctermfg=white guibg=#592929
  endif
endfunction

function! s:prose()
  return &filetype =~# '^\(markdown\|text\|mail\|gitcommit\)$'
endfunction

" (Re)pose les motifs de la fenêtre courante. `insert` : ne pas signaler les
" espaces juste avant le curseur pendant la frappe.
function! my#highlights#apply(insert)
  if !exists('*matchadd')
    return
  endif
  for l:id in get(w:, 'my_match_ids', [])
    silent! call matchdelete(l:id)
  endfor
  let w:my_match_ids = []
  if &buftype !=# '' || &filetype ==# 'help'
    return
  endif
  let l:ws = a:insert ? '\s\+\%#\@<!$' : '\s\+$'
  if s:prose()
    " en prose, seuls 1 ou 3+ espaces finaux sont suspects (2 = saut de ligne)
    call add(w:my_match_ids, matchadd('ExtraWhitespaceSoft',
          \ '\S\zs\(\s\|\s\{3,}\)' . (a:insert ? '\%#\@<!' : '') . '$', -1))
  else
    call add(w:my_match_ids, matchadd('ExtraWhitespace', l:ws, -1))
    call add(w:my_match_ids, matchadd('InappropriateTabs', '[^\t]\zs\t\+', -1))
  endif
  if get(g:, 'my_longlines', 0) && &filetype !=# 'csv'
    call add(w:my_match_ids, matchadd('OverLength', '\%81v.\+', -1))
  endif
endfunction

function! my#highlights#toggle_longlines()
  let g:my_longlines = !get(g:, 'my_longlines', 0)
  let l:win = winnr()
  windo call my#highlights#apply(0)
  execute l:win . 'wincmd w'
  echo 'Lignes > 80 colonnes : ' . (g:my_longlines ? 'signalées' : 'ignorées')
endfunction
