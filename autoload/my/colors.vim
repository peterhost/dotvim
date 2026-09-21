" autoload/my/colors.vim — choix du thème selon ce que le terminal sait afficher
"
" Chaque thème déclare ses exigences : nombre de couleurs minimal, version de
" vim minimale, et s'il existe en clair, en sombre ou les deux. Un thème qui
" ne convient pas (ou qui est absent) est sauté, jusqu'au thème `default`.

" nom => [couleurs min, version min, fonds gérés, fichier clair, fichier sombre]
let s:themes = {
      \ 'everforest': [256, 800, 'both', 'everforest', 'everforest'],
      \ 'edge':       [256, 800, 'both', 'edge', 'edge'],
      \ 'catppuccin': [256, 800, 'both', 'catppuccin_latte', 'catppuccin_mocha'],
      \ 'solarized8': [256, 800, 'both', 'solarized8', 'solarized8'],
      \ 'lucius':     [256, 700, 'both', 'lucius', 'lucius'],
      \ 'PaperColor': [8,   700, 'both', 'PaperColor', 'PaperColor'],
      \ 'pencil':     [256, 700, 'both', 'pencil', 'pencil'],
      \ 'retrobox':   [8,   900, 'both', 'retrobox', 'retrobox'],
      \ 'wildcharm':  [8,   900, 'both', 'wildcharm', 'wildcharm'],
      \ 'lunaperche': [8,   900, 'both', 'lunaperche', 'lunaperche'],
      \ 'noctu':      [8,   700, 'dark', 'noctu', 'noctu'],
      \ 'default':    [0,   0,   'both', 'default', 'default'],
      \ }
let s:order = ['everforest', 'edge', 'catppuccin', 'solarized8', 'lucius',
      \ 'PaperColor', 'pencil', 'retrobox', 'wildcharm', 'lunaperche', 'noctu',
      \ 'default']

let s:state_file = g:my_local . '/theme.vim'

" --- Disponibilité ----------------------------------------------------------------
function! s:file(name, bg)
  let l:t = s:themes[a:name]
  return a:bg ==# 'light' ? l:t[3] : l:t[4]
endfunction

function! my#colors#available(name)
  if !has_key(s:themes, a:name)
    " thème hors registre : accepté s'il existe
    return !empty(globpath(&runtimepath, 'colors/' . a:name . '.vim'))
  endif
  let l:t = s:themes[a:name]
  return g:my_colors >= l:t[0] && v:version >= l:t[1]
        \ && (a:name ==# 'default'
        \     || !empty(globpath(&runtimepath, 'colors/' . l:t[4] . '.vim')))
endfunction

function! my#colors#list()
  return filter(copy(s:order), 'my#colors#available(v:val)')
endfunction

" --- Application ----------------------------------------------------------------------
" Réglages propres à certains thèmes, à poser avant :colorscheme.
function! s:options()
  let l:italic = g:my_gui || g:my_truecolor
  let g:everforest_background = get(g:, 'everforest_background', 'medium')
  let g:everforest_better_performance = 1
  let g:everforest_enable_italic = l:italic
  let g:everforest_spell_foreground = 'colored'
  let g:edge_better_performance = 1
  let g:edge_enable_italic = l:italic
  let g:edge_spell_foreground = 'colored'
  " lucius suit 'background' si g:lucius_style n'est pas défini
  unlet! g:lucius_style
endfunction

" Essaie `name`, puis les replis. Retourne le thème réellement appliqué.
function! my#colors#apply(name, bg, save)
  call s:options()
  let l:chain = [a:name]
        \ + (g:my_colors >= 256 ? ['everforest', 'PaperColor', 'lucius'] : ['noctu', 'PaperColor'])
        \ + ['default']
  for l:name in l:chain
    if !my#colors#available(l:name)
      continue
    endif
    let l:bg = a:bg
    if has_key(s:themes, l:name) && s:themes[l:name][2] !=# 'both'
      let l:bg = s:themes[l:name][2]
    endif
    let &background = l:bg
    try
      execute 'colorscheme ' . (has_key(s:themes, l:name) ? s:file(l:name, l:bg) : l:name)
    catch
      continue
    endtry
    let g:my_current_theme = l:name
    if a:save
      call s:save(l:name, &background)
    endif
    return l:name
  endfor
  return ''
endfunction

" --- État mémorisé (par machine, dans local/) ------------------------------------------
function! s:save(name, bg)
  if exists('*writefile') && isdirectory(g:my_local)
    silent! call writefile(['let g:my_state = ' . string({'theme': a:name, 'background': a:bg})], s:state_file)
  endif
endfunction

function! my#colors#init()
  if g:my_truecolor && !g:my_gui && exists('+termguicolors')
    " dans tmux/screen, vim ne connaît pas les séquences 24 bits : on les donne
    if $TERM =~# '^\(tmux\|screen\)'
      let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
      let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    endif
    set termguicolors
  endif
  if g:my_undercurl && !g:my_gui
    let &t_Cs = "\<Esc>[4:3m"
    let &t_Ce = "\<Esc>[4:0m"
    if exists('&t_8u') && g:my_truecolor
      let &t_8u = "\<Esc>[58;2;%lu;%lu;%lum"
    endif
  endif
  if filereadable(s:state_file)
    silent! execute 'source ' . fnameescape(s:state_file)
  endif
  let l:state = get(g:, 'my_state', {})
  let l:name = get(g:, 'my_theme', get(l:state, 'theme', 'everforest'))
  let l:bg = get(g:, 'my_background', get(l:state, 'background', 'dark'))
  if g:my_tty
    let l:bg = 'dark'
  endif
  call my#colors#apply(l:name, l:bg, 0)
endfunction

" --- Commandes et raccourcis ------------------------------------------------------------------
function! my#colors#toggle_background()
  call my#colors#apply(get(g:, 'my_current_theme', 'default'),
        \ &background ==# 'dark' ? 'light' : 'dark', 1)
  echo get(g:, 'my_current_theme', '') . ' (' . &background . ')'
endfunction

function! my#colors#cycle(step)
  let l:list = my#colors#list()
  if empty(l:list)
    return
  endif
  let l:i = index(l:list, get(g:, 'my_current_theme', ''))
  let l:next = l:list[(l:i + a:step + len(l:list)) % len(l:list)]
  call my#colors#apply(l:next, &background, 1)
  echo get(g:, 'my_current_theme', '') . ' (' . &background . ')'
endfunction

" :Theme [nom] [light|dark]
function! my#colors#command(args)
  let l:args = split(a:args)
  if empty(l:args)
    echo 'Thème : ' . get(g:, 'my_current_theme', '?') . ' (' . &background . ')'
          \ . '   disponibles : ' . join(my#colors#list(), ', ')
    return
  endif
  let l:bg = len(l:args) > 1 ? l:args[1] : &background
  let l:done = my#colors#apply(l:args[0], l:bg, 1)
  if l:done !=# l:args[0]
    echohl WarningMsg
    echo 'Thème ' . l:args[0] . ' indisponible ici, remplacé par ' . l:done
    echohl None
  endif
endfunction

function! my#colors#complete(lead, line, pos)
  if a:line =~# '^\s*\S\+\s\+\S\+\s'
    return filter(['light', 'dark'], 'v:val =~# "^" . a:lead')
  endif
  return filter(my#colors#list(), 'v:val =~? "^" . a:lead')
endfunction

" --- Retouches valables pour tous les thèmes (autocmd ColorScheme) -----------------------
function! my#colors#fixup()
  " Orthographe lisible quand le thème ne peut pas souligner en couleur :
  " texte coloré + souligné, sans fond qui masquerait le mot.
  if !g:my_gui && !g:my_truecolor && g:my_colors <= 16
    highlight SpellBad   cterm=underline ctermfg=1 ctermbg=NONE
    highlight SpellCap   cterm=underline ctermfg=3 ctermbg=NONE
    highlight SpellRare  cterm=underline ctermfg=5 ctermbg=NONE
    highlight SpellLocal cterm=underline ctermfg=6 ctermbg=NONE
  endif
  call my#highlights#define()
endfunction
