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
# déployer sur une machine distante (clone si besoin, puis installation)
ssh <hôte> 'sh -s -- --yes --json' < ~/.vim/bin/deploy-local

# demander l'état d'une machine, sans rien modifier
ssh <hôte> 'sh ~/.vim/bin/install --check --json'
```

| Commande | Rôle |
|---|---|
| `bin/deploy-local` | clone ou met à jour puis installe, sur la machine courante. `--dir`, `--repo-url`, `--branch`, `--yes`, `--no-plugins`, `--json`, `--dry-run`. Bascule l'adresse du dépôt en https si ssh échoue (compte sans clé) |
| `bin/install --check --json` | état de la machine sur une seule ligne : OS, vim et niveau, git, joignabilité GitHub, branche, commit, plugins installés / déclarés / manquants, restes, paquets manquants, état des mises à jour |
| `bin/install --clean` | supprime les restes |
| `bin/update-plugins` | installe et met à jour les plugins (`--if-due N` jours, `--if-due-minutes N`) |

**Codes de sortie**, communs à ces commandes : `0` conforme, `1` erreur, `2` usage, `3` déployé mais dégradé (plugins manquants, restes, outil absent). En mode `--json`, rien d'autre que le JSON n'est écrit sur la sortie standard.

## Essayer une autre branche sans rien casser

```sh
sh bin/install --try --branch refactor   # crée ~/.vimnew (git worktree)
vim -u ~/.vimnew/vimrc                   # config, plugins et historique séparés
```

## Plugins

- Ils sont déclarés dans `config/plugins.vim` (vim-plug).
- Ils sont installés par `make`, ou **au premier lancement de vim** si ce n'est pas encore fait.
- Ils sont **mis à jour automatiquement en arrière-plan** au lancement de vim, au plus une fois tous les 7 jours. Vim n'est ni ralenti ni bloqué, et les nouvelles versions sont prises en compte au démarrage suivant.
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
| `:Theme edge light` | choisit un thème et un fond |
| `<F5>` | bascule clair / sombre |
| `,$n` / `,$p` | thème suivant / précédent |

Le dernier choix est mémorisé pour chaque machine. Thèmes disponibles : everforest, edge, catppuccin, solarized8, lucius, PaperColor, pencil (écriture) et noctu (console). Sur vim 9, s'ajoutent retrobox, wildcharm et lunaperche.

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
bin/update-plugins     mise à jour des plugins (manuelle ou en arrière-plan)
test/                  batterie de tests (make check)
local/                 données et réglages propres à la machine (non versionné)
plugged/               plugins installés (non versionné)
```

## Principaux raccourcis

Le leader est `,` et le localleader est `=`.

**Navigation et fichiers**

| Raccourci | Action |
|---|---|
| `,ff` `,fb` `,fr` `,fg` | fichiers, buffers, récents, recherche (fzf, sinon ctrlp) |
| `,be` `,bs` `,bv` | liste des buffers : ici, partage horizontal, partage vertical |
| `,t` / `,T` | arborescence (NERDTree) / symboles (Tagbar) |
| `,x` / `,X` | fermer le buffer en gardant la fenêtre / fermer les deux |
| `Ctrl-h/j/k/l`, flèches | changer de fenêtre (et de panneau tmux) |
| `=t` `=h` `=l` | nouvel onglet, onglet précédent / suivant |

**Édition**

| Raccourci | Action |
|---|---|
| `jf` / `fj` | quitter le mode insertion |
| `Espace` / `Retour arrière` | déplier / replier |
| `,Espace` / `Maj-F7` | supprimer les espaces en fin de ligne (ligne / fichier ; en markdown, les doubles espaces sont conservés) |
| `F8` | réindenter, ou corriger avec ALE (python, js, json…) |
| `,u` / `,y` | historique d'annulation / registres |
| `Ctrl-p` / `Ctrl-n` juste après un collage | remplacer par une copie plus ancienne / plus récente |
| `Maj-Tab` | développer un snippet |
| `aC` `iC` / `aM` `iM` (python) | objets de texte classe / méthode, aussi `ac` `ic` `af` `if` |
| `,d` `,n` `,r` (python) | définition, usages, renommage (ALE) |

**Git et erreurs**

| Raccourci | Action |
|---|---|
| `,gs` `,gc` `,gl` `,gb` | git : état, commit, historique, ouvrir sur GitHub |
| `,E` `]d` `[d` | erreurs : liste, suivante, précédente |

**Markdown et écriture**

| Raccourci | Action |
|---|---|
| `,P` | aperçu markdown |
| `:Goyo` | mode écriture |

**AZERTY :** `'` `-` `§` `à` `ù` donnent `[` `]` `{` `}` `%`.
