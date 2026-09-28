" finder.vim — recherche floue de fichiers, buffers, tags… (remplace
" FuzzyFinder, LustyJuggler, peepopen, minibufexpl)
"
" fzf.vim si fzf est disponible, sinon ctrlp (vimscript pur, marche partout).
" Mêmes raccourcis dans les deux cas :
"   ,ff fichiers   ,fb buffers   ,fd dossiers   ,ft tags     ,fh aide
"   ,fj sauts      ,fc changements  ,fr historique  ,fg rechercher (rg)
"   ,ll ,aa ,az buffers
" Dans la liste : Entrée ouvre, Ctrl-j partage horizontal, Ctrl-k vertical,
" Ctrl-l nouvel onglet (comme avec FuzzyFinder).

let s:fzf_bin = g:my_dir . '/plugged/fzf/bin/fzf'
" ctrlp ne prend jamais Ctrl-p (réservé au défilement des copies, vim-yoink) ;
" on l'appelle par ,ff quand fzf n'est pas disponible.
let g:ctrlp_map = ''
" cache (y compris la liste des fichiers récents) dans local/, jamais ~/.cache
let g:ctrlp_cache_dir = g:my_local . '/tmp/ctrlp'
let s:use_fzf = my#plug#on('fzf.vim') && (executable('fzf') || executable(s:fzf_bin))

if s:use_fzf
  let g:fzf_action = {'ctrl-l': 'tab split', 'ctrl-j': 'split', 'ctrl-k': 'vsplit'}
"= fichiers | ouvrir un fichier (recherche floue)
  nnoremap <leader>ff :Files<CR>
"= buffers | choisir un buffer
  nnoremap <leader>fb :Buffers<CR>
"= fichiers | ouvrir un fichier du dossier du fichier courant
  nnoremap <leader>fd :Files <C-r>=expand('%:p:h')<CR><CR>
"= navigation | sauter à une étiquette (tags)
  nnoremap <leader>ft :Tags<CR>
"= aide | chercher une rubrique d’aide
  nnoremap <leader>fh :Helptags<CR>
"= navigation | revenir à un saut précédent (jumps)
  nnoremap <leader>fj :Jumps<CR>
"= navigation | aller à une modification (changes)
  nnoremap <leader>fc :Changes<CR>
"= fichiers | rouvrir un fichier récent
  nnoremap <leader>fr :History<CR>
"= navigation | chercher une ligne du fichier courant
  nnoremap <leader>fl :BLines<CR>
"= buffers | choisir un buffer (raccourcis historiques)
  nnoremap <leader>ll :Buffers<CR>
  nnoremap <leader>aa :Buffers<CR>
  nnoremap <leader>az :Buffers<CR>
"= recherche | chercher dans les fichiers (ripgrep s’il est là, sinon :vimgrep)
  if executable('rg')
    nnoremap <leader>fg :Rg<Space>
  else
    nnoremap <leader>fg :vimgrep // **/*<Left><Left><Left><Left><Left><Left>
  endif
elseif my#plug#on('ctrlp.vim')
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
"= fichiers | ouvrir un fichier (recherche floue)
  nnoremap <leader>ff :CtrlP<CR>
"= buffers | choisir un buffer
  nnoremap <leader>fb :CtrlPBuffer<CR>
"= fichiers | ouvrir un fichier du dossier du fichier courant
  nnoremap <leader>fd :CtrlP <C-r>=expand('%:p:h')<CR><CR>
"= navigation | sauter à une étiquette (tags)
  nnoremap <leader>ft :CtrlPTag<CR>
"= fichiers | rouvrir un fichier récent
  nnoremap <leader>fr :CtrlPMRUFiles<CR>
"= navigation | chercher une ligne du fichier courant
  nnoremap <leader>fl :CtrlPLine<CR>
"= buffers | choisir un buffer (raccourcis historiques)
  nnoremap <leader>ll :CtrlPBuffer<CR>
  nnoremap <leader>aa :CtrlPBuffer<CR>
  nnoremap <leader>az :CtrlPBuffer<CR>
"= aide | chercher une rubrique d’aide
  nnoremap <leader>fh :help<Space>
"= navigation | revenir à un saut précédent (jumps)
  nnoremap <leader>fj :jumps<CR>
"= navigation | aller à une modification (changes)
  nnoremap <leader>fc :changes<CR>
"= recherche | chercher dans les fichiers (ripgrep s’il est là, sinon :vimgrep)
  nnoremap <leader>fg :vimgrep // **/*<Left><Left><Left><Left><Left><Left>
endif

unlet s:fzf_bin s:use_fzf
