" finder.vim — recherche floue de fichiers, buffers, tags… (remplace
" FuzzyFinder, LustyJuggler, peepopen, minibufexpl)
"
" fzf.vim si fzf est disponible, sinon ctrlp (vimscript pur, marche partout).
" Mêmes raccourcis dans les deux cas :
"   ,ff fichiers   ,fb buffers   ,fd dossiers   ,ft tags     ,fh aide
"   ,fj sauts      ,fc changements  ,fr historique  ,fg rechercher (rg)
"   ,ll ,aa buffers
" Dans la liste : Entrée ouvre, Ctrl-j partage horizontal, Ctrl-k vertical,
" Ctrl-l nouvel onglet (comme avec FuzzyFinder).

let s:fzf_bin = g:my_dir . '/plugged/fzf/bin/fzf'
let s:use_fzf = my#plug#on('fzf.vim') && (executable('fzf') || executable(s:fzf_bin))

if s:use_fzf
  let g:fzf_action = {'ctrl-l': 'tab split', 'ctrl-j': 'split', 'ctrl-k': 'vsplit'}
  nnoremap <leader>ff :Files<CR>
  nnoremap <leader>fb :Buffers<CR>
  nnoremap <leader>fd :Files <C-r>=expand('%:p:h')<CR><CR>
  nnoremap <leader>ft :Tags<CR>
  nnoremap <leader>fh :Helptags<CR>
  nnoremap <leader>fj :Jumps<CR>
  nnoremap <leader>fc :Changes<CR>
  nnoremap <leader>fr :History<CR>
  nnoremap <leader>fl :BLines<CR>
  nnoremap <leader>ll :Buffers<CR>
  nnoremap <leader>aa :Buffers<CR>
  if executable('rg')
    nnoremap <leader>fg :Rg<Space>
  else
    nnoremap <leader>fg :vimgrep // **/*<Left><Left><Left><Left><Left><Left>
  endif
elseif my#plug#on('ctrlp.vim')
  let g:ctrlp_map = '<leader>ff'
  let g:ctrlp_cache_dir = g:my_local . '/tmp/ctrlp'
  let g:ctrlp_prompt_mappings = {
        \ 'AcceptSelection("h")': ['<c-j>'],
        \ 'AcceptSelection("v")': ['<c-k>'],
        \ 'AcceptSelection("t")': ['<c-l>'],
        \ 'PrtSelectMove("j")':   ['<down>'],
        \ 'PrtSelectMove("k")':   ['<up>'],
        \ 'PrtCurRight()':        ['<right>'],
        \ }
  if executable('rg')
    let g:ctrlp_user_command = 'rg %s --files --color=never'
    let g:ctrlp_use_caching = 0
  endif
  nnoremap <leader>ff :CtrlP<CR>
  nnoremap <leader>fb :CtrlPBuffer<CR>
  nnoremap <leader>fd :CtrlP <C-r>=expand('%:p:h')<CR><CR>
  nnoremap <leader>ft :CtrlPTag<CR>
  nnoremap <leader>fr :CtrlPMRUFiles<CR>
  nnoremap <leader>fl :CtrlPLine<CR>
  nnoremap <leader>ll :CtrlPBuffer<CR>
  nnoremap <leader>aa :CtrlPBuffer<CR>
  nnoremap <leader>fh :help<Space>
  nnoremap <leader>fj :jumps<CR>
  nnoremap <leader>fc :changes<CR>
  nnoremap <leader>fg :vimgrep // **/*<Left><Left><Left><Left><Left><Left>
endif

unlet s:fzf_bin s:use_fzf
