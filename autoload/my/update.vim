" autoload/my/update.vim — mise à jour des plugins en arrière-plan
"
" Au démarrage, si la dernière mise à jour date de plus de g:my_autoupdate_days
" jours (7 par défaut, 0 = jamais), bin/update-plugins est lancé détaché :
" il ne ralentit ni ne bloque vim. Les nouvelles versions sont utilisées au
" démarrage suivant. :PluginsUpdateLog affiche le journal.

function! my#update#start()
  let l:days = get(g:, 'my_autoupdate_days', 7)
  if l:days <= 0 || !empty($MY_VIM_NO_AUTOUPDATE) || !executable('git')
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
