#!/bin/sh
# test/keys.sh — l'aide des raccourcis ne peut pas dériver du code
#
# Trois contrôles, du plus important au moins :
#   1. COUVERTURE : tout raccourci que vim charge depuis ce dépôt est décrit par
#      une annotation. C'est le contrôle décisif : il voit aussi les raccourcis
#      construits dynamiquement (execute '…map…'), qu'une lecture du texte rate.
#   2. Aucune ligne de mapping sans annotation (lecture du texte, message précis :
#      fichier, ligne, touches).
#   3. Aucune annotation orpheline : une annotation qui ne décrit plus rien
#      (raccourci supprimé, annotation restée).
#
# Lancé par « make check ». Voir bin/keys pour le format des annotations.

set -u
ROOT=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT" || exit 1
TMP=$(mktemp -d "${TMPDIR:-/tmp}/keys.XXXXXX")
trap 'rm -rf "$TMP"' EXIT INT TERM
NB=0
signaler() { NB=$((NB + 1)); printf '  ✗ %s\n' "$1"; }

# Forme canonique d'une touche, pour comparer ce qu'écrit vim (« <C-H> », « ,n »)
# et ce qu'affiche l'aide (« Ctrl-h », « ,n ») : minuscules, sans chevrons.
canon() {
  tr '[:upper:]' '[:lower:]' \
    | sed -E -e 's/(^|[<-])s-/\1maj-/g' -e 's/(^|[<-])c-/\1ctrl-/g' \
             -e 's/(^|[<-])a-/\1alt-/g' -e 's/(^|[<-])m-/\1alt-/g' \
             -e 's/(^|[<-])d-/\1cmd-/g' \
             -e 's/<?space>/espace/g' -e 's/<?cr>/entrée/g' -e 's/<?bs>/retour arrière/g' \
             -e 's/<?tab>/tab/g' -e 's/<?bar>/|/g' -e 's/<?esc>/échap/g' -e 's/<?del>/suppr/g' \
             -e 's/<?up>/↑/g' -e 's/<?down>/↓/g' -e 's/<?left>/←/g' -e 's/<?right>/→/g' \
             -e 's/<([a-z][a-z0-9_-]*)>/\1/g' -e 's/([a-z0-9])>/\1/g' -e 's/<([a-z])/\1/g' \
             -e 's/^ +//' -e 's/ +$//' \
    | grep -v '^$' | sort -u
}

# --- 1. couverture face à vim ---------------------------------------------------------------
# On demande à vim la liste de ses raccourcis et leur script d'origine, puis on
# ne garde que ceux qui viennent de ce dépôt (les centaines de raccourcis des
# greffons ne nous concernent pas). Plusieurs types de fichiers sont ouverts,
# pour attraper aussi les raccourcis propres à un type (python, markdown…).
cat > "$TMP/liste.vim" <<'VIM'
let s:noms = {}
if exists('*getscriptinfo')
  for s:s in getscriptinfo()
    let s:noms[s:s.sid] = s:s.name
  endfor
endif
let s:out = []
if exists('*maplist')
  for s:m in maplist()
    let s:src = get(s:noms, s:m.sid, '')
    " les greffons vivent sous plugged/, à l’intérieur de ~/.vim : leurs propres
    " raccourcis (unimpaired, commenter…) ne sont pas les nôtres à documenter.
    if s:src =~# '^' . escape(g:my_dir, '\.') && s:src !~# '/plugged/'
          \ && s:m.lhs !~# '^<Plug>'
      call add(s:out, s:m.lhs)
    endif
  endfor
endif
call writefile(s:out, $KEYS_OUT, 'a')
qall!
VIM
: > "$TMP/vivants"
for f in "" test/fixtures/sample.md test/fixtures/script.py test/fixtures/app.js \
         test/fixtures/script.pl test/fixtures/data.json test/fixtures/page.xml \
         test/fixtures/doc/help.txt; do
  KEYS_OUT="$TMP/vivants" MY_VIM_NO_AUTOUPDATE=1 MY_VIM_LOCAL="$TMP/local" \
    vim -N -u "$ROOT/vimrc" -i NONE -es -S "$TMP/liste.vim" ${f:+"$f"} </dev/null >/dev/null 2>&1
done
canon < "$TMP/vivants" > "$TMP/vivants.canon"

# Les touches décrites par l'aide. « --touches » donne les touches RÉELLES, y
# compris quand l'aide en affiche une forme abrégée (« ,1 … ,9 »).
sh bin/keys --touches 2>/dev/null | canon > "$TMP/decrits.canon"

manquants=$(comm -23 "$TMP/vivants.canon" "$TMP/decrits.canon")
if [ -n "$manquants" ]; then
  n=$(printf '%s\n' "$manquants" | grep -c .)
  signaler "$n raccourci(s) chargé(s) par vim sans annotation :"
  printf '%s\n' "$manquants" | head -20 | sed 's/^/      /'
  [ "$n" -gt 20 ] && printf '      … (%s de plus ; « sh bin/keys --todo » donne fichier et ligne)\n' "$((n - 20))"
fi

# --- 2. lignes de mapping sans annotation ---------------------------------------------------
todo=$(sh bin/keys --todo 2>/dev/null)
if [ -n "$todo" ]; then
  n=$(printf '%s\n' "$todo" | grep -c .)
  signaler "$n ligne(s) sans annotation « \"= thème | description » :"
  printf '%s\n' "$todo" | head -15 | sed 's/^/      /'
  [ "$n" -gt 15 ] && printf '      … (%s de plus : sh bin/keys --todo)\n' "$((n - 15))"
fi

# --- 3. annotations orphelines ---------------------------------------------------------------
orphelines=$(sh bin/keys --tsv 2>&1 >/dev/null | grep '^ORPHELINE' || true)
if [ -n "$orphelines" ]; then
  signaler "annotation(s) ne décrivant plus rien :"
  printf '%s\n' "$orphelines" | sed 's/^ORPHELINE\t/      /'
fi

# --- verdict ------------------------------------------------------------------------------------
decrits=$(grep -c . "$TMP/decrits.canon" 2>/dev/null || echo 0)
vivants=$(grep -c . "$TMP/vivants.canon" 2>/dev/null || echo 0)
printf 'keys : %s touche(s) décrite(s), %s chargée(s) par vim depuis ce dépôt\n' "$decrits" "$vivants"
if [ "$NB" -gt 0 ]; then
  printf 'keys : %d problème(s) — l’aide et le code ont divergé.\n' "$NB"
  exit 1
fi
echo "keys : l'aide décrit tous les raccourcis ✓"
