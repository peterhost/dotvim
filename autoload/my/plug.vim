" autoload/my/plug.vim — déclaration conditionnelle des plugins
"
" Un plugin dont la condition est fausse reste déclaré (PlugInstall l'installe,
" PlugClean ne le supprime pas), mais vim-plug ne le charge jamais : c'est ce
" qui permet de partager la même liste entre un vim 9 et un vieux vim 7.

" my#plug#add(repo, condition [, options]) : déclare le plugin.
function! my#plug#add(repo, cond, ...)
  let l:opts = a:0 ? copy(a:1) : {}
  let l:name = get(l:opts, 'as', fnamemodify(substitute(a:repo, '\.git$', '', ''), ':t'))
  if !exists('g:my_plug_off')
    let g:my_plug_off = {}
  endif
  if !a:cond || index(get(g:, 'my_disabled', []), l:name) >= 0
    let g:my_plug_off[l:name] = 1
    " ni chargement, ni commande de construction
    let l:opts = has_key(l:opts, 'as') ? {'as': l:opts.as} : {}
    let l:opts.on = []
  endif
  call plug#(a:repo, l:opts)
endfunction

" my#plug#on(name) : vrai si le plugin est déclaré, autorisé et installé.
function! my#plug#on(name)
  return exists('g:plugs') && has_key(g:plugs, a:name)
        \ && !has_key(get(g:, 'my_plug_off', {}), a:name)
        \ && isdirectory(g:plugs[a:name].dir)
endfunction

" my#plug#missing_syntax(file) : vrai si le vim local ne fournit pas ce fichier.
function! my#plug#missing_syntax(file)
  return empty(globpath($VIMRUNTIME, a:file))
endfunction
