#!/bin/sh
# test/install.sh — tests de bin/install et bin/update-plugins
#
# Chaque scénario tourne dans un HOME temporaire contenant une copie du dépôt :
# rien n'est modifié chez vous. Plugins non téléchargés (--no-plugins), sauf
# le test d'installation en arrière-plan (TEST_NETWORK=1 pour l'activer).
# TEST_SH=dash : lancer l'installeur avec un autre shell (dash, ksh…).

set -u
ROOT=$(cd "$(dirname "$0")/.." && pwd)
TMP=$(mktemp -d "${TMPDIR:-/tmp}/vimtest-install.XXXXXX")
trap 'rm -rf "$TMP"' EXIT INT TERM
PASS=0; FAIL=0

check() { # check <libellé> <commande…>
  label=$1; shift
  if "$@" >/dev/null 2>&1; then PASS=$((PASS + 1)); printf '  ok   %s\n' "$label"
  else FAIL=$((FAIL + 1)); printf '  ÉCHEC %s\n' "$label"; fi
}

# Nouveau HOME avec une copie du dépôt (état de travail actuel, sur une
# branche "refactor", la branche master restant celle d'origine).
new_home() {
  H="$TMP/$1"; mkdir -p "$H/.vim"
  (cd "$ROOT" && tar cf - --exclude ./plugged --exclude ./local --exclude ./.git .) | (cd "$H/.vim" && tar xf -)
  (cd "$H/.vim" && git init -q && git add -A && git -c user.name=t -c user.email=t@t commit -qm base \
    && git branch -M master && git checkout -q -b refactor) || exit 1
}
inst() { HOME=$H USER=test MY_VIM_NO_AUTOUPDATE=1 ${TEST_SH:-sh} "$H/.vim/bin/install" "$@" </dev/null >"$TMP/out.txt" 2>&1; }

echo "== Installation sur une machine vierge"
new_home fresh
check "installation --yes réussie"       inst --yes --no-plugins
check "pas de ~/.vimrc (vim lit ~/.vim/vimrc)" test ! -e "$H/.vimrc"
check "pas de ~/.gvimrc"                 test ! -e "$H/.gvimrc"
check "rien d'autre créé dans \$HOME"     test "$(ls -A "$H")" = .vim
check "journal dans local/, rien à la racine" sh -c "test -f '$H/.vim/local/install.log' && test ! -e '$H/.vim/install.log'"
check "aucune sauvegarde inutile"        test ! -d "$H/.vim/local/backup"
check "~/.vimrc.local non créé"          test ! -e "$H/.vimrc.local"
check "vim démarre sans erreur"          grep -q 'aucune erreur' "$TMP/out.txt"

echo "== Réinstallation (idempotence)"
check "2e installation réussie"          inst --yes --no-plugins
check "toujours aucune sauvegarde"       test ! -d "$H/.vim/local/backup"

echo "== Config clonée ailleurs que ~/.vim : fichier d'une ligne"
new_home elsewhere
mv "$H/.vim" "$H/dotvim"
check "installation depuis ~/dotvim"     sh -c "HOME='$H' MY_VIM_NO_AUTOUPDATE=1 sh '$H/dotvim/bin/install' --yes --no-plugins </dev/null >/dev/null 2>&1"
check "~/.vimrc pointe vers ~/dotvim"     grep -q 'source ~/dotvim/vimrc' "$H/.vimrc"
check "~/.gvimrc pointe vers ~/dotvim"    grep -q 'source ~/dotvim/gvimrc' "$H/.gvimrc"

echo "== Migration depuis l'ancien bootstrap (liens symboliques)"
new_home legacy
ln -s "$H/.vim/vimrc" "$H/.vimrc"
: > "$H/.vim/vimrc.local"; ln -s "$H/.vim/vimrc.local" "$H/.vimrc.local"
echo '" set guifont=X' > "$H/.vim/gvimrc.local"; ln -s "$H/.vim/gvimrc.local" "$H/.gvimrc.local"
echo '" perso' > "$H/.gvimrc"
check "installation réussie"             inst --yes --no-plugins
check "ancien ~/.vimrc sauvegardé dans local/backup" test -L "$(ls -d "$H"/.vim/local/backup/.vimrc.* | head -1)"
check "ancien ~/.gvimrc sauvegardé"      grep -q perso "$(ls -d "$H"/.vim/local/backup/.gvimrc.* | head -1)"
check "plus de ~/.vimrc ni de sauvegarde dans \$HOME" sh -c "test ! -e '$H/.vimrc' && ! ls '$H' | grep -q bak"
check "lien .vimrc.local vide retiré"    test ! -e "$H/.vimrc.local"
check "~/.gvimrc.local retiré de \$HOME"  test ! -e "$H/.gvimrc.local"
check "contenu déplacé dans local/gvimrc.local" grep -q guifont "$H/.vim/local/gvimrc.local"
check "\$HOME ne contient plus que .vim"   test "$(ls -A "$H")" = .vim

echo "== Désinstallation"
check "désinstallation réussie"          inst --uninstall --yes
check "~/.vimrc d'origine restauré"      test -L "$H/.vimrc"
check "~/.gvimrc d'origine restauré"     grep -q perso "$H/.gvimrc"

echo "== Ménage des restes de l'ancienne configuration"
new_home legacy2
mkdir -p "$H/.vim/bundle/vundle" "$H/.vim-fuf-data"; echo x > "$H/.vim/bundle/vundle/f"; echo 1 > "$H/.viminfo.vimnew"
check "installation réussie"                          inst --yes --no-plugins
check "restes listés"                                 grep -q 'Restes de l.ancienne configuration' "$TMP/out.txt"
check "bundle/ supprimé"                              test ! -e "$H/.vim/bundle"
check "~/.vim-fuf-data supprimé"                      test ! -e "$H/.vim-fuf-data"
check "~/.viminfo.vimnew supprimé"                    test ! -e "$H/.viminfo.vimnew"

echo "== Essai côte à côte (git worktree)"
new_home try
check "essai de la branche master"       inst --try --branch master --no-plugins --yes
check "worktree ~/.vimnew créé"          test -f "$H/.vimnew/vimrc"
check "~/.vimrc non touché"              test ! -e "$H/.vimrc"
check "essai refusé si ~/.vimnew existe" sh -c "! HOME='$H' sh '$H/.vim/bin/install' --try --branch master --no-plugins --yes </dev/null"

echo "== Zéro reste : nettoyage garanti par l'installeur"
new_home crumbs
# restes de l'ancienne config + transitoires + données à préserver
mkdir -p "$H/.vim/local/spell" "$H/.vim/local/backup" "$H/.vim/local/undo" "$H/.vim/local/sessions"
echo 'hi' > "$H/.vim/colors/default-light.vim"; echo 'hi' > "$H/.vim/colors/dim.vim"
echo 'vieux' > "$H/.vim/.netrwhist"; echo 'vieux' > "$H/.vim/install.log"
printf 'Jancovici\n' > "$H/.vim/spell/fr.utf-8.add"; echo spl > "$H/.vim/spell/fr.utf-8.add.spl"
echo x > "$H/.vim/local/update-report.txt"; echo x > "$H/.vim/local/check.txt"
mkdir -p "$H/.vim/local/update.lock"; touch -t 202001010000 "$H/.vim/local/update.lock"
for d in 1 2 3 4 5; do echo v > "$H/.vim/local/backup/.vimrc.2026010$d-000000"; done
echo 'motperso' > "$H/.vim/local/spell/fr.utf-8.add"; echo u > "$H/.vim/local/undo/fichier"
echo s > "$H/.vim/local/sessions/travail.vim"; echo 'let g:x=1' > "$H/.vim/local/vimrc.local"
i=0; while [ $i -lt 700 ]; do echo "ligne $i" >> "$H/.vim/local/install.log"; i=$((i + 1)); done
check "--check signale les restes (code 3)"           sh -c "HOME='$H' sh '$H/.vim/bin/install' --check </dev/null >'$TMP/out.txt' 2>&1; test \$? = 3"
check "--check liste le dictionnaire de l'ancienne config" grep -q 'spell/fr.utf-8.add' "$TMP/out.txt"
check "--clean réussit"                               sh -c "HOME='$H' sh '$H/.vim/bin/install' --clean </dev/null >'$TMP/out.txt' 2>&1"
check "colors/ de l'ancienne config supprimés"        sh -c "test ! -e '$H/.vim/colors/dim.vim' && test ! -e '$H/.vim/colors/default-light.vim'"
check "spell/*.add de la racine supprimés"            sh -c "test ! -e '$H/.vim/spell/fr.utf-8.add' && test ! -e '$H/.vim/spell/fr.utf-8.add.spl'"
check ".netrwhist et install.log de la racine supprimés" sh -c "test ! -e '$H/.vim/.netrwhist' && test ! -e '$H/.vim/install.log'"
check "transitoires supprimés"                        sh -c "test ! -e '$H/.vim/local/update-report.txt' && test ! -e '$H/.vim/local/check.txt'"
check "verrou périmé supprimé"                        test ! -e "$H/.vim/local/update.lock"
check "3 sauvegardes gardées, les plus récentes"       sh -c "test \$(ls -A '$H/.vim/local/backup' | wc -l | tr -d ' ') = 3 && test -f '$H/.vim/local/backup/.vimrc.20260105-000000' && test ! -e '$H/.vim/local/backup/.vimrc.20260101-000000'"
check "journal tronqué à 500 lignes"                  sh -c "test \$(wc -l < '$H/.vim/local/install.log' | tr -d ' ') -le 500"
check "dictionnaire de la machine intact"             grep -q motperso "$H/.vim/local/spell/fr.utf-8.add"
check "annulation, sessions et réglages locaux intacts" sh -c "test -f '$H/.vim/local/undo/fichier' && test -f '$H/.vim/local/sessions/travail.vim' && test -f '$H/.vim/local/vimrc.local'"
check "dépôt propre après nettoyage"                  sh -c "test -z \"\$(git -C '$H/.vim' status --porcelain)\""
check "--check ne signale plus de reste"               sh -c "HOME='$H' sh '$H/.vim/bin/install' --check </dev/null 2>&1 | grep -q 'Aucun reste'"
check "--clean idempotent"                            sh -c "HOME='$H' sh '$H/.vim/bin/install' --clean </dev/null 2>&1 | grep -q 'Aucun reste'"

echo "== Zéro reste : le dictionnaire est gardé s'il n'a pas été recopié"
new_home crumbs2
printf 'Jancovici\n' > "$H/.vim/spell/fr.utf-8.add"
check "--clean réussit"                               sh -c "HOME='$H' sh '$H/.vim/bin/install' --clean </dev/null >/dev/null 2>&1"
check "dictionnaire conservé (pas de copie locale)"   test -f "$H/.vim/spell/fr.utf-8.add"

echo "== Zéro reste : une installation complète ne laisse rien"
new_home nocrumbs
echo 'hi' > "$H/.vim/colors/dim.vim"; printf 'mot\n' > "$H/.vim/spell/fr.utf-8.add"
check "installation réussie"                          inst --yes --no-plugins
check "mots repris dans local/spell/"                 grep -q mot "$H/.vim/local/spell/fr.utf-8.add"
check "aucun reste après installation"                sh -c "HOME='$H' sh '$H/.vim/bin/install' --clean </dev/null 2>&1 | grep -q 'Aucun reste'"
check "dépôt propre"                                  sh -c "test -z \"\$(git -C '$H/.vim' status --porcelain)\""

echo "== Modifications locales : supprimées au changement de branche"
new_home dirty
echo x >> "$H/.vim/README.md"
echo y > "$H/.vim/non-suivi.txt"
mkdir -p "$H/.vim/plugged/ancien"; echo z > "$H/.vim/plugged/ancien/f"
check "changement de branche malgré les modifications" inst --yes --branch master --no-plugins
check "liste des modifications affichée"              grep -q 'README.md' "$TMP/out.txt"
check "branche master active"                         test "$(git -C "$H/.vim" rev-parse --abbrev-ref HEAD)" = master
check "fichier suivi remis à l'état du dépôt"         test -z "$(git -C "$H/.vim" status --porcelain)"
check "fichier non suivi supprimé"                    test ! -e "$H/.vim/non-suivi.txt"
check "fichiers ignorés conservés (plugged/)"         test -f "$H/.vim/plugged/ancien/f"

echo "== Mise à jour en arrière-plan : témoin et verrou"
new_home update
mkdir -p "$H/.vim/local"; touch "$H/.vim/local/last-update"
check "--if-due : rien à faire si récent" sh -c "HOME='$H' VIM_BIN=false sh '$H/.vim/bin/update-plugins' --if-due 7 && test ! -f '$H/.vim/local/update.log'"
mkdir "$H/.vim/local/update.lock"
rm -f "$H/.vim/local/last-update"
check "verrou respecté (pas de 2e mise à jour)" sh -c "HOME='$H' VIM_BIN=false sh '$H/.vim/bin/update-plugins' && test ! -f '$H/.vim/local/update.log'"
rmdir "$H/.vim/local/update.lock"
check "mise à jour exécutée sans verrou"  sh -c "HOME='$H' VIM_BIN=true sh '$H/.vim/bin/update-plugins' && test -f '$H/.vim/local/last-update'"
check "verrou libéré à la fin"            test ! -d "$H/.vim/local/update.lock"
check "--if-due-minutes : rien si tentative récente" sh -c "rm -f '$H/.vim/local/update.log'; HOME='$H' VIM_BIN=false sh '$H/.vim/bin/update-plugins' --if-due-minutes 60 && test ! -f '$H/.vim/local/update.log'"
touch -t 202001010000 "$H/.vim/local/last-update"
check "--if-due-minutes : relance si plus ancienne"  sh -c "HOME='$H' VIM_BIN=true sh '$H/.vim/bin/update-plugins' --if-due-minutes 60 && test -f '$H/.vim/local/update.log'"

echo "== Accès à GitHub : https ou ssh indisponible (git simulé)"
# faux git : ls-remote réussit ou échoue selon FAKE_HTTPS / FAKE_SSH, en
# tenant compte de la règle de réécriture ; tout le reste va au vrai git.
REALGIT=$(sh -c 'command -v git')
mkdir -p "$TMP/fakegit"
cat > "$TMP/fakegit/git" <<FAKE
#!/bin/sh
if [ "\$1" = ls-remote ]; then
  url=\$2
  case \$url in https://*)
    "$REALGIT" config --global --get-all url.git@github.com:.insteadOf 2>/dev/null | grep -q '^https://github.com/\$' && url=ssh ;;
  esac
  case \$url in https://*) [ "\$FAKE_HTTPS" = 1 ] ;; *) [ "\$FAKE_SSH" = 1 ] ;; esac
  exit \$?
fi
exec "$REALGIT" "\$@"
FAKE
chmod +x "$TMP/fakegit/git"
netinst() { HOME=$H PATH="$TMP/fakegit:$PATH" MY_VIM_NO_AUTOUPDATE=1 FAKE_HTTPS=$1 FAKE_SSH=$2 sh "$H/.vim/bin/install" --yes --no-plugins </dev/null >"$TMP/out.txt" 2>&1; }

new_home nas
check "NAS (https KO, ssh OK) : installation réussie" netinst 0 1
check "règle https->ssh ajoutée (forme normale)"      sh -c "git config --file '$H/.config/git/config' --get-all url.git@github.com:.insteadof | grep -qx 'https://github.com/'"
check "règle https->ssh ajoutée (forme vim-plug)"     sh -c "git config --file '$H/.config/git/config' --get-all url.git@github.com:.insteadof | grep -qx 'https://git::@github.com/'"
check "~/.gitconfig non modifié"                      test ! -f "$H/.gitconfig"
check "diagnostic : https indisponible signalé"       grep -q 'https indisponible' "$TMP/out.txt"
netinst 0 1
check "règle non dupliquée à la 2e installation"      test "$(git config --file "$H/.config/git/config" --get-all url.git@github.com:.insteadof | wc -l | tr -d ' ')" = 2

new_home harold
git -C "$H/.vim" remote add origin git@github.com:peterhost/dotvim.git
check "harold (ssh KO, https OK) : installation réussie" netinst 1 0
check "origin passé en https"                         test "$(git -C "$H/.vim" remote get-url origin)" = https://github.com/peterhost/dotvim.git
check "pas de règle https->ssh ajoutée"               test ! -f "$H/.config/git/config"

new_home offline
check "hors ligne : installation réussie quand même"  netinst 0 0
check "hors ligne : signalé clairement"               grep -q 'GitHub injoignable' "$TMP/out.txt"
check "hors ligne : absence de plugins annoncée"       grep -q 'Aucun plugin installé' "$TMP/out.txt"
check "hors ligne : config git non modifiée"          sh -c "test ! -f '$H/.gitconfig' && test ! -f '$H/.config/git/config'"

new_home entware
# Entware sans git-http : faux opkg, et exec-path sans git-remote-https
mkdir -p "$TMP/fakeopkg" "$TMP/nohttps"
printf '#!/bin/sh\nexit 0\n' > "$TMP/fakeopkg/opkg"; chmod +x "$TMP/fakeopkg/opkg"
cat > "$TMP/fakeopkg/git" <<FAKE2
#!/bin/sh
[ "\$1" = --exec-path ] && { echo "$TMP/nohttps"; exit 0; }
exec "$TMP/fakegit/git" "\$@"
FAKE2
chmod +x "$TMP/fakeopkg/git"
check "Entware sans git-http : installation réussie" sh -c "HOME='$H' PATH='$TMP/fakeopkg:$PATH' MY_VIM_NO_AUTOUPDATE=1 FAKE_HTTPS=0 FAKE_SSH=1 sh '$H/.vim/bin/install' --yes --no-plugins </dev/null >'$TMP/out.txt' 2>&1"
check "commande opkg install git-http proposée"       grep -q 'opkg install git-http' "$TMP/out.txt"
check "règle non posée d'office (réparer d'abord)"    test ! -f "$H/.config/git/config"

echo "== Paquets Entware : vérification au lancement (faux opkg)"
new_home opkgcheck
mkdir -p "$TMP/ew"
for c in sh env cat ls mkdir rm mv cp ln date sed awk grep tr cut head tail sort uniq wc du find touch uname \
         dirname basename tput vim script id readlink sw_vers expr stty tee true false git ssh make; do
  p=$(sh -c "command -v $c" 2>/dev/null) && [ -x "$p" ] && ln -sf "$p" "$TMP/ew/$c"
done
# dépôt : fzf et ripgrep disponibles, ctags / libxml2-utils absents ; make présent
printf '#!/bin/sh\n[ "$1" = list ] && printf "fzf - 0.70 - x\\nripgrep - 15 - x\\nmake - 4 - x\\n"\nexit 0\n' > "$TMP/ew/opkg"
chmod +x "$TMP/ew/opkg"
ewinst() { HOME=$H PATH="$TMP/ew" MY_EXTRA_PATHS=/nonexistent MY_VIM_NO_AUTOUPDATE=1 "$TMP/ew/sh" "$H/.vim/bin/install" --yes --no-plugins </dev/null >"$TMP/out.txt" 2>&1; }
check "installation réussie avec opkg"                ewinst
check "commande opkg proposée (fzf ripgrep)"          grep -q 'opkg install fzf ripgrep' "$TMP/out.txt"
check "paquets absents du dépôt signalés"             grep -q 'Absents du dépôt.*ctags libxml2-utils' "$TMP/out.txt"
check "outil présent (make) non proposé"              sh -c "! grep -q 'install.*make' '$TMP/out.txt'"
# sans opkg list (sudo requis) : repli sur ~/opkglist.txt
printf '#!/bin/sh\nexit 1\n' > "$TMP/ew/opkg"
printf 'fzf - 0.70 - x\nctags - 6 - x\n' > "$H/opkglist.txt"
ewinst
check "repli sur ~/opkglist.txt"                      grep -q 'opkg install fzf ctags' "$TMP/out.txt"
rm -f "$H/opkglist.txt"; ewinst
check "sans liste : conseil de déposer opkglist.txt"  grep -q 'opkglist.txt' "$TMP/out.txt"
check "--check : diagnostic seul, rien d'installé"    sh -c "rm -f '$H/.vimrc'; HOME='$H' sh '$H/.vim/bin/install' --check </dev/null >/dev/null 2>&1; test ! -e '$H/.vimrc'"

echo "== git hors du PATH (cas Synology : /opt/bin)"
new_home extrapath
mkdir -p "$TMP/optbin" "$TMP/nogit"
ln -s "$(sh -c 'command -v git')" "$TMP/optbin/git"
# dossier d'outils sans git (sur macOS, /usr/bin contient un git : on ne peut
# pas simplement le retirer du PATH)
for c in sh bash env cat ls mkdir rm mv cp ln date sed awk grep tr cut head tail sort uniq wc du \
         find touch uname dirname basename tput vim script id readlink sw_vers expr stty tee true false; do
  p=$(sh -c "command -v $c" 2>/dev/null) && [ -x "$p" ] && ln -s "$p" "$TMP/nogit/$c"
done
check "installation sans git dans le PATH" sh -c "HOME='$H' PATH='$TMP/nogit' MY_EXTRA_PATHS='$TMP/optbin' MY_VIM_NO_AUTOUPDATE=1 '$TMP/nogit/sh' '$H/.vim/bin/install' --yes --no-plugins </dev/null >'$TMP/out.txt' 2>&1"
check "git retrouvé dans le dossier supplémentaire" grep -q 'git présent' "$TMP/out.txt"
check "sans dossier supplémentaire : git signalé absent" sh -c "HOME='$H' PATH='$TMP/nogit' MY_EXTRA_PATHS=/nonexistent '$TMP/nogit/sh' '$H/.vim/bin/install' --yes --no-plugins </dev/null 2>&1 | grep -q 'git absent'"

echo "== Dictionnaire personnel repris dans local/spell/"
new_home spell
printf 'collapsologie\nJancovici\n' > "$H/.vim/spell/fr.utf-8.add"
check "installation réussie"                          inst --yes --no-plugins
check "mots repris dans local/spell/fr.utf-8.add"     grep -q Jancovici "$H/.vim/local/spell/fr.utf-8.add"

echo "== Historique : ~/.viminfo repris une fois dans local/"
new_home viminfo
printf '# viminfo de test\n:commande-ancienne\n' > "$H/.viminfo"
HOME=$H MY_VIM_NO_AUTOUPDATE=1 vim -N -u "$H/.vim/vimrc" -es -c 'qa!' </dev/null >/dev/null 2>&1
check "~/.viminfo copié dans local/viminfo"           grep -q 'commande-ancienne' "$H/.vim/local/viminfo"
check "~/.viminfo d'origine laissé intact"            grep -q 'commande-ancienne' "$H/.viminfo"
printf '# autre\n' > "$H/.viminfo"
HOME=$H MY_VIM_NO_AUTOUPDATE=1 vim -N -u "$H/.vim/vimrc" -es -c 'qa!' </dev/null >/dev/null 2>&1
check "copie faite une seule fois"                    grep -q 'commande-ancienne' "$H/.vim/local/viminfo"

echo "== Mise à jour : rapport d'échec enregistré pour vim"
new_home report
cat > "$TMP/fakevim" <<'FV'
#!/bin/sh
# faux vim : écrit un rapport vim-plug en échec là où on lui demande
for a in "$@"; do case $a in "silent! write! "*) f=${a#silent! write! } ;; esac; done
printf '%s\n' 'Updated.' '' "x fzf:" "    fatal: Unable to find remote helper for 'https'" '- nerdtree: Already up to date.' > "$f"
FV
chmod +x "$TMP/fakevim"
HOME=$H VIM_BIN="$TMP/fakevim" sh "$H/.vim/bin/update-plugins" >/dev/null 2>&1
check "état : échec pour 1 plugin"                    grep -qx 'fail 1' "$H/.vim/local/update-status"
check "conseil https enregistré"                      grep -q '^conseil: git sans support https' "$H/.vim/local/update-status"
check "rapport ajouté au journal"                     grep -q 'remote helper' "$H/.vim/local/update.log"

echo "== État JSON pour un appelant tiers (--check --json)"
new_home json
HOME=$H sh "$H/.vim/bin/install" --check --json </dev/null > "$TMP/j.txt" 2>"$TMP/e.txt"; rc=$?
check "code 3 (aucun plugin installé)"                test "$rc" = 3
check "une seule ligne, rien d'autre"                 test "$(wc -l < "$TMP/j.txt" | tr -d ' ')" = 1
check "pas de décoration sur la sortie"               sh -c "! grep -q 'Diagnostic' '$TMP/j.txt'"
for k in host user os dir vim tier git github_https branch commit plugins_installed plugins_declared plugins_missing crumbs status; do
  check "champ $k présent" grep -q "\"$k\":" "$TMP/j.txt"
done
check "JSON bien formé (accolades appariées)"         sh -c "head -c1 '$TMP/j.txt' | grep -q '{' && tail -c2 '$TMP/j.txt' | grep -q '}'"
echo 'hi' > "$H/.vim/colors/dim.vim"
check "restes comptés dans le JSON"                   sh -c "HOME='$H' sh '$H/.vim/bin/install' --check --json </dev/null 2>/dev/null | grep -q '\"crumbs\":1'"
check "option inconnue : code 2"                      sh -c "HOME='$H' sh '$H/.vim/bin/install' --nawak </dev/null >/dev/null 2>&1; test \$? = 2"

echo "== Déploiement par un appelant tiers (bin/deploy-local)"
new_home source
SRC="$H/.vim"
TGT="$TMP/cible"; mkdir -p "$TGT"
# 3 = déployé mais dégradé (ici : plugins volontairement non installés)
dep() { HOME=$TGT MY_VIM_NO_AUTOUPDATE=1 sh "$SRC/bin/deploy-local" --dir "$TGT/.vim" "$@" </dev/null >"$TMP/d.txt" 2>"$TMP/d-trace.txt"; rc=$?; [ "$rc" = 0 ] || [ "$rc" = 3 ]; }
check "machine vierge : clone + installation"         dep --repo-url "$SRC" --no-plugins --json
check "configuration en place"                        test -f "$TGT/.vim/vimrc"
check "action « clone » annoncée"                     grep -q '"action":"clone"' "$TMP/d.txt"
check "état de la machine inclus (imbriqué)"          grep -q '"state":{' "$TMP/d.txt"
check "aucune décoration en mode json"                sh -c "test \$(wc -l < '$TMP/d.txt' | tr -d ' ') = 1"
check "relance : action « update »"                   sh -c "HOME='$TGT' MY_VIM_NO_AUTOUPDATE=1 sh '$TGT/.vim/bin/deploy-local' --dir '$TGT/.vim' --no-plugins --json </dev/null 2>/dev/null | grep -q '\"action\":\"update\"'"
before=$(git -C "$TGT/.vim" rev-parse HEAD)
check "--dry-run ne modifie rien"                     sh -c "HOME='$TGT' sh '$TGT/.vim/bin/deploy-local' --dir '$TGT/.vim' --dry-run </dev/null >/dev/null 2>&1 && test \"\$(git -C '$TGT/.vim' rev-parse HEAD)\" = '$before'"
check "--dry-run annonce « rien à faire »"            sh -c "HOME='$TGT' sh '$TGT/.vim/bin/deploy-local' --dir '$TGT/.vim' --dry-run </dev/null 2>&1 | grep -q 'rien à faire'"
check "option inconnue : code 2"                      sh -c "HOME='$TGT' sh '$SRC/bin/deploy-local' --nawak </dev/null >/dev/null 2>&1; test \$? = 2"
check "dossier occupé par autre chose : erreur"       sh -c "mkdir -p '$TMP/occupe' && echo x > '$TMP/occupe/fichier' && HOME='$TGT' sh '$SRC/bin/deploy-local' --dir '$TMP/occupe' --repo-url '$SRC' --json </dev/null 2>&1 | grep -q '\"action\":\"error\"'"
echo "== Contrat d'état pour l'appelant tiers (deploy-local --check)"
VIERGE="$TMP/vierge"; mkdir -p "$VIERGE"
HOME=$VIERGE sh "$SRC/bin/deploy-local" --dir "$VIERGE/.vim" --check --json </dev/null > "$TMP/c.txt" 2>/dev/null; rc=$?
check "machine vierge : code 4"                       test "$rc" = 4
check "machine vierge : installed false, status absent" sh -c "grep -q '\"installed\":false' '$TMP/c.txt' && grep -q '\"status\":\"absent\"' '$TMP/c.txt'"
check "machine vierge : une seule ligne JSON"         test "$(wc -l < "$TMP/c.txt" | tr -d ' ')" = 1
HOME=$TGT sh "$TGT/.vim/bin/deploy-local" --dir "$TGT/.vim" --check --json </dev/null > "$TMP/c2.txt" 2>/dev/null; rc=$?
check "machine installée : code 3 (plugins absents)"  test "$rc" = 3
check "machine installée : installed true + état imbriqué" sh -c "grep -q '\"installed\":true' '$TMP/c2.txt' && grep -q '\"state\":{' '$TMP/c2.txt'"
check "--check --remote : à jour (up_to_date true)"    sh -c "HOME='$TGT' sh '$TGT/.vim/bin/deploy-local' --dir '$TGT/.vim' --check --remote --json </dev/null 2>/dev/null | grep -q '\"up_to_date\":true'"
check "--check sans --remote : pas de réseau (null)"   sh -c "HOME='$TGT' sh '$TGT/.vim/bin/deploy-local' --dir '$TGT/.vim' --check --json </dev/null 2>/dev/null | grep -q '\"remote_commit\":null'"

echo "== Simulation : codes de sortie exploitables sans lire le JSON"
check "à installer : code 4"                          sh -c "HOME='$VIERGE' sh '$SRC/bin/deploy-local' --dir '$VIERGE/.vim' --repo-url '$SRC' --dry-run --json </dev/null >/dev/null 2>&1; test \$? = 4"
check "rien à faire : code 0"                         sh -c "HOME='$TGT' sh '$TGT/.vim/bin/deploy-local' --dir '$TGT/.vim' --dry-run --json </dev/null >/dev/null 2>&1"
(cd "$SRC" && git checkout -q master && echo "# suite" >> README.md && git add -A \
  && git -c user.name=t -c user.email=t@t commit -qm "nouveau commit" >/dev/null)
check "mise à jour disponible : code 5"               sh -c "HOME='$TGT' sh '$TGT/.vim/bin/deploy-local' --dir '$TGT/.vim' --dry-run --json </dev/null >/dev/null 2>&1; test \$? = 5"
check "simulation : rien n'a été modifié"             sh -c "test \"\$(git -C '$TGT/.vim' rev-parse HEAD)\" != \"\$(git -C '$SRC' rev-parse HEAD)\""

echo "== Plan hors ligne (--offline) : aucun accès réseau"
check "hors ligne : compare au dernier commit connu"  sh -c "HOME='$TGT' sh '$TGT/.vim/bin/deploy-local' --dir '$TGT/.vim' --dry-run --offline --json </dev/null 2>/dev/null | grep -q '\"remote_source\":\"cache\"'"
check "hors ligne : date de la dernière récupération"  sh -c "HOME='$TGT' sh '$TGT/.vim/bin/deploy-local' --dir '$TGT/.vim' --dry-run --offline --json </dev/null 2>/dev/null | grep -qE '\"fetched_at\":\"[0-9]{4}-'"
check "hors ligne : code 0 tant qu'aucun fetch n'a vu le nouveau commit" sh -c "HOME='$TGT' sh '$TGT/.vim/bin/deploy-local' --dir '$TGT/.vim' --dry-run --offline --json </dev/null >/dev/null 2>&1"
git -C "$TGT/.vim" fetch -q origin
check "après récupération : code 5 sans réseau"        sh -c "HOME='$TGT' sh '$TGT/.vim/bin/deploy-local' --dir '$TGT/.vim' --dry-run --offline --json </dev/null >/dev/null 2>&1; test \$? = 5"
check "dépôt injoignable simulé : message explicite"  sh -c "git -C '$TGT/.vim' remote set-url origin /introuvable && HOME='$TGT' sh '$TGT/.vim/bin/deploy-local' --dir '$TGT/.vim' --dry-run --json </dev/null 2>&1 | grep -q 'injoignable'; git -C '$TGT/.vim' remote set-url origin '$SRC'"

echo "== Trace en direct : JSON sur stdout, étapes sur stderr"
check "mise à jour en json"                           sh -c "HOME='$TGT' MY_VIM_NO_AUTOUPDATE=1 sh '$TGT/.vim/bin/deploy-local' --dir '$TGT/.vim' --no-plugins --json </dev/null >'$TMP/o.txt' 2>'$TMP/t.txt'; rc=\$?; test \$rc = 0 -o \$rc = 3"
check "stdout : une seule ligne, du JSON"             sh -c "test \$(wc -l < '$TMP/o.txt' | tr -d ' ') = 1 && head -c1 '$TMP/o.txt' | grep -q '{'"
check "stderr : étapes présentes"                     sh -c "grep -q 'Installation' '$TMP/t.txt'"

echo "== --https : adresse du dépôt forcée (compte sans clé SSH)"
git -C "$TGT/.vim" remote set-url origin git@github.com:peterhost/dotvim.git
check "--check --https bascule l'adresse en https"    sh -c "HOME='$TGT' sh '$TGT/.vim/bin/deploy-local' --dir '$TGT/.vim' --check --https --json </dev/null >/dev/null 2>&1; git -C '$TGT/.vim' remote get-url origin | grep -q '^https://github.com/'"
git -C "$TGT/.vim" remote set-url origin "$SRC"

check "aucun nom de machine dans les outils"          sh -c "! grep -rniE 'nas1|nas2|bikini|192\.168|tomneale|pierrelhoste' '$SRC/bin' '$SRC/config' '$SRC/autoload' '$SRC/vimrc'"

if [ -n "${TEST_NETWORK:-}" ]; then
  echo "== Installation de zéro depuis GitHub (réseau)"
  SCRATCH="$TMP/from-scratch"; mkdir -p "$SCRATCH"
  check "HOME vierge : clone depuis GitHub + installation" sh -c "HOME='$SCRATCH' sh '$ROOT/bin/deploy-local' --yes --json </dev/null >'$TMP/fs.json' 2>&1"
  check "action « clone » et état ok"                  sh -c "grep -q '\"action\":\"clone\"' '$TMP/fs.json' && grep -q '\"status\":\"ok\"' '$TMP/fs.json'"
  check "plugins installés"                            sh -c "test \$(ls '$SCRATCH/.vim/plugged' | wc -l | tr -d ' ') -ge 50"
  check "rien d'autre que .vim dans le HOME"           test "$(ls -A "$SCRATCH")" = .vim

  echo "== Premier lancement de vim : installation des plugins en arrière-plan (réseau)"
  new_home firstrun
  inst --yes --no-plugins
  (cd "$H" && HOME=$H TERM=xterm-256color script -q /dev/null vim -c 'call timer_start(1500, {-> execute("qa!")})' >/dev/null 2>&1 </dev/null)
  i=0; while [ $i -lt 90 ] && [ ! -f "$H/.vim/local/last-update" ]; do sleep 2; i=$((i + 1)); done
  check "plugins installés après le 1er lancement" test -d "$H/.vim/plugged/everforest"
fi

echo
echo "Installeur : $PASS réussis, $FAIL échec(s)"
[ "$FAIL" -eq 0 ]
