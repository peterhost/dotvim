" keys.vim — l'aide des raccourcis dans vim (:Keys)
"
" doc/raccourcis.txt est ENGENDRÉ par bin/keys depuis les annotations « "= »
" posées à côté de chaque raccourci (« make keys »). On ne l'écrit pas ici.

function! s:fichier() abort
  return g:my_dir . '/doc/raccourcis.txt'
endfunction

" Les thèmes présents dans l'aide engendrée, lus sur ses balises.
function! my#keys#themes() abort
  let l:f = s:fichier()
  if !filereadable(l:f)
    return []
  endif
  let l:themes = []
  for l:ligne in readfile(l:f)
    let l:t = matchstr(l:ligne, '\*raccourcis-\zs[^*]\+\ze\*')
    if l:t !=# '' && index(l:themes, l:t) < 0
      call add(l:themes, l:t)
    endif
  endfor
  return l:themes
endfunction

function! my#keys#complete(debut, ...) abort
  return filter(my#keys#themes(), 'v:val =~# "^" . a:debut')
endfunction

function! my#keys#show(theme) abort
  let l:f = s:fichier()
  if !filereadable(l:f)
    echohl WarningMsg
    echo 'Aide des raccourcis absente : lancez « make keys » dans ' . g:my_dir
    echohl None
    return
  endif
  let l:themes = my#keys#themes()
  if a:theme !=# '' && index(l:themes, a:theme) < 0
    echohl ErrorMsg
    echo 'Thème inconnu : ' . a:theme . ' — ' . join(l:themes, ', ')
    echohl None
    return
  endif
  let l:tag = a:theme ==# '' ? 'raccourcis' : 'raccourcis-' . a:theme
  " avec les balises, c'est l'aide de vim ; sans elles, le fichier lui-même
  if filereadable(g:my_dir . '/doc/tags')
    try
      execute 'help ' . l:tag
      return
    catch /^Vim\%((\a\+)\)\=:E\%(149\|661\|433\)/
    endtry
  endif
  execute 'split ' . fnameescape(l:f)
  setlocal filetype=help
  call search('\*' . l:tag . '\*', 'cw')
  normal! zt
endfunction
