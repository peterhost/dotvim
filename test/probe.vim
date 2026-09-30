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
  call s:ok('env.netrw_home_local', get(g:, 'netrw_home', '') ==# g:my_local)
  if has('viminfo')
    call s:ok('env.viminfo_local', &viminfo =~# ',n' . escape(g:my_local, '\.') . '/viminfo$', &viminfo)
  endif
endfunction

function! s:test_mappings()
  " bug historique : la virgule seule était mappée sur :%s/\s\+$//g
  call s:ok('map.no_bare_leader', maparg(',', 'n') ==# '' && maparg(',', 'x') ==# '',
        \ maparg(',', 'n'))
  call s:ok('map.shift_enter', maparg('<S-CR>', 'n') ==# 'O<Esc>', maparg('<S-CR>', 'n'))
  call s:ok('map.jf', maparg('jf', 'i') ==# '<Esc>')
  call s:ok('map.azerty_recursive', maparg("'", 'n') ==# '[')
  call s:ok('map.space_fold', maparg('<Space>', 'n') ==# 'za')
  call s:ok('map.ctrlp_not_on_ctrl_p', maparg('<C-p>', 'n') !~? 'ctrlp')
  call s:ok('map.f5_insert', maparg('<F5>', 'i') =~# 'toggle_background')
  call s:ok('map.buffer_next', maparg(',n', 'n') =~# 'bnext')
  call s:ok('map.buffer_prev', maparg(',p', 'n') =~# 'bprevious')
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
    elseif l:c[1] ==# 'python' && exists(':ALEFix') == 2
      for l:k in ['d', 'N', 'r', 'R']
        call s:ok('ftplugin.python_map_' . l:k, maparg(',' . l:k, 'n') =~# 'ALE')
      endfor
      call s:ok('ftplugin.python_keeps_buffer_next', maparg(',n', 'n') =~# 'bnext')
    elseif l:c[1] ==# 'make'
      call s:ok('ftplugin.make_tabs', !&l:expandtab)
    endif
    silent! bdelete!
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
  " Les palettes communes avec le shell ont leur thème vim — seulement là où
  " elles peuvent s'afficher : en console 8-16 couleurs, c'est normal qu'elles
  " soient écartées (voir le repli de my#colors#apply).
  if g:my_colors >= 256 && v:version >= 800
    for l:pal in ['catppuccin', 'gruvbox8', 'nord', 'tokyonight', 'solarized8']
      call s:ok('theme.palette_' . l:pal, index(l:list, l:pal) >= 0, 'absent')
    endfor
  endif
  " F5 : forçage pour la session seulement, rien n'est mémorisé
  call delete(g:my_local . '/theme.vim')
  call my#colors#toggle_background()
  call s:ok('theme.f5_session_only', !filereadable(g:my_local . '/theme.vim')
        \ && exists('g:my_background_forced'), 'un fichier d''état a été écrit')
  " accord avec le shell : lu, jamais supposé
  let $DOTLIB_THEME_EFF = 'light'
  call s:ok('theme.shell_background', my#colors#from_shell()[0] ==# 'light', string(my#colors#from_shell()))
  let $DOTLIB_PALETTE_EFF = 'nord'
  call s:ok('theme.shell_palette_opt_in', my#colors#from_shell()[1] ==# '', 'palette suivie sans le demander')
  let g:my_follow_palette = 1
  " (en console 8-16 couleurs, nord n'est pas affichable : la palette est alors
  " écartée, ce qui est le comportement voulu)
  if g:my_colors >= 256 && v:version >= 800
    call s:ok('theme.shell_palette_followed', my#colors#from_shell()[1] ==# 'nord',
          \ string(my#colors#from_shell()))
  else
    call s:ok('theme.shell_palette_ignored_low_color', my#colors#from_shell()[1] ==# '',
          \ string(my#colors#from_shell()))
  endif
  let $DOTLIB_PALETTE_EFF = 'palette-inconnue'
  call s:ok('theme.shell_palette_unknown', my#colors#from_shell()[1] ==# '', 'une palette inconnue a été suivie')
  " xterm : palette historique du shell, sans équivalent vim -> thème inchangé
  let $DOTLIB_PALETTE_EFF = 'xterm'
  call s:ok('theme.shell_palette_xterm', my#colors#from_shell()[1] ==# '', 'xterm a changé le thème')
  " les 10 palettes qui ont un équivalent le trouvent (quand il est affichable)
  if g:my_colors >= 256 && v:version >= 800
    for l:pair in [['everforest', 'everforest'], ['edge', 'edge'], ['lucius', 'lucius'],
          \ ['papercolor', 'PaperColor'], ['pencil', 'pencil'], ['catppuccin', 'catppuccin'],
          \ ['gruvbox', 'gruvbox8'], ['nord', 'nord'], ['solarized', 'solarized8'],
          \ ['tokyonight', 'tokyonight']]
      let $DOTLIB_PALETTE_EFF = l:pair[0]
      call s:ok('theme.shell_palette_' . l:pair[0], my#colors#from_shell()[1] ==# l:pair[1],
            \ l:pair[0] . ' -> ' . string(my#colors#from_shell()[1]))
    endfor
  endif
  unlet g:my_follow_palette
  let $DOTLIB_THEME_EFF = ''
  let $DOTLIB_PALETTE_EFF = ''
  unlet! g:my_background_forced
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
  call s:ok('plug.ctrlp_cache_local', stridx(get(g:, 'ctrlp_cache_dir', ''), g:my_local) == 0, get(g:, 'ctrlp_cache_dir', ''))
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
  " vim ne repeint pas la barre de statut de tmux : c'est « trc theme » qui la peint.
  " L'extension d'airline le faisait d'office dès que tmuxline était chargé.
  call s:ok('plug.tmuxline_absent', !exists(':Tmuxline'))
  call s:ok('plug.tmuxline_extension_off', get(g:, 'airline#extensions#tmuxline#enabled', 1) == 0)
  call s:ok('plug.disabled_not_loaded', !exists('g:loaded_toml') || !has_key(g:my_plug_off, 'vim-toml'))
  " Tout greffon écarté doit DIRE pourquoi : « vrc greffons » l'affiche, et une
  " déclaration conditionnelle sans raison est un oubli, pas un choix. La raison
  " générique de my#plug#add ne compte pas comme une raison dite.
  let l:muets = []
  for [l:nom, l:raison] in items(get(g:, 'my_plug_off', {}))
    if type(l:raison) != type('') || l:raison ==# '' || l:raison =~# '^condition non remplie'
      call add(l:muets, l:nom)
    endif
  endfor
  call s:ok('plug.skipped_say_why', empty(l:muets), join(l:muets, ' '))
  " et le rapport porte bien trois champs, dont la raison pour les écartés
  let l:ecartes = filter(copy(my#plug#report()), 'v:val =~# "^écarté|"')
  call s:ok('plug.report_three_fields',
        \ empty(filter(copy(l:ecartes), 'len(split(v:val, "|", 1)) != 3 || split(v:val, "|", 1)[2] ==# ""')),
        \ join(l:ecartes, ' '))
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
  silent! bdelete!
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
  silent! bdelete!
endfunction

" Historique des copies : copier 3 lignes, coller, puis Ctrl-p / Ctrl-n
function! s:test_yank_history()
  if !my#plug#on('vim-yoink') || !exists('*yoink#canSwap')
    return
  endif
  call s:scratch(['un', 'deux', 'trois'], 'text')
  " frappe simulée (et non :normal) : yoink s'appuie sur l'annulation, qui
  " regroupe tous les :normal d'une fonction en une seule étape
  call feedkeys('1Gyy2Gyy3GyyGp', 'xt')
  let l:seq = [getline(4)]
  call feedkeys("\<C-p>", 'xt')
  call add(l:seq, getline(4))
  call feedkeys("\<C-p>", 'xt')
  call add(l:seq, getline(4))
  call feedkeys("\<C-n>", 'xt')
  call add(l:seq, getline(4))
  call s:ok('yank.cycle', l:seq ==# ['trois', 'deux', 'un', 'deux'], string(l:seq))
  " hors collage, Ctrl-n garde son effet (ligne suivante)
  " CursorMoved n'est émis qu'en attente de frappe : on le déclenche deux
  " fois (yoink ignore le premier, qui suit le collage lui-même)
  call feedkeys('1G', 'xt')
  doautocmd CursorMoved
  doautocmd CursorMoved
  call feedkeys("\<C-n>", 'xt')
  call s:ok('yank.ctrl_n_native', line('.') == 2, 'ligne ' . line('.'))
endfunction

" Objets de texte python : yiM sur une méthode copie toute la méthode
function! s:test_python_objects()
  if !my#plug#on('vim-pythonsense')
    return
  endif
  execute 'silent edit! ' . fnameescape(g:my_dir . '/test/fixtures/script.py')
  call s:ok('python.map_aC', maparg('aC', 'o') =~# 'Pythonsense')
  let l:line = search('return (self')
  call feedkeys('yaM', 'xt')
  call s:ok('python.yank_method', @" =~# 'def norme' && @" =~# 'return (self', string(@"))
  call feedkeys(l:line . 'GyiC', 'xt')
  call s:ok('python.yank_class_body', @" =~# 'Un point' && @" !~# 'class Point', string(@"))
  silent! bdelete!
endfunction

" Mise à jour échouée : message au démarrage, une seule fois
function! s:test_update_notice()
  let l:status = g:my_local . '/update-status'
  call writefile(['fail 2', 'x fzf:', 'conseil: lancer : sudo opkg install git-http'], l:status)
  call delete(g:my_local . '/update-status.seen')
  let l:before = len(split(s:messages(), "\n"))
  call my#update#notify()
  let l:new = split(s:messages(), "\n")[l:before :]
  call s:ok('update.notice_shown', join(l:new) =~# 'échoué pour 2' && join(l:new) =~# 'git-http', string(l:new))
  let l:before = len(split(s:messages(), "\n"))
  call my#update#notify()
  call s:ok('update.notice_once', len(split(s:messages(), "\n")) == l:before)
  call writefile(['ok'], l:status)
  call delete(g:my_local . '/update-status.seen')
  let l:before = len(split(s:messages(), "\n"))
  call my#update#notify()
  call s:ok('update.no_notice_when_ok', len(split(s:messages(), "\n")) == l:before)
  " plugin manquant : rappel à chaque démarrage (pas une seule fois)
  if exists('g:plugs')
    let g:plugs['faux-plugin-manquant'] = {'dir': '/nonexistent/faux-plugin', 'uri': 'x'}
    for l:i in [1, 2]
      let l:before = len(split(s:messages(), "\n"))
      call my#update#notify()
      let l:new = split(s:messages(), "\n")[l:before :]
      call s:ok('update.missing_notice_' . l:i, join(l:new) =~# 'non installé', string(l:new))
    endfor
    call s:ok('update.missing_listed', index(my#update#missing(), 'faux-plugin-manquant') >= 0)
    unlet g:plugs['faux-plugin-manquant']
  endif
  call delete(l:status)
endfunction

" local/vimrc.local est lu (prioritaire sur ~/.vimrc.local)
" zg ajoute au dictionnaire de la machine (local/), jamais dans le dépôt
function! s:test_spell_local()
  if !has('spell')
    return
  endif
  call s:ok('spell.file_local', &spellfile ==# g:my_local . '/spell/fr.' . &encoding . '.add', &spellfile)
  call s:scratch(['motinventeparletest'], 'markdown')
  setlocal spell spelllang=fr
  normal! gg0zg
  call s:ok('spell.zg_local', filereadable(&spellfile)
        \ && index(readfile(&spellfile), 'motinventeparletest') >= 0)
  call s:ok('spell.repo_untouched', !filereadable(g:my_dir . '/spell/fr.' . &encoding . '.add'))
endfunction

function! s:test_local_rc()
  call s:ok('local.vimrc_local_read', get(g:, 'my_test_local_rc', '') ==# 'local', get(g:, 'my_test_local_rc', '(non lu)'))
  if my#plug#on('vim-gist')
    call s:ok('local.gist_token', get(g:, 'gist_token_file', '') ==# g:my_local . '/gist-token')
  endif
endfunction

function! s:run()
  call s:test_startup()
  if exists('g:my_tier') && $VIMTEST_SUITE ==# 'full'
    for l:t in ['env', 'mappings', 'commands', 'edit', 'filetypes', 'highlights', 'themes', 'plugins', 'writing', 'extras', 'yank_history', 'python_objects', 'update_notice', 'local_rc', 'spell_local', 'reload']
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
