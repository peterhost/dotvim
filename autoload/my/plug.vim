" autoload/my/plug.vim — déclaration conditionnelle des plugins
"
" Un plugin dont la condition est fausse reste déclaré (PlugInstall l'installe,
" PlugClean ne le supprime pas), mais vim-plug ne le charge jamais : c'est ce
" qui permet de partager la même liste entre un vim 9 et un vieux vim 7.
scriptencoding utf-8

" my#plug#add(repo, condition [, options] [, raison]) : déclare le plugin.
" La RAISON dit ce qui manque sur cette machine quand la condition est fausse — pas la
" condition telle qu'elle est écrite. Elle s'affiche dans « vrc greffons » : devant un
" greffon écarté, on doit lire pourquoi, et non deviner entre deux causes possibles.
" Les deux arguments facultatifs se reconnaissent à leur type, dans n'importe quel ordre.
function! my#plug#add(repo, cond, ...)
  let l:opts = {}
  let l:raison = ''
  for l:a in a:000
    if type(l:a) == type({})
      let l:opts = copy(l:a)
    elseif type(l:a) == type('')
      let l:raison = l:a
    endif
  endfor
  let l:name = get(l:opts, 'as', fnamemodify(substitute(a:repo, '\.git$', '', ''), ':t'))
  if !exists('g:my_plug_off')
    let g:my_plug_off = {}
  endif
  if index(get(g:, 'my_disabled', []), l:name) >= 0
    let g:my_plug_off[l:name] = 'écarté à la main (g:my_disabled)'
  elseif !a:cond
    let g:my_plug_off[l:name] = l:raison !=# '' ? l:raison : 'condition non remplie sur cette machine'
  endif
  if has_key(g:my_plug_off, l:name)
    " ni chargement, ni commande de construction
    let l:opts = has_key(l:opts, 'as') ? {'as': l:opts.as} : {}
    let l:opts.on = []
  endif
  call plug#(a:repo, l:opts)
endfunction

" my#plug#raison(nom) : pourquoi ce greffon est écarté ici, ou '' s'il ne l'est pas.
function! my#plug#raison(nom)
  return get(get(g:, 'my_plug_off', {}), a:nom, '')
endfunction

" my#plug#report() : une ligne « état|nom|raison » par greffon déclaré, pour « vrc greffons ».
" État : installé, manquant (déclaré et voulu, mais absent) ou écarté (condition
" fausse sur cette machine : vim trop vieux, outil absent).
function! my#plug#report()
  let l:out = []
  for l:nom in sort(keys(get(g:, 'plugs', {})))
    if has_key(get(g:, 'my_plug_off', {}), l:nom)
      let l:etat = 'écarté'
    elseif isdirectory(g:plugs[l:nom].dir)
      let l:etat = 'installé'
    else
      let l:etat = 'manquant'
    endif
    call add(l:out, l:etat . '|' . l:nom . '|' . my#plug#raison(l:nom))
  endfor
  return l:out
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
