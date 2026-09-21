" test/probe.vim — sonde lancée par test/run.sh dans chaque vim testé
"
" Variables d'environnement lues :
"   VIMTEST_OUT     fichier de résultats (une ligne PASS/FAIL/INFO par test)
"   VIMTEST_SUITE   'startup' (juste le démarrage) ou 'full' (tous les tests)
"   EXPECT_TIER     niveau attendu (full/compat/minimal)
"   EXPECT_THEME    thème attendu au démarrage (vide = pas de contrôle)
"
" Écrit en vimscript compatible 7.3 : pas de lambdas, pas de execute().

let s:out = []
let s:fails = 0

function! s:ok(name, cond, ...)
  if a:cond
    call add(s:out, 'PASS ' . a:name)
  else
    call add(s:out, 'FAIL ' . a:name . (a:0 ? ' :: ' . a:1 : ''))
    let s:fails += 1
  endif
endfunction

function! s:info(text)
  call add(s:out, 'INFO ' . a:text)
endfunction

function! s:messages()
  redir => l:m
  silent messages
  redir END
  return l:m
endfunction

" Erreurs dans :messages (hors messages normaux de vim)
function! s:errors(text)
  let l:err = []
  for l:line in split(a:text, "\n")
    if l:line =~# '^E\d\+:\|Error detected\|^Erreur\|line \d\+:$\|^Error' && l:line !~# 'Messages maintainer'
      call add(l:err, l:line)
    endif
  endfor
  return l:err
endfunction

function! s:scratch(lines, ft)
  enew!
  setlocal noswapfile
  call setline(1, a:lines)
  execute 'set filetype=' . a:ft
  setlocal nomodified
endfunction

" --- Tests de démarrage -------------------------------------------------------
function! s:test_startup()
  let l:msgs = s:messages()
  let l:err = s:errors(l:msgs)
  call s:ok('startup.no_errors', empty(l:err), join(l:err, ' | '))
  call s:ok('startup.errmsg_empty', v:errmsg ==# '', v:errmsg)
  if !exists('g:my_tier')
    " vim-tiny : pas de +eval, rien d'autre à vérifier
    return
  endif
  call s:info('tier=' . g:my_tier . ' theme=' . get(g:, 'my_current_theme', '-')
        \ . ' colors_name=' . get(g:, 'colors_name', '-') . ' bg=' . &background
        \ . ' ncolors=' . g:my_colors . ' tgc=' . (exists('+termguicolors') ? &termguicolors : '-')
        \ . ' ft=' . &filetype)
  if $EXPECT_TIER !=# ''
    call s:ok('startup.tier', g:my_tier ==# $EXPECT_TIER, g:my_tier . ' != ' . $EXPECT_TIER)
  endif
  if $EXPECT_THEME !=# ''
    call s:ok('startup.theme', get(g:, 'my_current_theme', '') ==# $EXPECT_THEME,
          \ get(g:, 'my_current_theme', '') . ' != ' . $EXPECT_THEME)
  endif
  if $EXPECT_FT !=# ''
    call s:ok('startup.filetype', &filetype ==# $EXPECT_FT, &filetype . ' != ' . $EXPECT_FT)
  endif
endfunction

" --- Tests complets -------------------------------------------------------------
function! s:test_env()
  let l:rtp = split(&runtimepath, ',')
  call s:ok('env.rtp_has_my_dir', index(l:rtp, g:my_dir) >= 0)
  if resolve(expand('~/.vim')) !=# g:my_dir
    call s:ok('env.rtp_isolated', index(l:rtp, expand('~/.vim')) < 0, &runtimepath)
  endif
  call s:ok('env.local_dir', isdirectory(g:my_local), g:my_local)
  if has('persistent_undo')
    call s:ok('env.undofile', &undofile && isdirectory(&undodir), &undodir)
  endif
  call s:ok('env.leader', get(g:, 'mapleader', '') ==# ',')
endfunction

function! s:test_mappings()
  " bug historique : la virgule seule était mappée sur :%s/\s\+$//g
  call s:ok('map.no_bare_leader', maparg(',', 'n') ==# '' && maparg(',', 'x') ==# '',
        \ maparg(',', 'n'))
  call s:ok('map.shift_enter', maparg('<S-CR>', 'n') ==# 'O<Esc>', maparg('<S-CR>', 'n'))
  call s:ok('map.jf', maparg('jf', 'i') ==# '<Esc>')
  call s:ok('map.azerty_recursive', maparg("'", 'n') ==# '[')
  call s:ok('map.space_fold', maparg('<Space>', 'n') ==# 'za')
  call s:ok('map.session_last', maparg(',wl', 'n') =~# 'last_session')
  for l:k in ['be', 'bt', 'bs', 'bv']
    call s:ok('map.buffers_' . l:k, maparg(',' . l:k, 'n') !=# '', 'absent')
  endfor
  " Tous nos raccourcis de la forme :Commande doivent viser une commande qui
  " existe (sinon : raccourci mort, comme ,gs -> :Gstatus dans l'ancien vimrc).
  redir => l:all
  silent verbose map
  silent verbose map!
  redir END
  let l:lines = split(l:all, "\n")
  let l:dead = []
  let l:i = 0
  while l:i < len(l:lines) - 1
    let l:line = l:lines[l:i]
    let l:from = l:lines[l:i + 1]
    let l:i += 1
    if l:from !~# 'Last set from' || l:from !~# escape(fnamemodify(g:my_dir, ':t'), '.')
      continue
    endif
    let l:cmd = matchstr(l:line, '\*\=\s\+:\%(<C-[Uu]>\)\=\zs\u\w*')
    if l:cmd !=# '' && exists(':' . l:cmd) != 2
      call add(l:dead, l:cmd . ' <- ' . substitute(l:line, '\s\+', ' ', 'g'))
    endif
  endwhile
  call s:ok('map.no_dead_commands', empty(l:dead), join(l:dead, ' | '))
endfunction

function! s:test_commands()
  for l:c in ['Theme', 'StripWhitespace', 'LongLinesToggle', 'WatchForChanges',
        \ 'WatchForChangesAllFile']
    call s:ok('cmd.' . l:c, exists(':' . l:c) == 2)
  endfor
endfunction

function! s:test_edit()
  " espaces en fin de ligne : code
  call s:scratch(['a  ', "b\t", 'c'], 'python')
  StripWhitespace
  call s:ok('edit.strip_code', getline(1, '$') ==# ['a', 'b', 'c'], string(getline(1, '$')))
  " markdown : deux espaces finaux = retour à la ligne, conservés
  call s:scratch(['a ', 'b  ', 'c   ', '   ', 'd'], 'markdown')
  StripWhitespace
  call s:ok('edit.strip_markdown', getline(1, '$') ==# ['a', 'b  ', 'c', '', 'd'],
        \ string(getline(1, '$')))
  " casse
  call s:ok('edit.twiddle', my#edit#twiddle_case('abc def') ==# 'Abc Def'
        \ && my#edit#twiddle_case('Abc Def') ==# 'ABC DEF'
        \ && my#edit#twiddle_case('ABC DEF') ==# 'abc def')
  " déplacement de lignes
  call s:scratch(['1', '2', '3'], 'text')
  call cursor(2, 1)
  call my#edit#move_line(-1)
  call s:ok('edit.move_up', getline(1, '$') ==# ['2', '1', '3'], string(getline(1, '$')))
  call cursor(1, 1)
  call my#edit#move_line(1)
  call s:ok('edit.move_down', getline(1, '$') ==# ['1', '2', '3'], string(getline(1, '$')))
  " recherche de la sélection
  call s:scratch(['foo.bar x foo.bar'], 'text')
  normal! 0v6l
  execute "normal! \<Esc>"
  call my#edit#visual_search('f')
  call s:ok('edit.visual_search', @/ ==# '\Vfoo.bar' && col('.') == 11, @/ . ' col=' . col('.'))
endfunction

function! s:test_filetypes()
  let l:dir = g:my_dir . '/test/fixtures'
  let l:cases = [['sample.md', 'markdown'], ['notes.txt', 'markdown'],
        \ ['doc/help.txt', 'help'], ['robot.mq4', 'mql4'], ['Makefile', 'make'],
        \ ['script.py', 'python'], ['app.js', 'javascript'], ['data.json', 'json'],
        \ ['page.xml', 'xml']]
  for l:c in l:cases
    execute 'silent edit! ' . fnameescape(l:dir . '/' . l:c[0])
    let l:want = l:c[1]
    if l:want ==# 'json' && empty(globpath($VIMRUNTIME, 'syntax/json.vim'))
      let l:want = 'javascript'
    endif
    call s:ok('ft.' . l:c[0], &filetype ==# l:want, &filetype)
    if l:c[1] ==# 'markdown'
      call s:ok('ftplugin.markdown_spell.' . l:c[0], &l:spell && &l:textwidth == 72)
    elseif l:c[1] ==# 'make'
      call s:ok('ftplugin.make_tabs', !&l:expandtab)
    endif
    silent! bwipeout!
  endfor
endfunction

function! s:test_highlights()
  if !exists('*getmatches')
    return
  endif
  call s:scratch(["x = 1  ", "a\tb"], 'python')
  doautocmd BufWinEnter
  let l:groups = map(getmatches(), 'v:val.group')
  call s:ok('hl.code_matches', index(l:groups, 'ExtraWhitespace') >= 0
        \ && index(l:groups, 'InappropriateTabs') >= 0, string(l:groups))
  call s:scratch(['texte  '], 'markdown')
  doautocmd BufWinEnter
  let l:groups = map(getmatches(), 'v:val.group')
  call s:ok('hl.prose_matches', index(l:groups, 'ExtraWhitespaceSoft') >= 0
        \ && index(l:groups, 'ExtraWhitespace') < 0, string(l:groups))
  LongLinesToggle
  let l:groups = map(getmatches(), 'v:val.group')
  call s:ok('hl.longlines', index(l:groups, 'OverLength') >= 0, string(l:groups))
  LongLinesToggle
  call s:ok('hl.groups_defined', hlexists('ExtraWhitespace') && hlexists('InappropriateTabs'))
endfunction

function! s:test_themes()
  let l:start = get(g:, 'my_current_theme', '')
  let l:bg = &background
  let l:list = my#colors#list()
  call s:info('themes available: ' . join(l:list, ','))
  for l:name in l:list
    for l:b in ['dark', 'light']
      let v:errmsg = ''
      let l:got = my#colors#apply(l:name, l:b, 0)
      call s:ok('theme.' . l:name . '.' . l:b, l:got ==# l:name && v:errmsg ==# ''
            \ && exists('g:colors_name'), 'got=' . l:got . ' err=' . v:errmsg)
    endfor
  endfor
  " thème inconnu : repli sans erreur
  let v:errmsg = ''
  silent Theme ne_existe_pas
  call s:ok('theme.fallback', index(l:list, get(g:, 'my_current_theme', '')) >= 0
        \ && v:errmsg ==# '', get(g:, 'my_current_theme', '') . ' ' . v:errmsg)
  " bascule clair / sombre
  call my#colors#apply(l:start, 'dark', 0)
  call my#colors#toggle_background()
  call s:ok('theme.toggle_bg', &background ==# 'light'
        \ || get(g:, 'my_current_theme', '') ==# 'noctu', &background)
  call s:ok('theme.state_saved', filereadable(g:my_local . '/theme.vim'))
  " orthographe lisible en console : souligné, pas de fond
  if g:my_colors <= 16 && !g:my_truecolor
    call s:ok('theme.tty_spell', synIDattr(hlID('SpellBad'), 'underline', 'cterm') ==# '1')
  endif
  call my#colors#apply(l:start, l:bg, 0)
endfunction

function! s:test_plugins()
  let l:full = g:my_tier ==# 'full'
  let l:any = g:my_tier !=# 'minimal' && isdirectory(g:my_dir . '/plugged')
  if !l:any
    call s:ok('plug.none_loaded', !exists(':NERDTree') && !exists(':ALEFix'))
    return
  endif
  call s:ok('plug.ale', (exists(':ALEFix') == 2) == l:full)
  call s:ok('plug.fzf', (exists(':Files') == 2) == l:full)
  call s:ok('plug.ctrlp', exists(':CtrlP') == 2)
  call s:ok('map.buffers_az', maparg(',az', 'n') =~# 'Buffer')
  call s:ok('plug.nerdtree', exists(':NERDTreeToggle') == 2)
  call s:ok('plug.tabular', exists(':Tabularize') == 2)
  call s:ok('plug.undotree', exists(':UndotreeToggle') == 2)
  call s:ok('plug.goyo', exists(':Goyo') == 2)
  if v:version >= 704
    call s:ok('plug.fugitive', exists(':Git') == 2)
    call s:ok('plug.obsession', exists(':Obsession') == 2)
    call s:ok('plug.airline', exists(':AirlineToggle') == 2)
  endif
  call s:ok('plug.disabled_not_loaded', !exists('g:loaded_toml') || !has_key(g:my_plug_off, 'vim-toml'))
endfunction

function! s:autocmd_count(group)
  redir => l:out
  silent! execute 'autocmd ' . a:group
  redir END
  return len(split(l:out, "\n"))
endfunction

" ,sv recharge le vimrc : ni erreur, ni autocommandes dupliquées
function! s:test_reload()
  let l:before = s:autocmd_count('my_highlights') + s:autocmd_count('my_options')
  let v:errmsg = ''
  let l:nerr = len(s:errors(s:messages()))
  execute 'silent source ' . fnameescape(g:my_dir . '/vimrc')
  execute 'silent source ' . fnameescape(g:my_dir . '/vimrc')
  let l:after = s:autocmd_count('my_highlights') + s:autocmd_count('my_options')
  let l:err = s:errors(s:messages())
  call s:ok('reload.no_error', len(l:err) == l:nerr, join(l:err[l:nerr :], ' | '))
  call s:ok('reload.no_duplicate_autocmds', l:before == l:after, l:before . ' -> ' . l:after)
  call s:ok('reload.theme_kept', exists('g:colors_name'))
endfunction

" Mode écriture : Goyo + Limelight + Pencil, entrée et sortie sans erreur
function! s:test_writing()
  if exists(':Goyo') != 2 || v:version < 704
    return
  endif
  execute 'silent edit! ' . fnameescape(g:my_dir . '/test/fixtures/sample.md')
  let l:nerr = len(s:errors(s:messages()))
  Goyo
  let l:in = exists('#goyo')
  Goyo!
  let l:err = s:errors(s:messages())
  call s:ok('writing.goyo_toggle', l:in && len(l:err) == l:nerr, join(l:err[l:nerr :], ' | '))
  silent! bwipeout!
endfunction

function! s:test_extras()
  if g:my_tier ==# 'full' && isdirectory(g:my_dir . '/plugged/fzf')
    call s:ok('extra.fzf_binary', executable(g:my_dir . '/plugged/fzf/bin/fzf') || executable('fzf'))
  endif
  if exists('g:airline_theme') && get(g:, 'my_current_theme', '') ==# 'everforest'
    call s:ok('extra.airline_follows_theme', g:airline_theme ==# 'everforest', g:airline_theme)
  endif
  " fichier markdown : orthographe française active et dictionnaire trouvé
  execute 'silent edit! ' . fnameescape(g:my_dir . '/test/fixtures/sample.md')
  call s:ok('extra.spell_fr', &l:spell && &l:spelllang ==# 'fr'
        \ && !empty(spellbadword('maisson')[0]), string(spellbadword('maisson')))
  silent! bwipeout!
endfunction

function! s:run()
  call s:test_startup()
  if exists('g:my_tier') && $VIMTEST_SUITE ==# 'full'
    for l:t in ['env', 'mappings', 'commands', 'edit', 'filetypes', 'highlights', 'themes', 'plugins', 'writing', 'extras', 'reload']
      try
        call call('s:test_' . l:t, [])
      catch
        call s:ok('exception.' . l:t, 0, v:exception . ' @ ' . v:throwpoint)
      endtry
    endfor
    " erreurs apparues pendant les tests eux-mêmes
    let l:err = s:errors(s:messages())
    call s:ok('suite.no_new_errors', empty(l:err), join(l:err, ' | '))
  endif
  call writefile(s:out, $VIMTEST_OUT)
  qall!
endfunction

" On attend la fin du démarrage (VimEnter), plus un court délai quand c'est
" possible pour laisser les tâches asynchrones (ALE…) se manifester.
function! s:start(...)
  call s:run()
endfunction

if exists('*timer_start')
  call timer_start(300, function('s:start'))
else
  call s:run()
endif
