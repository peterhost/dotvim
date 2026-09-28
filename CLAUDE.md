# Conventions de ce dépôt (`~/.vim`)

À lire avant toute modification. Ces règles ne sont pas des préférences de style :
chacune vient d'un problème rencontré sur une des machines où cette configuration
tourne, et chacune est vérifiée par `make check`.

## 1. L'aide des raccourcis vit à côté du code

Tout raccourci et toute commande maison porte une **annotation** sur la ligne
juste au-dessus de lui :

```vim
"= buffers | buffer suivant / précédent (aussi -b et 'b, d'unimpaired)
nnoremap <silent> <leader>n :bnext<CR>
nnoremap <silent> <leader>p :bprevious<CR>
```

- Format : `"= thème | description`, en français, sans majuscule initiale.
- Une annotation vaut pour **toutes** les lignes de mapping qui la suivent
  immédiatement : plusieurs modes, ou les deux branches d'un `if`, ne sont
  décrits qu'une fois (les touches sont alors jointes par ` / `).
- Quand la liste mécanique des touches serait illisible, un troisième champ la
  remplace **à l'affichage** : `"= polices | ,1 … ,9 | choisir une police`.
- Thèmes existants : `sh bin/keys --themes`. En créer un nouveau demande de
  l'ajouter à `ORDRE`, en tête de `bin/keys`, pour qu'il s'affiche au bon rang.
- `sh bin/keys --todo` liste ce qui n'est pas annoté, `sh bin/keys` affiche
  l'aide, `make keys` régénère `doc/raccourcis.txt` et la section du README.

`test/keys.sh` (dans `make check`) **fait échouer la batterie** si un raccourci
chargé par vim n'est pas décrit, ou si une annotation ne décrit plus rien. Il
compare les annotations aux raccourcis réellement vivants (`maplist()`), pas au
texte : un raccourci construit dynamiquement n'y échappe pas.

Écrire les touches comme vim les nomme (`K` et non `<S-k>`, `<C-S-BS>` et non
`<S-C-BS>`) : sinon la comparaison échoue à juste titre.

## 2. Le parc est hétérogène, la dégradation est douce

macOS (plusieurs versions), Debian, Linux Mint, NAS Synology, Cygwin. Un outil
absent ne doit jamais provoquer d'erreur au démarrage, seulement une
fonctionnalité en moins.

- Trois niveaux : `full` (vim ≥ 8.0 avec jobs, timers, lambda), `compat`
  (7.3–7.4), `minimal` (vim-tiny, sans `+eval`). Les `set` de base sont **hors**
  de tout bloc `if`, pour que vim-tiny les lise.
- Vimscript compatible **7.3** : pas de lambda, pas d'`execute()`, pas de
  `has('patch-…')`, et `exists('+option')` avant toute option récente.
- Déclarer un plugin sous condition (`config/plugins.vim`, via `my#plug#add`)
  plutôt que le charger et espérer.
- **Aucun `system()` au démarrage** (coûteux sur Cygwin et sur les NAS) :
  `executable()` suffit.

## 3. Les scripts sont du sh POSIX

`bin/*` et `test/*` tournent sous `sh`, `dash` et le busybox ash des Synology :
pas de `[[`, pas de tableaux, pas de `local`, pas de `${var,,}`. Toujours
`${VAR}` quand un caractère accentué suit. Comparer des chemins avec `pwd -P`
(sur macOS, `/var` est un lien vers `/private/var`).

Codes de sortie communs : `0` conforme, `1` erreur, `2` usage, `3` dégradé,
`4` absent, `5` mise à jour disponible. Le JSON va sur **stdout**, sur une seule
ligne ; la progression et les messages vont sur **stderr**.

## 4. Rien hors de `~/.vim`

Aucune écriture ailleurs que dans le dépôt : les données propres à la machine
vont dans `local/` (historique, annulations, sessions, vues, dictionnaire,
jeton gist, journaux, cache ctrlp), jamais dans `~/.cache` ni `~/.viminfo`.
Un déploiement ne laisse **aucun reste** : `bin/install --clean` et
`bin/install --check` (code 3) s'en assurent, et `test/install.sh` le vérifie.

## 5. Ce dépôt est public

Aucun nom de machine, alias ssh, adresse IP ou de courriel, chemin de home
nommé — y compris dans un test, un exemple ou un commentaire. La liste des
littéraux interdits est **hors du dépôt** (`~/.dotlib/local/mots-interdits`) :
l'écrire ici publierait ce qu'elle protège. `test/anti-fuite.sh` vérifie.

## 6. Les outils ignorent le parc

`bin/install`, `bin/deploy-local` et `bin/update-plugins` s'exécutent sur la
machine courante et se pilotent par arguments. Ils ne connaissent **aucune**
machine : c'est l'appelant (la session `ssh`, outil `parc`) qui apporte cette
connaissance. Ne jamais y ajouter d'hôte, ni de liste de machines.

## 7. Contrats extérieurs

- **dotlib** (configuration shell) : lecture seule de `~/.dotlib/local/theme.conf`
  et des variables `DOTLIB_THEME_EFF` / `DOTLIB_PALETTE_EFF`, pour accorder le
  thème de vim à celui du shell. Aucune dépendance dure : absent, on garde le
  thème de vim.
- **Format d'échange des raccourcis** : `sh bin/keys --tsv` donne
  `source⇥thème⇥touches⇥description⇥portée`, convenu avec `~/.bash` (`bindhelp`)
  pour que les deux aides s'affichent ensemble.
- **`bin/install --check --json`** : contrat lisible par un programme, utilisé
  par l'onglet « déploiements tiers » de `parc`. Ajouter des champs, oui ;
  en retirer ou en renommer, seulement en le signalant.

## 8. Commits

En français, une unité fonctionnelle par commit, message à l'impératif ou
nominal (`Buffers : ,n et ,p pour passer au suivant / précédent`). `make check`
vert avant de pousser.
