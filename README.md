# Configuration vim

Une configuration vim unique pour des machines très différentes : macOS (plusieurs versions), Debian, Mint, NAS Synology, Cygwin, WSL et, plus rarement, Windows.

**Principe : si quelque chose manque, on s'en passe sans bruit.** Un plugin, une option de vim ou un outil externe absent est ignoré. Aucune erreur au démarrage, du vim-tiny au vim 9.

## Installation

```sh
git clone https://github.com/peterhost/dotvim.git ~/.vim
cd ~/.vim && make
```

`make` lance l'installeur guidé (`bin/install`) :

1. **Diagnostic.** Il affiche le système, la version de vim et ses capacités, le niveau prévu et les outils présents.
2. **Choix.** Installer, essayer à côté de la config actuelle, ou désinstaller. Puis la branche, et l'installation des plugins.
3. **Récapitulatif.** Il demande une confirmation, exécute, puis vérifie que vim démarre sans erreur.

Autres commandes :

| Commande | Effet |
|---|---|
| `make install` | installe sans poser de question (ssh, scripts) |
| `make try` | essai à côté de la config actuelle, sans rien activer |
| `make update` | `git pull`, puis mise à jour des plugins |
| `make uninstall` | retire la config et restaure la sauvegarde |
| `make check` | batterie de tests (`VIMS="vim /autre/vim"` pour en tester plusieurs) |
| `make themes` | ouvre le fichier d'essai des thèmes |

Ce que fait l'installation :
- `~/.vimrc` devient une ligne `source ~/.vim/vimrc`. L'ancien fichier est sauvegardé en `~/.vimrc.bak-<date>`. Même chose pour `~/.gvimrc`.
- Les plugins sont installés dans `~/.vim/plugged/`, qui n'est jamais versionné.
- Rien n'est écrit hors de `$HOME`, et `sudo` n'est jamais utilisé.

**Windows natif** (sans sh) : clonez dans `%USERPROFILE%\vimfiles`, puis créez `%USERPROFILE%\_vimrc` contenant `source ~/vimfiles/vimrc`. Lancez ensuite `:PlugInstall` dans vim. La config trouve son dossier toute seule. Cygwin, MSYS2 et WSL utilisent `make` normalement.

## Essayer une autre branche sans rien casser

```sh
sh bin/install --try --branch refactor   # crée ~/.vimnew (git worktree)
vim -u ~/.vimnew/vimrc                   # config, plugins et historique séparés
```

## Plugins

- Ils sont déclarés dans `config/plugins.vim` (vim-plug).
- Ils sont installés par `make`, ou **au premier lancement de vim** si ce n'est pas encore fait.
- Ils sont **mis à jour automatiquement en arrière-plan** au lancement de vim, au plus une fois tous les 7 jours. Vim n'est ni ralenti ni bloqué, et les nouvelles versions sont prises en compte au démarrage suivant.
- Le journal s'ouvre avec `:PluginsUpdateLog`. Le délai se règle avec `let g:my_autoupdate_days = 14` dans `~/.vimrc.local` ; `0` désactive la mise à jour automatique.

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

## Réglages propres à une machine : `~/.vimrc.local`

Ce fichier est facultatif. S'il existe, il est lu au démarrage. Exemples :

```vim
let g:my_theme = 'lucius'          " autre thème par défaut
let g:my_background = 'light'      " fond clair
let g:my_force_tier = 'compat'     " forcer un niveau (NAS poussif…)
let g:my_disabled = ['ale']        " ne pas charger certains plugins
let g:my_autoupdate_days = 0       " pas de mise à jour automatique
let g:my_powerline_fonts = 1       " polices patchées pour airline
let g:my_undercurl = 1             " le terminal gère le soulignement ondulé
```

`~/.gvimrc.local` fait de même pour l'interface graphique (police, taille de fenêtre…).

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
local/                 données propres à la machine (non versionné)
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
| `Maj-Tab` | développer un snippet |

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
