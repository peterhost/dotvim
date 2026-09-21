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
check "~/.vimrc est le fichier généré"   grep -q 'source ~/.vim/vimrc' "$H/.vimrc"
check "~/.gvimrc est le fichier généré"  grep -q 'source ~/.vim/gvimrc' "$H/.gvimrc"
check "aucune sauvegarde inutile"        test -z "$(ls "$H" | grep bak)"
check "~/.vimrc.local non créé"          test ! -e "$H/.vimrc.local"
check "vim démarre sans erreur"          grep -q 'aucune erreur' "$TMP/out.txt"

echo "== Réinstallation (idempotence)"
check "2e installation réussie"          inst --yes --no-plugins
check "toujours aucune sauvegarde"       test -z "$(ls "$H" | grep bak)"

echo "== Migration depuis l'ancien bootstrap (liens symboliques)"
new_home legacy
ln -s "$H/.vim/vimrc" "$H/.vimrc"
: > "$H/.vim/vimrc.local"; ln -s "$H/.vim/vimrc.local" "$H/.vimrc.local"
echo '" set guifont=X' > "$H/.vim/gvimrc.local"; ln -s "$H/.vim/gvimrc.local" "$H/.gvimrc.local"
echo '" perso' > "$H/.gvimrc"
check "installation réussie"             inst --yes --no-plugins
check "ancien ~/.vimrc sauvegardé"       test -L "$(ls -d "$H"/.vimrc.bak-* | head -1)"
check "ancien ~/.gvimrc sauvegardé"      grep -q perso "$(ls -d "$H"/.gvimrc.bak-* | head -1)"
check "lien .vimrc.local vide retiré"    test ! -e "$H/.vimrc.local"
check "lien .gvimrc.local -> vrai fichier" sh -c "test -f '$H/.gvimrc.local' && test ! -L '$H/.gvimrc.local'"
check "contenu de .gvimrc.local conservé" grep -q guifont "$H/.gvimrc.local"

echo "== Désinstallation"
check "désinstallation réussie"          inst --uninstall --yes
check "~/.vimrc d'origine restauré"      test -L "$H/.vimrc"
check "~/.gvimrc d'origine restauré"     grep -q perso "$H/.gvimrc"

echo "== Essai côte à côte (git worktree)"
new_home try
check "essai de la branche master"       inst --try --branch master --no-plugins --yes
check "worktree ~/.vimnew créé"          test -f "$H/.vimnew/vimrc"
check "~/.vimrc non touché"              test ! -e "$H/.vimrc"
check "essai refusé si ~/.vimnew existe" sh -c "! HOME='$H' sh '$H/.vim/bin/install' --try --branch master --no-plugins --yes </dev/null"

echo "== Changement de branche refusé si modifications en cours"
new_home dirty
echo x >> "$H/.vim/README.md"
check "installation d'une autre branche refusée" sh -c "! HOME='$H' sh '$H/.vim/bin/install' --yes --branch master --no-plugins </dev/null"

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

if [ -n "${TEST_NETWORK:-}" ]; then
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
