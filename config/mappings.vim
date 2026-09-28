" mappings.vim — raccourcis globaux
"
" Leader : ,   Localleader : =
" Les raccourcis propres à un plugin sont dans config/plugins/<plugin>.vim,
" ceux propres à un type de fichier dans after/ftplugin/<type>.vim.
" Tous sont non récursifs (noremap), sauf les raccourcis AZERTY qui doivent
" déclencher les mappings d'autres plugins (unimpaired, matchit).

" --- Échap et divers ------------------------------------------------------------------
"= saisie | quitter le mode insertion
inoremap jf <Esc>
inoremap fj <Esc>
"= saisie | quitter la ligne de commande
cnoremap jf <C-c>
cnoremap fj <C-c>
"= saisie | quitter le mode visuel
xnoremap <Space> <Esc>

"= édition | reformater le paragraphe ou la sélection
nnoremap Q gqap
xnoremap Q gq

"= système | enregistrer avec sudo un fichier ouvert sans les droits
cnoremap <expr> w!! getcmdtype() ==# ':' && getcmdline() ==# ''
      \ ? 'w !sudo tee % >/dev/null' : 'w!!'

"= édition | insérer une ligne au-dessus sans passer en insertion
nnoremap <S-CR> O<Esc>

"= édition | resélectionner le dernier texte modifié ou collé
nnoremap gV `[v`]

"= fenêtres | ouvrir le fichier sous le curseur dans un partage vertical
nnoremap gf :vertical wincmd f<CR>

"= édition | indenter / désindenter sans perdre la sélection
xnoremap < <gv
xnoremap > >gv

"= édition | réindenter tout le fichier (ALEFix le remplace là où il est actif)
nnoremap <F8> mzgg=G`z
inoremap <F8> <Esc>mzgg=G`zi

"= système | redessiner l’écran
nnoremap <silent> <leader>rr :silent! redraw!<CR>
"= repliage | replier la balise HTML courante
nnoremap <leader><C-Space> Vatzf

" --- Recherche ----------------------------------------------------------------------------
"= recherche | éteindre la surbrillance des résultats
nnoremap <silent> <leader>/ :nohlsearch<CR>
nnoremap <silent> <leader>; :nohlsearch<CR>
"= recherche | chercher la sélection, en avant (*) ou en arrière (#)
xnoremap <silent> * :<C-u>call my#edit#visual_search('f')<CR>
xnoremap <silent> # :<C-u>call my#edit#visual_search('b')<CR>
"= recherche | chercher la sélection dans les fichiers (:vimgrep)
xnoremap <silent> gv :<C-u>call my#edit#visual_search('grep')<CR>
"= recherche | amorcer un :vimgrep dans l’arborescence
nnoremap <leader>g :vimgrep // **/*.<Left><Left><Left><Left><Left><Left><Left>

" --- AZERTY ---------------------------------------------------------------------------------
" Accès direct à [ ] { } % sans AltGr. Récursifs exprès : ' e doit donner
" [e (unimpaired), ù doit donner le % étendu de matchit.
"= navigation | accès direct à [ ] { } sans AltGr (clavier AZERTY)
nmap ' [
nmap - ]
nmap § {
nmap à }
xmap ' [
xmap - ]
xmap § {
xmap à }
"= navigation | le % étendu de matchit : sauter à la parenthèse, la balise ou le mot-clé apparié
nmap ù %
xmap ù %
omap ù %
"= édition | ; répète la dernière modification, `; retourne au dernier point modifié
nnoremap ; .
nnoremap `; `.

" --- Espaces en fin de ligne ----------------------------------------------------------------
"= édition | supprimer les espaces en fin de ligne (tout le fichier, ou une plage)
command! -range=% StripWhitespace call my#edit#strip_whitespace(<line1>, <line2>)
"= édition | supprimer les espaces en fin de ligne : le fichier, la ligne ou la sélection (,Espace)
nnoremap <silent> <S-F7> :StripWhitespace<CR>
nnoremap <silent> <leader><S-Space> :StripWhitespace<CR>
nnoremap <silent> <leader><Space> :.StripWhitespace<CR>
xnoremap <silent> <leader><Space> :StripWhitespace<CR>

" --- Fenêtres ----------------------------------------------------------------------------------
" Ctrl+hjkl et flèches : changer de fenêtre (tmux-navigator les reprend s'il
" est chargé, pour passer aussi d'un panneau tmux à l'autre).
"= fenêtres | changer de fenêtre (et de panneau tmux, si tmux-navigator est chargé)
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
xnoremap <C-h> <Esc><C-w>h
xnoremap <C-j> <Esc><C-w>j
xnoremap <C-k> <Esc><C-w>k
xnoremap <C-l> <Esc><C-w>l
"= fenêtres | changer de fenêtre aux flèches
nnoremap <Up> <C-w>k
nnoremap <Down> <C-w>j
nnoremap <Left> <C-w>h
nnoremap <Right> <C-w>l
"= fenêtres | élargir / rétrécir la fenêtre de 4 colonnes
nnoremap <leader>< 4<C-w><
nnoremap <leader>> 4<C-w>>

"= saisie | déplacer le curseur en insertion
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>
"= saisie | déplacer le curseur en ligne de commande
cnoremap <C-h> <Left>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
cnoremap <C-l> <Right>

" --- Onglets ---------------------------------------------------------------------------------
"= onglets | nouvel onglet en dernier (=t), fermer l’onglet (=w)
nnoremap <localleader>t :$tabnew<CR>
nnoremap <localleader>w :tabclose<CR>
"= onglets | premier (=j) / dernier (=k) onglet
nnoremap <localleader>j :tabfirst<CR>
nnoremap <localleader>k :tablast<CR>
"= onglets | onglet précédent (=h) / suivant (=l)
nnoremap <localleader>h :tabprevious<CR>
nnoremap <localleader>l :tabnext<CR>
if has('gui_running')
"= onglets | premier, dernier, précédent, suivant onglet aux flèches Alt (interface graphique)
  noremap <A-Up> :tabfirst<CR>
  noremap <A-Down> :tablast<CR>
  noremap <A-Left> :tabprevious<CR>
  noremap <A-Right> :tabnext<CR>
"= onglets | premier, dernier, précédent, suivant onglet à Alt-kjhl (interface graphique)
  noremap <A-k> :tabfirst<CR>
  noremap <A-j> :tablast<CR>
  noremap <A-h> :tabprevious<CR>
  noremap <A-l> :tabnext<CR>
endif

" --- Buffers ---------------------------------------------------------------------------------
"= buffers | fermer le buffer en gardant la fenêtre (,x), buffer et fenêtre (,X), la fenêtre seule (,Ctrl-x)
nnoremap <silent> <leader>x :call my#buffers#close()<CR>
nnoremap <leader>X :bdelete<CR>
nnoremap <leader><C-x> :close<CR>
"= buffers | fermer les buffers vides
nnoremap <silent> <leader>bc :call my#buffers#clean_empty()<CR>
"= buffers | buffer suivant / précédent (aussi -b et 'b, d'unimpaired)
nnoremap <silent> <leader>n :bnext<CR>
nnoremap <silent> <leader>p :bprevious<CR>

" --- Quickfix (résultats de :vimgrep, :make, :helpgrep…) --------------------------------------
"= navigation | quickfix : résultat précédent / suivant, fichier précédent / suivant
nnoremap <leader><Left> :cprevious<CR>
nnoremap <leader><Right> :cnext<CR>
nnoremap <leader><Up> :cpfile<CR>
nnoremap <leader><Down> :cnfile<CR>

" --- Repliage ----------------------------------------------------------------------------------
"= repliage | ouvrir ou fermer le pli sous le curseur (Espace), avec ses plis imbriqués (Retour arrière)
nnoremap <Space> za
nnoremap <BS> zA
"= repliage | ouvrir (Maj-) ou fermer (Ctrl-) d’un niveau partout, basculer le repliage (Ctrl-Maj-)
nnoremap <S-BS> zr
nnoremap <C-BS> zm
nnoremap <C-S-BS> zi

"= édition | déplacer la ligne vers le haut / le bas (MacVim)
nnoremap <silent> <D-k> :<C-u>call my#edit#move_line(-1)<CR>
nnoremap <silent> <D-j> :<C-u>call my#edit#move_line(1)<CR>
inoremap <silent> <D-k> <C-o>:call my#edit#move_line(-1)<CR>
inoremap <silent> <D-j> <C-o>:call my#edit#move_line(1)<CR>
"= édition | déplacer la sélection vers le haut (K, Cmd-k) ou le bas (J, Cmd-j)
xnoremap <silent> K :<C-u>call my#edit#move_selection(-1)<CR>
xnoremap <silent> J :<C-u>call my#edit#move_selection(1)<CR>
xnoremap <silent> <D-k> :<C-u>call my#edit#move_selection(-1)<CR>
xnoremap <silent> <D-j> :<C-u>call my#edit#move_selection(1)<CR>

"= édition | la sélection en minuscules, puis Capitalisées, puis MAJUSCULES
xnoremap ~ y:call setreg('"', my#edit#twiddle_case(@"), getregtype('"'))<CR>gvP

"= écriture | aligner le tableau markdown au fil de la frappe (tabular)
inoremap <silent> <Bar> <Bar><Esc>:call my#edit#align_table()<CR>a

" --- Aide -------------------------------------------------------------------------------------------
"= aide | l’aide des raccourcis, engendrée depuis le code (:Keys git pour un thème)
command! -nargs=? -complete=customlist,my#keys#complete Keys call my#keys#show(<q-args>)
"= aide | ,? | l’aide des raccourcis (,? puis un thème avec :Keys)
nnoremap <silent> <leader>? :Keys<CR>
"= aide | aide sur le mot sous le curseur (,h), recherche dans toute l’aide (,H)
nnoremap <leader>h :help <C-r><C-w><CR>
nnoremap <leader>H :helpgrep <C-r><C-w><CR>

" --- Diff ----------------------------------------------------------------------------------------------
"= diff | reporter (Dp) ou récupérer (Dg) le bloc sous le curseur
nnoremap Dp :diffput<CR>
nnoremap Dg :diffget<CR>
"= diff | rafraîchir (Du), comparer ce buffer (Dt), quitter le diff (Do)
nnoremap Du :diffupdate<CR>
nnoremap Dt :diffthis<CR>
nnoremap Do :diffoff<CR>

" --- Fichiers de configuration --------------------------------------------------------------------
"= configuration | éditer le vimrc (,ev) puis le recharger (,sv)
nnoremap <silent> <leader>ev :call my#buffers#edit_real(g:my_dir . '/vimrc')<CR>
nnoremap <silent> <leader>sv :execute 'source ' . fnameescape(g:my_dir . '/vimrc')<CR>:echo 'vimrc rechargé'<CR>
"= configuration | éditer ~/.bashrc
nnoremap <silent> <leader>eb :call my#buffers#edit_real('~/.bashrc')<CR>
"= configuration | éditer les réglages propres à cette machine
nnoremap <silent> <leader>el :execute 'edit ' . fnameescape(g:my_local . '/vimrc.local')<CR>
"= thèmes | afficher tous les groupes de couleurs
nnoremap <silent> <leader>sc :source $VIMRUNTIME/syntax/hitest.vim<CR>

" --- Thèmes ----------------------------------------------------------------------------------------------
"= thèmes | basculer clair / sombre, pour cette session seulement
nnoremap <silent> <F5> :call my#colors#toggle_background()<CR>
inoremap <silent> <F5> <C-o>:call my#colors#toggle_background()<CR>
"= thèmes | thème suivant / précédent
nnoremap <silent> <leader>$n :call my#colors#cycle(1)<CR>
nnoremap <silent> <leader>$p :call my#colors#cycle(-1)<CR>
"= thèmes | choisir un thème (,$ liste, Alt-Espace amorce :Theme)
nnoremap <leader>$ :Theme<CR>
nnoremap <A-Space> :Theme<Space>

" --- Numéros de ligne relatifs, encodage, terminal -------------------------------------------------------
if exists('+relativenumber')
"= système | basculer les numéros de ligne relatifs
  nnoremap <silent> <F3> :set relativenumber!<CR>
endif
"= système | rouvrir le fichier dans un autre encodage
nnoremap <leader><C-e> :edit ++encoding=
"= système | terminal intégré dans un onglet (ou :shell si vim n’a pas +terminal)
if has('terminal')
  nnoremap <silent> <leader>q :tab terminal<CR>
else
  nnoremap <silent> <leader>q :shell<CR>
endif

" --- Surveillance de fichiers modifiés à l'extérieur (voir autoload/my/watch.vim) -------------------
"= système | recharger le fichier courant quand il change sur le disque (! : sans confirmation)
command! -bang WatchForChanges
      \ call my#watch#toggle(@%, {'toggle': 1, 'autoread': <bang>0})
"= système | même surveillance, tant qu’on reste dans ce buffer
command! -bang WatchForChangesWhileInThisBuffer
      \ call my#watch#toggle(@%, {'toggle': 1, 'autoread': <bang>0, 'while_in_this_buffer_only': 1})
"= système | même surveillance, pour tous les fichiers ouverts
command! -bang WatchForChangesAllFile
      \ call my#watch#toggle('*', {'toggle': 1, 'autoread': <bang>0})
