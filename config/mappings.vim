" mappings.vim — raccourcis globaux
"
" Leader : ,   Localleader : =
" Les raccourcis propres à un plugin sont dans config/plugins/<plugin>.vim,
" ceux propres à un type de fichier dans after/ftplugin/<type>.vim.
" Tous sont non récursifs (noremap), sauf les raccourcis AZERTY qui doivent
" déclencher les mappings d'autres plugins (unimpaired, matchit).

" --- Échap et divers ------------------------------------------------------------------
" jf / fj pour quitter l'insertion ou la ligne de commande
inoremap jf <Esc>
inoremap fj <Esc>
cnoremap jf <C-c>
cnoremap fj <C-c>
" espace pour quitter le mode visuel
xnoremap <Space> <Esc>

" Q : reformater le paragraphe ou la sélection
nnoremap Q gqap
xnoremap Q gq

" w!! : enregistrer avec sudo quand on a oublié
cnoremap <expr> w!! getcmdtype() ==# ':' && getcmdline() ==# ''
      \ ? 'w !sudo tee % >/dev/null' : 'w!!'

" Maj+Entrée : insérer une ligne au-dessus sans passer en insertion
nnoremap <S-CR> O<Esc>

" gV : sélectionner le dernier texte modifié ou collé
nnoremap gV `[v`]

" gf : ouvrir le fichier sous le curseur dans un partage vertical
nnoremap gf :vertical wincmd f<CR>

" Indentation en mode visuel sans perdre la sélection
xnoremap < <gv
xnoremap > >gv

" F8 : réindenter tout le fichier (remplacé par ALEFix dans certains types)
nnoremap <F8> mzgg=G`z
inoremap <F8> <Esc>mzgg=G`zi

" Redessiner l'écran
nnoremap <silent> <leader>rr :silent! redraw!<CR>
" Replier la balise HTML courante
nnoremap <leader><C-Space> Vatzf

" --- Recherche ----------------------------------------------------------------------------
nnoremap <silent> <leader>/ :nohlsearch<CR>
nnoremap <silent> <leader>; :nohlsearch<CR>
" rechercher la sélection (* et #), ou la chercher dans les fichiers (gv)
xnoremap <silent> * :<C-u>call my#edit#visual_search('f')<CR>
xnoremap <silent> # :<C-u>call my#edit#visual_search('b')<CR>
xnoremap <silent> gv :<C-u>call my#edit#visual_search('grep')<CR>
nnoremap <leader>g :vimgrep // **/*.<Left><Left><Left><Left><Left><Left><Left>

" --- AZERTY ---------------------------------------------------------------------------------
" Accès direct à [ ] { } % sans AltGr. Récursifs exprès : ' e doit donner
" [e (unimpaired), ù doit donner le % étendu de matchit.
nmap ' [
nmap - ]
nmap § {
nmap à }
xmap ' [
xmap - ]
xmap § {
xmap à }
nmap ù %
xmap ù %
omap ù %
" ; répète la dernière modification, `; revient au dernier point modifié
nnoremap ; .
nnoremap `; `.

" --- Espaces en fin de ligne ----------------------------------------------------------------
command! -range=% StripWhitespace call my#edit#strip_whitespace(<line1>, <line2>)
nnoremap <silent> <S-F7> :StripWhitespace<CR>
nnoremap <silent> <leader><S-Space> :StripWhitespace<CR>
nnoremap <silent> <leader><Space> :.StripWhitespace<CR>
xnoremap <silent> <leader><Space> :StripWhitespace<CR>

" --- Fenêtres ----------------------------------------------------------------------------------
" Ctrl+hjkl et flèches : changer de fenêtre (tmux-navigator les reprend s'il
" est chargé, pour passer aussi d'un panneau tmux à l'autre).
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
xnoremap <C-h> <Esc><C-w>h
xnoremap <C-j> <Esc><C-w>j
xnoremap <C-k> <Esc><C-w>k
xnoremap <C-l> <Esc><C-w>l
nnoremap <Up> <C-w>k
nnoremap <Down> <C-w>j
nnoremap <Left> <C-w>h
nnoremap <Right> <C-w>l
" élargir / rétrécir de 4 colonnes
nnoremap <leader>< 4<C-w><
nnoremap <leader>> 4<C-w>>

" Ctrl+hjkl en insertion et en ligne de commande : déplacer le curseur
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>
cnoremap <C-h> <Left>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
cnoremap <C-l> <Right>

" --- Onglets ---------------------------------------------------------------------------------
nnoremap <localleader>t :$tabnew<CR>
nnoremap <localleader>w :tabclose<CR>
nnoremap <localleader>j :tabfirst<CR>
nnoremap <localleader>k :tablast<CR>
nnoremap <localleader>h :tabprevious<CR>
nnoremap <localleader>l :tabnext<CR>
if has('gui_running')
  noremap <A-Up> :tabfirst<CR>
  noremap <A-Down> :tablast<CR>
  noremap <A-Left> :tabprevious<CR>
  noremap <A-Right> :tabnext<CR>
  noremap <A-k> :tabfirst<CR>
  noremap <A-j> :tablast<CR>
  noremap <A-h> :tabprevious<CR>
  noremap <A-l> :tabnext<CR>
endif

" --- Buffers ---------------------------------------------------------------------------------
" ,x : fermer le buffer en gardant la fenêtre ; ,X : buffer et fenêtre ;
" ,Ctrl-x : la fenêtre seulement
nnoremap <silent> <leader>x :call my#buffers#close()<CR>
nnoremap <leader>X :bdelete<CR>
nnoremap <leader><C-x> :close<CR>
nnoremap <silent> <leader>bc :call my#buffers#clean_empty()<CR>

" --- Quickfix (résultats de :vimgrep, :make, :helpgrep…) --------------------------------------
nnoremap <leader><Left> :cprevious<CR>
nnoremap <leader><Right> :cnext<CR>
nnoremap <leader><Up> :cpfile<CR>
nnoremap <leader><Down> :cnfile<CR>

" --- Repliage ----------------------------------------------------------------------------------
nnoremap <Space> za
nnoremap <BS> zA
nnoremap <S-BS> zr
nnoremap <C-BS> zm
nnoremap <S-C-BS> zi

" --- Déplacer des lignes (Cmd+j/k sous MacVim, Maj+j/k en visuel) ---------------------------------
nnoremap <silent> <D-k> :<C-u>call my#edit#move_line(-1)<CR>
nnoremap <silent> <D-j> :<C-u>call my#edit#move_line(1)<CR>
inoremap <silent> <D-k> <C-o>:call my#edit#move_line(-1)<CR>
inoremap <silent> <D-j> <C-o>:call my#edit#move_line(1)<CR>
xnoremap <silent> <S-k> :<C-u>call my#edit#move_selection(-1)<CR>
xnoremap <silent> <S-j> :<C-u>call my#edit#move_selection(1)<CR>
xnoremap <silent> <D-k> :<C-u>call my#edit#move_selection(-1)<CR>
xnoremap <silent> <D-j> :<C-u>call my#edit#move_selection(1)<CR>

" ~ en visuel : minuscules -> Capitalisées -> MAJUSCULES
xnoremap ~ y:call setreg('"', my#edit#twiddle_case(@"), getregtype('"'))<CR>gvP

" | en insertion : aligne les tableaux markdown au fil de la frappe (tabular)
inoremap <silent> <Bar> <Bar><Esc>:call my#edit#align_table()<CR>a

" --- Aide -------------------------------------------------------------------------------------------
nnoremap <leader>h :help <C-r><C-w><CR>
nnoremap <leader>H :helpgrep <C-r><C-w><CR>

" --- Diff ----------------------------------------------------------------------------------------------
nnoremap Dp :diffput<CR>
nnoremap Dg :diffget<CR>
nnoremap Du :diffupdate<CR>
nnoremap Dt :diffthis<CR>
nnoremap Do :diffoff<CR>

" --- Fichiers de configuration --------------------------------------------------------------------
nnoremap <silent> <leader>ev :call my#buffers#edit_real(g:my_dir . '/vimrc')<CR>
nnoremap <silent> <leader>sv :execute 'source ' . fnameescape(g:my_dir . '/vimrc')<CR>:echo 'vimrc rechargé'<CR>
nnoremap <silent> <leader>eb :call my#buffers#edit_real('~/.bashrc')<CR>
nnoremap <silent> <leader>el :call my#buffers#edit_real('~/.vimrc.local')<CR>
" afficher tous les groupes de couleurs
nnoremap <silent> <leader>sc :source $VIMRUNTIME/syntax/hitest.vim<CR>

" --- Thèmes ----------------------------------------------------------------------------------------------
nnoremap <silent> <F5> :call my#colors#toggle_background()<CR>
inoremap <silent> <F5> <C-o>:call my#colors#toggle_background()<CR>
nnoremap <silent> <leader>$n :call my#colors#cycle(1)<CR>
nnoremap <silent> <leader>$p :call my#colors#cycle(-1)<CR>
nnoremap <leader>$ :Theme<CR>
nnoremap <A-Space> :Theme<Space>

" --- Numéros de ligne relatifs, encodage, terminal -------------------------------------------------------
if exists('+relativenumber')
  nnoremap <silent> <F3> :set relativenumber!<CR>
endif
" rouvrir le fichier dans un autre encodage (remplace FencView)
nnoremap <leader><C-e> :edit ++encoding=
" ,q : terminal intégré (sinon, shell)
if has('terminal')
  nnoremap <silent> <leader>q :tab terminal<CR>
else
  nnoremap <silent> <leader>q :shell<CR>
endif

" --- Surveillance de fichiers modifiés à l'extérieur (voir autoload/my/watch.vim) -------------------
command! -bang WatchForChanges
      \ call my#watch#toggle(@%, {'toggle': 1, 'autoread': <bang>0})
command! -bang WatchForChangesWhileInThisBuffer
      \ call my#watch#toggle(@%, {'toggle': 1, 'autoread': <bang>0, 'while_in_this_buffer_only': 1})
command! -bang WatchForChangesAllFile
      \ call my#watch#toggle('*', {'toggle': 1, 'autoread': <bang>0})
