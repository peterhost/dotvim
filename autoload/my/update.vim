" autoload/my/update.vim — mise à jour des plugins en arrière-plan
"
" Au démarrage, si la dernière mise à jour date de plus de g:my_autoupdate_days
" jours (7 par défaut, 0 = jamais), bin/update-plugins est lancé détaché :
" il ne ralentit ni ne bloque vim. Les nouvelles versions sont utilisées au
" démarrage suivant. :PluginsUpdateLog affiche le journal.

function! my#update#start()
  let l:days = get(g:, 'my_autoupdate_days', 7)
  " git peut être hors du PATH (Synology : /opt/bin) : le script le retrouve
  let l:git = executable('git') || executable('/opt/bin/git') || executable('/usr/local/bin/git')
  if l:days <= 0 || !empty($MY_VIM_NO_AUTOUPDATE) || !l:git
        \ || !executable('sh') || g:my_is_win
    return
  endif
  " le même vim que celui en cours, pour installer ce qui lui convient
  let l:vim = exists('v:progpath') && !empty(v:progpath) ? v:progpath : 'vim'
  let l:cmd = ['env', 'VIM_BIN=' . l:vim, 'MY_VIM_LOCAL=' . g:my_local,
        \ 'sh', g:my_dir . '/bin/update-plugins', '--if-due', string(l:days)]
  if exists('*job_start')
    " job détaché de vim : continue même si vim est fermé entre-temps
    call job_start(l:cmd, {'stoponexit': '', 'in_io': 'null', 'out_io': 'null', 'err_io': 'null'})
  elseif has('unix')
    " vieux vim sans jobs : lancé en arrière-plan par le shell
    call system(join(map(l:cmd, 'shellescape(v:val)'), ' ') . ' >/dev/null 2>&1 &')
  endif
endfunction

" Au démarrage : si la dernière mise à jour a échoué, le dire une fois (le
" message reste dans :messages), avec le conseil éventuel.
function! my#update#notify(...)
  let l:status = g:my_local . '/update-status'
  let l:seen = g:my_local . '/update-status.seen'
  if !filereadable(l:status) || getftime(l:status) <= getftime(l:seen)
    return
  endif
  let l:lines = readfile(l:status)
  if empty(l:lines) || l:lines[0] !~# '^fail'
    return
  endif
  let l:n = matchstr(l:lines[0], '\d\+')
  echohl WarningMsg
  echomsg 'Plugins : la dernière mise à jour a échoué'
        \ . (l:n !=# '' ? ' pour ' . l:n . ' plugin(s)' : '') . ' — détails : :PluginsUpdateLog'
  for l:line in l:lines
    if l:line =~# '^conseil: '
      echomsg '  ' . substitute(l:line, '^conseil: ', '', '')
    endif
  endfor
  echohl None
  silent! call writefile([], l:seen)
endfunction
