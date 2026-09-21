" .json : type json natif si le vim le connaît, sinon javascript (vieux vim)
autocmd BufRead,BufNewFile *.json
      \ if empty(globpath($VIMRUNTIME, 'syntax/json.vim')) | setfiletype javascript | endif
