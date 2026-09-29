# Configuration vim

Une configuration vim unique pour des machines très différentes : macOS (plusieurs versions), Debian, Mint, NAS Synology, Cygwin, WSL et, plus rarement, Windows.

**Principe : si quelque chose manque, on s'en passe sans bruit.** Un plugin, une option de vim ou un outil externe absent est ignoré. Aucune erreur au démarrage, du vim-tiny au vim 9.

## Installation

```sh
git clone https://github.com/peterhost/dotvim.git ~/.vim   # ou git@github.com:peterhost/dotvim.git
cd ~/.vim && sh bin/install                                # ou : make
```

`sh bin/install` (ou `make`, s'il est installé) lance l'installeur guidé :

1. **Diagnostic.** Il affiche le système, la version et les capacités de vim, le niveau prévu, l'accès à GitHub (https et ssh réellement testés), les outils présents et, sur un NAS, les paquets opkg manquants.
2. **Choix.** Installer, essayer à côté de la config actuelle, ou désinstaller. Puis la branche, et l'installation des plugins.
3. **Récapitulatif.** Il demande une confirmation, exécute, puis vérifie que vim démarre sans erreur.

| Commande | Effet |
|---|---|
| `sh bin/install --check` | diagnostic seul, aucune action ; code de sortie 3 si quelque chose est dégradé |
| `sh bin/install --clean` | supprime les restes (anciens fichiers, transitoires, vieilles sauvegardes) |
| `sh bin/install --yes` / `make install` | installe sans poser de question (ssh, scripts) |
| `sh bin/install --try` / `make try` | essai à côté de la config actuelle, sans rien activer |
| `make update` | `git pull`, puis mise à jour des plugins (ou `sh bin/update-plugins`) |
| `sh bin/install --uninstall` / `make uninstall` | retire la config et restaure la sauvegarde |
| `make check` | batterie de tests (`VIMS="vim /autre/vim"` pour en tester plusieurs) |
| `make themes` | ouvre le fichier d'essai des thèmes |

Ce que fait l'installation :
- **Tout vit dans `~/.vim/`.** Depuis vim 7.4, vim lit directement `~/.vim/vimrc` et `~/.vim/gvimrc`. L'installeur met donc de côté l'ancien `~/.vimrc` (et `~/.gvimrc`) dans `~/.vim/local/backup/`, sans rien recréer dans `$HOME`. Un fichier `~/.vimrc` d'une ligne n'est écrit que pour un vim plus ancien, ou pour une config clonée ailleurs que dans `~/.vim`.
- Les anciens `~/.vimrc.local` et `~/.gvimrc.local` sont déplacés dans `~/.vim/local/` s'ils ont du contenu, et retirés s'ils sont vides.
- Pour changer de branche, **les modifications locales de `~/.vim` sont supprimées** : la liste est affichée et une confirmation est demandée. Les dossiers ignorés (`plugged/`, `local/`…) ne sont pas touchés.
- Les plugins sont installés dans `~/.vim/plugged/`, qui n'est jamais versionné.
- Les restes de l'ancienne configuration (`bundle/` de Vundle, `~/.vim-fuf-data`, `~/.viminfo.vimnew`) sont listés avec leur taille, puis supprimés après confirmation.
- **Aucun reste.** En fin d'installation, les restes sont supprimés : anciens fichiers d'une config précédente (`colors/default-light.vim`, `colors/dim.vim`, `spell/*.add` de la racine une fois recopiés dans `local/spell/`, `.netrwhist`, `install.log` de la racine), fichiers transitoires, verrou de mise à jour périmé, sauvegardes au-delà des 3 plus récentes, et journal borné à 500 lignes. Vos données (`local/spell/`, `viminfo`, `undo/`, `sessions/`, `views/`, `*.local`) ne sont jamais touchées. `--check` les signale, `--clean` les supprime.
- Rien n'est écrit hors de `$HOME`, et `sudo` n'est jamais utilisé : l'installeur donne les commandes, c'est vous qui les lancez.

### Accès à GitHub

L'installeur teste https et ssh, puis s'adapte :

| Situation | Ce qu'il propose |
|---|---|
| https en panne, ssh OK (NAS sans `git-http`) | d'abord `sudo opkg install git-http`, la vraie correction. En repli, une règle qui fait passer les URL GitHub par ssh, écrite dans `~/.config/git/config` (elle vaut alors pour tout git sur la machine) |
| ssh en panne, https OK (compte sans clé SSH) | passer l'adresse du dépôt en https, pour que `git pull` fonctionne |
| les deux en panne | vim fonctionne sans plugins, et le dit |

### NAS Synology (Entware)

- git, fzf et les autres outils Entware sont dans `/opt/bin` et `/opt/sbin`, ajoutés au `PATH` par le `.bashrc` interactif. L'installeur et la mise à jour des plugins les cherchent aussi à ces endroits.
- opkg demande sudo : l'installeur vérifie les paquets au lancement et donne la commande exacte. Il consulte `opkg list` s'il le peut, sinon `~/opkglist.txt` (la sortie de `opkg list`, à déposer soi-même).
- Paquets utiles :
  - `git-http` (**indispensable** pour https) ;
  - `fzf`, `ripgrep`, `ctags`, `libxml2-utils` et `make`, s'ils existent dans le dépôt de la machine.

  Si `ctags` ou `rg` affichent un avertissement `libpcre2`, lancez `sudo opkg upgrade libpcre2`.
- **N'installez pas le paquet `vim` d'Entware** : c'est une version « tiny », qui masquerait le vim du système.

**Windows natif** (sans sh) : clonez dans `%USERPROFILE%\vimfiles`, puis créez `%USERPROFILE%\_vimrc` contenant `source ~/vimfiles/vimrc`. Lancez ensuite `:PlugInstall` dans vim. Cygwin, MSYS2 et WSL utilisent `sh bin/install` normalement.

## Piloter le déploiement depuis un autre outil

Ces commandes servent à un appelant tiers (interface de déploiement, supervision…). **Cette configuration ne connaît aucune machine** : ni nom d'hôte, ni alias ssh, ni adresse. Tout vient des arguments, et chaque commande agit sur la machine où elle tourne. C'est à l'appelant d'apporter la connaissance du parc et de faire le ssh.

```sh
# déployer sur une machine distante, même si ~/.vim n'y existe pas encore :
# le script est envoyé par ssh, et clone depuis GitHub
ssh <hôte> 'sh -s -- --yes --json' < ~/.vim/bin/deploy-local

# état d'une machine, installée ou non (répond toujours une ligne JSON)
ssh <hôte> 'sh -s -- --check --json' < ~/.vim/bin/deploy-local

# ce qui serait fait, sans rien modifier
ssh <hôte> 'sh -s -- --dry-run --json' < ~/.vim/bin/deploy-local
```

| Commande | Rôle |
|---|---|
| `bin/deploy-local` | **installe de zéro** (clone depuis GitHub si le dossier est absent) ou met à jour, puis installe, sur la machine courante. `--dir`, `--repo-url`, `--branch`, `--yes`, `--no-plugins`, `--json`, `--dry-run`. Bascule l'adresse du dépôt en https si ssh échoue (compte sans clé) |
| `bin/install --check --json` | état de la machine sur une seule ligne : OS, vim et niveau, git, joignabilité GitHub, branche, commit, greffons installés / déclarés / manquants (**avec leurs noms**) / écartés sur cette machine, restes, paquets manquants, état des mises à jour |
| `bin/install --clean` | supprime les restes |
| `bin/deploy-local --purge --yes` | **effacement complet** : restaure l'ancienne configuration, puis supprime le dossier entier, `local/` compris (dictionnaire, sessions, annulations, historique vim de la machine). `~/.viminfo` n'est pas touché. Refuse tout dossier qui n'est pas cette configuration, et exige un `--yes` écrit explicitement |
| `bin/update-plugins` | installe et met à jour les plugins (`--if-due N` jours, `--if-due-minutes N`) |

`bin/deploy-local --check` est le point d'entrée unique pour l'état : il répond **même sur une machine où la configuration est absente** (`"installed": false`, `"status": "absent"`), et imbrique l'état complet de `bin/install --check --json` dans le champ `state`. Le champ `active` distingue le dossier **présent** de la configuration **lue par vim** : un dépôt cloné ailleurs et non branché donne `"active": false`, et, à l'inverse, un ancien lien `~/.vimrc` qui mène à ce dossier suffit à la rendre active (`active_reason` le dit). Avec `--remote`, il interroge le dépôt (seul cas où le réseau sert) et renseigne `remote_commit` et `up_to_date`. `--https` force l'adresse GitHub en https, pour un compte sans clé SSH.

L'état dit aussi ce que la machine sait de **dotlib** (la bibliothèque commune au shell) : `dotlib` (booléen), `dotlib_source` (`environnement`, `fichier`, `installé` ou `aucun`), `dotlib_theme`, `dotlib_palette`, et `theme_follows` — `fond`, parce que vim ne suit que le clair/sombre du shell, jamais sa palette. dotlib absent, vim garde son thème : ce n'est pas une dépendance, seulement un accord.

Deux comptes distincts pour les greffons : `plugins_missing` (+ `plugins_missing_names`) désigne ce qui **devrait** être là et manque — c'est réparable, et vim s'en charge seul ; `plugins_skipped` (+ `plugins_skipped_names`) désigne ce qui est **écarté sur cette machine** (vim trop ancien, outil absent) et n'a donc pas à y être. Seul le premier rend l'état « dégradé ».

**Codes de sortie**, communs à ces commandes :

| Code | Sens |
|---|---|
| 0 | conforme, ou rien à faire |
| 1 | erreur |
| 2 usage | option inconnue |
| 3 | déployé mais dégradé (plugins manquants, restes, outil absent) |
| 4 | configuration absente (à installer) |
| 5 | mise à jour disponible (avec `--dry-run`, ou `--check --remote`) |

`bin/install --uninstall` **désactive** (il restaure la configuration précédente) mais ne supprime rien : le dossier, les greffons et `local/` restent. Il prévient d'ailleurs quand la configuration reste active malgré tout — par exemple si le fichier restauré est un ancien lien `~/.vimrc` qui pointe vers ce même dossier. Pour tout effacer, c'est `bin/deploy-local --purge --yes`.

En mode `--json`, la sortie standard ne contient **que** le JSON, sur une seule ligne ; les étapes sont écrites au fil de l'eau sur la **sortie d'erreur**, ce qui permet de suivre un déploiement en direct.

## `vrc` : la configuration vim en ligne de commande

`vrc` est à la configuration vim ce que `brc` est à la configuration bash.
Elle vit dans le dépôt (`bin/vrc`, sh POSIX) et marche partout, même avant
toute installation :

```sh
vrc                     la liste des commandes
vrc ui                  tout à la fois, en onglets, dans le terminal (= vrc interface)
vrc raccourcis [THÈME]  l'aide des raccourcis, engendrée depuis le code
vrc etat [--json]       vim, niveau, dépôt, greffons, thème, restes
vrc greffons            installés, écartés sur cette machine, manquants
vrc themes              thèmes disponibles, et celui en cours
vrc journal [--install] les dernières lignes du journal
vrc maj                 mettre à jour le dépôt puis les greffons
vrc nettoyer            supprimer les restes (les données locales sont intactes)
vrc verifier [--rapide] la batterie de tests
vrc edit [NOM]          ouvrir un fichier de configuration dans vim
vrc cd · vrc version
```

Les erreurs vont sur la sortie d'erreur, préfixées `vrc :`, et les codes de
sortie sont ceux des autres outils du dépôt (`0` conforme, `1` erreur,
`2` usage, `3` dégradé). Aucune question n'est posée hors d'un terminal.

**Dans bash** : `shell/vrc.bash` ajoute la fonction `vrc` (pour que `vrc cd`
change vraiment de dossier), `vivrc`, la complétion des sous-commandes, des
thèmes et des fichiers, et le pont `brc vim …`. Le chargement est **silencieux
et ne lance aucun processus**. La configuration bash le charge d'elle-même ;
à la main :

```sh
[ -r ~/.vim/shell/vrc.bash ] && . ~/.vim/shell/vrc.bash
```

**`vrc ui`** (ou `vrc interface`) ouvre six onglets : raccourcis par thème, état,
greffons, thèmes, journaux, commandes. Les raccourcis montrés sont **ceux de vim, et
eux seuls** : `brc ui` montre ceux du shell. Un raccourci ne traverse la frontière que
s'il n'a de sens que par l'accord des deux outils, et le producteur dit alors lequel
et pourquoi.

| Touche | Effet |
|---|---|
| `←` `→`, `1`…`6` | changer d'onglet |
| `Tab` | passer de la liste des sections au contenu, et retour |
| `↑` `↓`, `j` `k` | défiler le volet actif, ligne à ligne |
| `Ctrl-d` `Ctrl-u` | demi-page · `Ctrl-f` `Ctrl-b`, `PgUp` `PgDn`, `Espace` : page |
| `g` `G` | début · fin du volet actif |
| molette, clic | défiler le volet sous le pointeur, ou choisir une section |
| `/` puis Entrée | filtrer · `Échap` efface le filtre |
| `r` · `q` | recharger l'onglet · quitter |

L'affichage est celui du **socle commun** de dotlib (`lib/onglets.py`), partagé avec
la configuration bash pour que les deux interfaces soient identiques et corrigées au
même endroit. Ce dépôt ne porte que ses producteurs de contenu : où trouver les
données, et dans quel ordre les montrer. Si le socle est absent, trop ancien, ou d'une
API inattendue, `vrc ui` affiche le même contenu **à la suite**, sans onglets.

Les lignes trop longues se replient sur la largeur du terminal : rien n'est coupé.
Les couleurs suivent le **thème du shell** (`brc theme`) en lisant les palettes
publiées par dotlib ; sans dotlib, ou sur un terminal à moins de 256 couleurs, les
couleurs de base servent, et en monochrome l'affichage reste lisible. Dans tmux, la
souris demande `set -g mouse on`. Sans `python3`, ou dans un terminal trop limité,
le contenu s'affiche à la suite.

L'apparence vient de `shell/affichage.sh`, qui reprend les noms de la couche
d'affichage de dotlib (`tui_ok`, `C_R_KEY`…) sans en dépendre : dotlib demande
bash, alors que `vrc` doit tourner sous le `sh` des NAS. Le clair/sombre, lui,
suit bien dotlib quand il est présent.

## Essayer une autre branche sans rien casser

```sh
sh bin/install --try --branch refactor   # crée ~/.vimnew (git worktree)
vim -u ~/.vimnew/vimrc                   # config, plugins et historique séparés
```

## Plugins

- Ils sont déclarés dans `config/plugins.vim` (vim-plug).
- Ils sont installés par `make`, ou **au premier lancement de vim** si ce n'est pas encore fait.
- Ils sont **mis à jour automatiquement en arrière-plan** au lancement de vim, au plus une fois tous les 7 jours. Vim n'est ni ralenti ni bloqué, et les nouvelles versions sont prises en compte au démarrage suivant.
- L'installation **dit où elle en est** : les greffons à construire sont annoncés d'avance, chaque clonage apparaît au fil de l'eau (`greffon 12/54 : nom`), la fin des clonages et le début de la construction (npm, téléchargements) sont signalés, avec un battement toutes les 15 secondes pendant cette phase longue, puis la vérification.
- Elle **vérifie son résultat** : un échec est nommé avec sa cause (`greffon x : échec — fatal: …`), les manquants sont retentés une fois, et le message final ne parle de succès que si tout est là.
- Si une mise à jour échoue, vim le signale **une fois**, au démarrage suivant, avec le conseil adapté (par exemple `git-http` sur un NAS).
- Le journal s'ouvre avec `:PluginsUpdateLog`. Le délai se règle avec `let g:my_autoupdate_days = 14` dans `~/.vim/local/vimrc.local` ; `0` désactive la mise à jour automatique.

## Niveaux de fonctionnement

| Niveau | Condition | Contenu |
|---|---|---|
| complet | vim ≥ 8 avec jobs et timers | tout : ALE, fzf, snippets, thèmes modernes, couleurs 24 bits |
| compatibilité | vim 7.3 – 7.4 | plugins en vimscript pur (ctrlp à la place de fzf), sans ALE ni snippets |
| minimal | vim-tiny, ou pas de plugins | options, raccourcis et thème de secours |

Chaque plugin a sa condition de chargement. S'il ne convient pas au vim du moment, il est déclaré mais jamais chargé.

## Thèmes

Le thème par défaut est **everforest**, en sombre. Il s'adapte au terminal :

| Terminal | Rendu |
|---|---|
| truecolor / GUI | couleurs 24 bits |
| 256 couleurs | everforest en 256 couleurs, ou PaperColor sur un vieux vim |
| console Linux, 8-16 couleurs | noctu, qui utilise la palette du terminal |

| Commande | Effet |
|---|---|
| `:Theme <Tab>` | liste les thèmes affichables ici |
| `:Theme edge light` | choisit un thème et un fond, durablement |
| `<F5>` | bascule clair / sombre, **pour cette session seulement** |
| `:Theme` (sans argument) | dit le thème courant et d'où vient la décision |
| `,$n` / `,$p` | thème suivant / précédent |

Le dernier choix fait avec `:Theme` est mémorisé pour chaque machine ; `<F5>` ne vaut que pour la session en cours. Thèmes disponibles : everforest, edge, catppuccin, solarized8, gruvbox8, nord, tokyonight, lucius, PaperColor, pencil (écriture) et noctu (console). Sur vim 9, s'ajoutent retrobox, wildcharm et lunaperche.

### Accord avec le thème du shell

Si les outils de shell partagent un réglage de thème (dépôt `dotlib`, lu dans `$DOTLIB_THEME_EFF` ou `~/.dotlib/local/theme.conf`), vim **suit le clair/sombre** pour ne pas être sombre dans un terminal clair. Ce réglage est seulement lu : la configuration reste utilisable seule, sans `dotlib`.

- **La palette n'est pas suivie par défaut** (everforest reste le thème) ; pour qu'elle le soit : `let g:my_follow_palette = 1` dans `~/.vim/local/vimrc.local`. Les palettes reconnues sont catppuccin, gruvbox, nord, solarized, tokyonight, everforest, edge, lucius, papercolor et pencil ; `xterm` (la palette historique du shell) n'a pas d'équivalent vim, et une palette inconnue ou un thème non affichable dans ce terminal laissent le thème de vim inchangé.
- **Priorités** : un réglage explicite dans `vimrc.local`, puis le dernier `:Theme`, puis le shell, puis le défaut. `<F5>` passe par-dessus, pour la session.

Les fautes d'orthographe (`set spell`) restent visibles dans tous les cas :
- **soulignement ondulé en couleur** sur les terminaux qui le gèrent (iTerm2, kitty, WezTerm…) ;
- **souligné et en couleur** en console.

## Réglages propres à une machine : `~/.vim/local/vimrc.local`

Ce fichier est facultatif et jamais versionné. S'il existe, il est lu au démarrage (`,el` l'ouvre). L'ancien emplacement, `~/.vimrc.local`, est encore lu. Exemples :

```vim
let g:my_theme = 'lucius'          " autre thème par défaut
let g:my_background = 'light'      " fond clair
let g:my_force_tier = 'compat'     " forcer un niveau (NAS poussif…)
let g:my_disabled = ['ale']        " ne pas charger certains plugins
let g:my_autoupdate_days = 0       " pas de mise à jour automatique
let g:my_powerline_fonts = 1       " polices patchées pour airline
let g:my_undercurl = 1             " le terminal gère le soulignement ondulé
```

`~/.vim/local/gvimrc.local` fait de même pour l'interface graphique (police, taille de fenêtre…).

**Données propres à la machine** (dossier `~/.vim/local/`, jamais versionné) :
- l'historique (`viminfo`, repris une fois de l'ancien `~/.viminfo`) ;
- l'annulation persistante, les vues, les sessions ;
- le thème choisi ;
- les caches ;
- le jeton de vim-gist ;
- l'état des mises à jour ;
- les sauvegardes de l'installeur.

## Organisation

```
vimrc                  point d'entrée : socle pour vim-tiny, puis config/*
config/env.vim         détection du dossier, de l'OS, du niveau et du terminal
config/plugins.vim     liste des plugins et conditions de chargement
config/options.vim     options
config/colors.vim      thème
config/highlights.vim  espaces en fin de ligne, tabulations, lignes longues
config/mappings.vim    raccourcis globaux
config/plugins/*.vim   réglages par plugin
autoload/my/*.vim      fonctions (chargées à la demande)
after/ftplugin/*.vim   réglages par type de fichier
ftdetect/              types de fichiers (.txt → markdown, mql4…)
colors/                thèmes de secours (PaperColor, lucius, noctu)
bin/install            installeur guidé
bin/deploy-local       déployer ou mettre à jour, sur la machine courante
bin/update-plugins     mise à jour des plugins (manuelle ou en arrière-plan)
bin/keys               engendre l'aide des raccourcis (annotations « "= »)
bin/vrc                la configuration en ligne de commande (vrc)
bin/vrc-interface      les onglets de « vrc interface » (python3 curses)
shell/vrc.bash         la fonction vrc, la complétion, le pont brc vim …
shell/affichage.sh     couleurs et tableaux (noms de dotlib, sans en dépendre)
doc/raccourcis.txt     aide vim ENGENDRÉE (:help raccourcis) — ne pas l'éditer
test/                  batterie de tests (make check)
local/                 données et réglages propres à la machine (non versionné)
plugged/               plugins installés (non versionné)
```

## Raccourcis

Le leader est `,` et le localleader est `=`.

Cette liste est **engendrée depuis le code** par `bin/keys` : chaque raccourci
porte sa description juste au-dessus de lui dans les fichiers de configuration,
et `make check` échoue si l'un d'eux n'est pas documenté. Pour la consulter :

```sh
sh bin/keys              # dans un terminal, tous les thèmes
sh bin/keys édition      # un seul thème
```

Dans vim : `,?` ou `:Keys`, `:Keys git` pour un thème, `:help raccourcis`.

<!-- raccourcis -->

**fichiers**

| Raccourci | Action |
|---|---|
| `,fd` | ouvrir un fichier du dossier du fichier courant |
| `,ff` | ouvrir un fichier (recherche floue) |
| `,fr` | rouvrir un fichier récent |
| `,t` | explorateur de fichiers (NERDTree) |

**buffers**

| Raccourci | Action |
|---|---|
| `,bc` | fermer les buffers vides |
| `,be / ,bt / ,bs / ,bv` | liste des buffers : ici (,be), bascule (,bt), partage horizontal (,bs) ou vertical (,bv) |
| `,fb` | choisir un buffer |
| `,ll / ,aa / ,az` | choisir un buffer (raccourcis historiques) |
| `,n / ,p` | buffer suivant / précédent (aussi -b et 'b, d'unimpaired) |
| `,x / ,X / ,Ctrl-x` | fermer le buffer en gardant la fenêtre (,x), buffer et fenêtre (,X), la fenêtre seule (,Ctrl-x) |

**fenêtres**

| Raccourci | Action |
|---|---|
| `↑ / ↓ / ← / →` | changer de fenêtre aux flèches |
| `,< / ,>` | élargir / rétrécir la fenêtre de 4 colonnes |
| `,sw / ,sm` | échanger deux fenêtres : ,sm marque la première, ,sw y place la seconde |
| `Ctrl-h / Ctrl-j / Ctrl-k / Ctrl-l` | changer de fenêtre (et de panneau tmux, si tmux-navigator est chargé) |
| `gf` | ouvrir le fichier sous le curseur dans un partage vertical |
| `Maj-F5` | basculer le redimensionnement automatique (golden ratio) |

**onglets**

| Raccourci | Action |
|---|---|
| `=h / =l` | onglet précédent (=h) / suivant (=l) |
| `=j / =k` | premier (=j) / dernier (=k) onglet |
| `=t / =w` | nouvel onglet en dernier (=t), fermer l’onglet (=w) |
| `Alt-↑ / Alt-↓ / Alt-← / Alt-→` | premier, dernier, précédent, suivant onglet aux flèches Alt (interface graphique) |
| `Alt-k / Alt-j / Alt-h / Alt-l` | premier, dernier, précédent, suivant onglet à Alt-kjhl (interface graphique) |

**sessions**

| Raccourci | Action |
|---|---|
| `,wl` | rouvrir la session la plus récente |
| `,ws / ,wo / ,ww` | suivre une nouvelle session (,ws), en ouvrir une (,wo, ,ww) |
| `,wv` | afficher la session suivie |
| `,wx` | mettre le suivi de session en pause |

**navigation**

| Raccourci | Action |
|---|---|
| `,← / ,→ / ,↑ / ,↓` | quickfix : résultat précédent / suivant, fichier précédent / suivant |
| `,fc` | aller à une modification (changes) |
| `,fj` | revenir à un saut précédent (jumps) |
| `,fl` | chercher une ligne du fichier courant |
| `,ft` | sauter à une étiquette (tags) |
| `,T` | liste des symboles du fichier (Tagbar) |
| `' / - / § / à` | accès direct à [ ] { } sans AltGr (clavier AZERTY) |
| `ù` | le % étendu de matchit : sauter à la parenthèse, la balise ou le mot-clé apparié |

**recherche**

| Raccourci | Action |
|---|---|
| `,/ / ,;` | éteindre la surbrillance des résultats |
| `,fg` | chercher dans les fichiers (ripgrep s’il est là, sinon :vimgrep) |
| `,g` | amorcer un :vimgrep dans l’arborescence |
| `* / #` | chercher la sélection, en avant (*) ou en arrière (#) *(mode visuel)* |
| `gv` | chercher la sélection dans les fichiers (:vimgrep) *(mode visuel)* |

**édition**

| Raccourci | Action |
|---|---|
| `,Ctrl-t` | aligner sur un motif (:Tabularize) |
| `,y` | lister les registres (vim-peekaboo les montre aussi en tapant " ou @) |
| `; / `;` | ; répète la dernière modification, `; retourne au dernier point modifié |
| `:LongLinesToggle` | signaler ou non les lignes trop longues |
| `:StripWhitespace` | supprimer les espaces en fin de ligne (tout le fichier, ou une plage) |
| `< / >` | indenter / désindenter sans perdre la sélection *(mode visuel)* |
| `~` | la sélection en minuscules, puis Capitalisées, puis MAJUSCULES *(mode visuel)* |
| `Cmd-k / Cmd-j` | déplacer la ligne vers le haut / le bas (MacVim) |
| `Ctrl-p / Ctrl-n` | juste après un collage : copie plus ancienne (Ctrl-p) ou plus récente (Ctrl-n) |
| `F8` | réindenter tout le fichier (ALEFix le remplace là où il est actif) |
| `gV` | resélectionner le dernier texte modifié ou collé |
| `K / J / Cmd-k / Cmd-j` | déplacer la sélection vers le haut (K, Cmd-k) ou le bas (J, Cmd-j) *(mode visuel)* |
| `Maj-Entrée` | insérer une ligne au-dessus sans passer en insertion |
| `Maj-F7 / ,Maj-Espace / ,Espace` | supprimer les espaces en fin de ligne : le fichier, la ligne ou la sélection (,Espace) |
| `p / P / gp / gP` | coller, en gardant l’historique des copies sous la main |
| `Q` | reformater le paragraphe ou la sélection |

**repliage**

| Raccourci | Action |
|---|---|
| `,Ctrl-Espace` | replier la balise HTML courante |
| `Espace / Retour arrière` | ouvrir ou fermer le pli sous le curseur (Espace), avec ses plis imbriqués (Retour arrière) |
| `Maj-Retour arrière / Ctrl-Retour arrière / Ctrl-Maj-Retour arrière` | ouvrir (Maj-) ou fermer (Ctrl-) d’un niveau partout, basculer le repliage (Ctrl-Maj-) |

**saisie**

| Raccourci | Action |
|---|---|
| `Ctrl-h / Ctrl-j / Ctrl-k / Ctrl-l` | déplacer le curseur en insertion *(mode insertion)* |
| `Ctrl-h / Ctrl-j / Ctrl-k / Ctrl-l` | déplacer le curseur en ligne de commande *(ligne de commande)* |
| `Espace` | quitter le mode visuel *(mode visuel)* |
| `jf / fj` | quitter la ligne de commande *(ligne de commande)* |
| `jf / fj` | quitter le mode insertion *(mode insertion)* |
| `Maj-Tab` | développer un snippet ou sauter au champ suivant *(mode insertion)* |

**écriture**

| Raccourci | Action |
|---|---|
| `,P` | aperçu du document (markdown-preview, sinon Marked 2 sous macOS) *(fichiers markdown)* |
| `|` | aligner le tableau markdown au fil de la frappe (tabular) *(mode insertion)* |

**langages**

| Raccourci | Action |
|---|---|
| `,d` | aller à la définition (raccourci de jedi-vim, conservé) *(fichiers python)* |
| `,E` | ouvrir la liste des erreurs (ALE) |
| `,h` | doc perl du mot ou du module sous le curseur *(fichiers perl)* |
| `,jsl / ,jsf` | vérifier (,jsl) ou corriger (,jsf) le fichier *(fichiers javascript)* |
| `,N` | usages du symbole (,N, car ,n va au buffer suivant) *(fichiers python)* |
| `,r / ,R` | renommer le symbole *(fichiers python)* |
| `]d / [d` | erreur suivante (]d) ou précédente ([d) |
| `=d` | commentaire JSDoc pour la fonction courante *(fichiers javascript)* |
| `=D` | documentation du projet avec l’outil jsdoc *(fichiers javascript)* |
| `aC / iC / aM / iM` | objets de texte : classe (aC, iC), fonction ou méthode (aM, iM) *(fichiers python)* |
| `F8` | corriger le fichier (eslint, prettier) *(fichiers javascript)* |
| `F8` | corriger le fichier (ruff) *(fichiers python)* |
| `F8` | reformater le fichier (jq) *(fichiers json)* |
| `gd` | aller à la définition *(fichiers javascript)* |
| `gd` | aller à la définition *(fichiers python)* |
| `K` | documentation du symbole sous le curseur *(fichiers python)* |

**git**

| Raccourci | Action |
|---|---|
| `,eq / ,Gq / ,sq / ,Gs` | gist QUIX (bookmarklets) : publier (,eq, ,Gq) ou éditer (,sq, ,Gs) |
| `,ga` | ajouter le fichier courant à l’index |
| `,gb` | ouvrir le fichier sur GitHub (:GBrowse) |
| `,gc` | valider les fichiers de l’index |
| `,gdc / ,gdh / ,gdo` | diff de l’index (,gdc), avec HEAD (,gdh), avec ORIG_HEAD (,gdo) |
| `,gg` | chercher dans les fichiers suivis (:Ggrep) |
| `,gl` | journal du dépôt (:Gclog) |
| `,gs` | état du dépôt (:Git) |

**diff**

| Raccourci | Action |
|---|---|
| `Dp / Dg` | reporter (Dp) ou récupérer (Dg) le bloc sous le curseur |
| `Du / Dt / Do` | rafraîchir (Du), comparer ce buffer (Dt), quitter le diff (Do) |

**greffons**

| Raccourci | Action |
|---|---|
| `,at` | afficher ou masquer la barre d’état (airline) |
| `,u` | arbre des annulations (undotree) |
| `:PluginsUpdateLog` | ouvrir le journal des mises à jour de greffons |

**thèmes**

| Raccourci | Action |
|---|---|
| `,$ / Alt-Espace` | choisir un thème (,$ liste, Alt-Espace amorce :Theme) |
| `,$n / ,$p` | thème suivant / précédent |
| `,sc` | afficher tous les groupes de couleurs |
| `:Theme` | choisir le thème et le fond (:Theme everforest light) |
| `F5` | basculer clair / sombre, pour cette session seulement |

**aide**

| Raccourci | Action |
|---|---|
| `,?` | l’aide des raccourcis (,? puis un thème avec :Keys) |
| `,fh` | chercher une rubrique d’aide |
| `,h / ,H` | aide sur le mot sous le curseur (,h), recherche dans toute l’aide (,H) |
| `,h` | aide sur le MOT complet sous le curseur *(dans l’aide)* |
| `:Keys` | l’aide des raccourcis, engendrée depuis le code (:Keys git pour un thème) |
| `Entrée / Retour arrière` | suivre un lien (Entrée), revenir en arrière (Retour arrière) *(dans l’aide)* |
| `o / O` | option suivante (o) ou précédente (O) *(dans l’aide)* |
| `s / S` | sujet suivant (s) ou précédent (S) *(dans l’aide)* |

**configuration**

| Raccourci | Action |
|---|---|
| `,eb` | éditer ~/.bashrc |
| `,el` | éditer les réglages propres à cette machine |
| `,ev / ,sv` | éditer le vimrc (,ev) puis le recharger (,sv) |

**système**

| Raccourci | Action |
|---|---|
| `,Ctrl-e` | rouvrir le fichier dans un autre encodage |
| `,q` | terminal intégré dans un onglet (ou :shell si vim n’a pas +terminal) |
| `,rr` | redessiner l’écran |
| `:WatchForChanges` | recharger le fichier courant quand il change sur le disque (! : sans confirmation) |
| `:WatchForChangesAllFile` | même surveillance, pour tous les fichiers ouverts |
| `:WatchForChangesWhileInThisBuffer` | même surveillance, tant qu’on reste dans ce buffer |
| `F3` | basculer les numéros de ligne relatifs |
| `w!!` | enregistrer avec sudo un fichier ouvert sans les droits *(ligne de commande)* |

**polices**

| Raccourci | Action |
|---|---|
| `,= / ,-` | agrandir (,=) ou réduire (,-) la police d’un point *(interface graphique)* |
| `,1 … ,9` | choisir une des polices préférées *(interface graphique)* |
<!-- /raccourcis -->
