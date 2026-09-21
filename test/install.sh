#!/bin/sh
# test/install.sh — tests de bin/install et bin/update-plugins
#
# Chaque scénario tourne dans un HOME temporaire contenant une copie du dépôt :
# rien n'est modifié chez vous. Plugins non téléchargés (--no-plugins), sauf
# le test d'installation en arrière-plan (TEST_NETWORK=1 pour l'activer).

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
inst() { HOME=$H USER=test MY_VIM_NO_AUTOUPDATE=1 sh "$H/.vim/bin/install" "$@" </dev/null >"$TMP/out.txt" 2>&1; }

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
