" Les .txt sont traités comme du markdown, sauf les fichiers d'aide de vim
" (dossiers doc/) et les fichiers déjà identifiés autrement.
autocmd BufRead,BufNewFile *.txt
      \ if expand('<afile>:p') !~# '[/\\]doc[/\\]' && &filetype !=# 'help'
      \ |   set filetype=markdown
      \ | endif
