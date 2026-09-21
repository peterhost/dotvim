" airline.vim — barre d'état et barre d'onglets
if !my#plug#on('vim-airline')
  finish
endif
scriptencoding utf-8

" Symboles : polices patchées (powerline) seulement si on le demande dans
" ~/.vimrc.local (let g:my_powerline_fonts = 1) ; sinon Unicode ou ASCII.
let g:airline_powerline_fonts = get(g:, 'my_powerline_fonts', 0) && g:my_utf8
if !g:airline_powerline_fonts
  if g:my_utf8
    let g:airline_left_sep = '▶'
    let g:airline_right_sep = '◀'
    let g:airline_symbols = get(g:, 'airline_symbols', {})
    let g:airline_symbols.branch = '⎇'
    let g:airline_symbols.linenr = '¶'
    let g:airline_symbols.maxlinenr = ''
    let g:airline_symbols.paste = '∥'
    let g:airline_symbols.spell = 'Ꞩ'
    let g:airline_symbols.notexists = '∄'
    let g:airline_symbols.whitespace = 'Ξ'
  else
    let g:airline_symbols_ascii = 1
  endif
endif

" Le thème d'airline suit le thème de couleurs (everforest, edge, lucius…).
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#tab_nr_type = 2
let g:airline_inactive_collapse = 1

nnoremap <leader>at :AirlineToggle<CR>
