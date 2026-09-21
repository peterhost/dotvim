" autoload/my/buffers.vim — buffers et fichiers

" Supprime les buffers vides et sans nom qui ne sont affichés nulle part.
function! my#buffers#clean_empty()
  let l:buffers = filter(range(1, bufnr('$')),
        \ 'buflisted(v:val) && empty(bufname(v:val)) && bufwinnr(v:val) < 0')
  if !empty(l:buffers)
    execute 'bwipeout ' . join(l:buffers, ' ')
  endif
endfunction

" Ferme le buffer sans fermer la fenêtre (vim-bclose si présent).
function! my#buffers#close()
  if exists(':Kwbd') == 2
    Kwbd
  elseif exists(':Bclose') == 2
    Bclose
  else
    let l:buf = bufnr('%')
    if buflisted(bufnr('#'))
      buffer #
    else
      enew
    endif
    execute 'silent! bdelete ' . l:buf
  endif
endfunction

" Ouvre le vrai fichier derrière un lien symbolique.
function! my#buffers#edit_real(path)
  execute 'edit ' . fnameescape(resolve(expand(a:path)))
endfunction

" Documentation perl du mot sous le curseur, ou du module sur une ligne use/require.
function! my#buffers#perldoc()
  let l:line = getline('.')
  if l:line =~# '^\s*\(use\|require\)\s'
    let l:args = '-t ' . matchstr(l:line, '^\s*\(use\|require\)\s\+\zs[^ ;]\+')
  else
    let l:args = '-t -f ' . expand('<cword>')
  endif
  new
  execute 'silent 0read !perldoc ' . l:args
  setlocal nomodified buftype=nofile bufhidden=wipe filetype=man
  normal! gg
endfunction

" Ouvre la session enregistrée le plus récemment (local/sessions/).
function! my#buffers#last_session()
  let l:last = ''
  for l:f in split(glob(g:my_local . '/sessions/*'), '\n')
    if l:last ==# '' || getftime(l:f) > getftime(l:last)
      let l:last = l:f
    endif
  endfor
  if l:last ==# ''
    echo 'Aucune session enregistrée (,ws pour en suivre une)'
    return
  endif
  execute 'source ' . fnameescape(l:last)
  echo 'Session ouverte : ' . fnamemodify(l:last, ':t')
endfunction
