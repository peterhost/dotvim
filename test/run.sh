#!/bin/sh
# test/run.sh — batterie de tests de la configuration (make check)
#
# Pour chaque vim testé × chaque profil de terminal :
#   - démarrage sur chaque fichier d'exemple (test/fixtures) : aucune erreur,
#     type de fichier, niveau et thème attendus ;
#   - suite complète (test/probe.vim) : raccourcis, commandes, fonctions
#     d'édition, surlignages, tous les thèmes, plugins selon le niveau.
#
# Usage : sh test/run.sh [vim1 vim2 …]      (défaut : le vim du PATH)
#         TEST_VIMS="/chemin/vim73 …" sh test/run.sh
#         QUICK=1 : un seul profil de terminal et moins de fichiers
#
# Chaque vim est lancé dans un vrai pseudo-terminal (commande `script`),
# avec un HOME et un dossier local/ temporaires : rien n'est écrit chez vous.

set -u
ROOT=$(cd "$(dirname "$0")/.." && pwd)
TMP=$(mktemp -d "${TMPDIR:-/tmp}/vimtest.XXXXXX")
trap 'rm -rf "$TMP"' EXIT INT TERM
mkdir -p "$TMP/home" "$TMP/local"
# réglages locaux : local/vimrc.local doit l'emporter sur ~/.vimrc.local
echo "let g:my_test_local_rc = 'local'" > "$TMP/local/vimrc.local"
echo "let g:my_test_local_rc = 'home'" > "$TMP/home/.vimrc.local"

VIMS=${*:-${TEST_VIMS:-vim}}
PASS=0; FAIL=0; SKIP=0
FAILED=""

if [ -t 1 ] && command -v tput >/dev/null 2>&1 && [ "$(tput colors 2>/dev/null || echo 0)" -ge 8 ]; then
  G=$(tput setaf 2); R=$(tput setaf 1); Y=$(tput setaf 3); B=$(tput bold); N=$(tput sgr0)
else
  G=; R=; Y=; B=; N=
fi

# Lance une commande dans un pseudo-terminal (BSD et util-linux n'ont pas la
# même syntaxe pour `script`).
in_pty() {
  if script -q /dev/null true >/dev/null 2>&1 </dev/null; then
    script -q /dev/null "$@" >/dev/null 2>&1 </dev/null
  elif script -qc true /dev/null >/dev/null 2>&1 </dev/null; then
    # util-linux : la commande est une chaîne
    cmd=""; for a in "$@"; do cmd="$cmd '$(printf %s "$a" | sed "s/'/'\\\\''/g")'"; done
    script -qc "$cmd" /dev/null >/dev/null 2>&1 </dev/null
  else
    "$@" >/dev/null 2>&1 </dev/null
  fi
}

# Caractéristiques d'un vim : version (ex. 802), +eval, +job
vim_info() {
  "$1" --version 2>/dev/null | awk '
    /^VIM - Vi IMproved/ { split($5, v, "."); ver = v[1] * 100 + v[2] }
    /[+]eval/ { ev = 1 } /[+]job/ { job = 1 } /[+]termguicolors/ { tgc = 1 }
    END { printf "%d %d %d %d\n", ver, ev, job, tgc }'
}

# Profils de terminal : nom|variables
PROFILES="xterm256|TERM=xterm-256color COLORTERM= TERM_PROGRAM=
truecolor|TERM=xterm-256color COLORTERM=truecolor TERM_PROGRAM=
tmux|TERM=screen-256color COLORTERM= TERM_PROGRAM= TMUX=/tmp/fake,1,0
console|TERM=linux COLORTERM= TERM_PROGRAM=
vt100|TERM=vt100 COLORTERM= TERM_PROGRAM="
[ -n "${QUICK:-}" ] && PROFILES="xterm256|TERM=xterm-256color COLORTERM= TERM_PROGRAM="

FILES="NONE sample.md notes.txt doc/help.txt script.py app.js data.json page.xml
page.html style.css style.scss script.sh config.toml data.csv script.pl
sample.vim Makefile robot.mq4"
[ -n "${QUICK:-}" ] && FILES="NONE sample.md script.py"

record() { # record <statut> <libellé>
  case $1 in
    PASS) PASS=$((PASS + 1)) ;;
    FAIL) FAIL=$((FAIL + 1)); FAILED="$FAILED
  ${R}✗${N} $2" ;;
  esac
}

# Thème attendu selon la version de vim et le profil
expect_theme() { # <ver> <profil> <tgc>
  case $2 in
    console|vt100) echo noctu ;;
    *) if [ "$1" -ge 800 ]; then echo everforest; else echo PaperColor; fi ;;
  esac
}

run_vim() { # run_vim <vim> <env> <suite> <fichier> <sortie>
  vimbin=$1; envs=$2; suite=$3; file=$4; out=$5
  rm -f "$out"
  if [ "$file" = NONE ]; then set -- ; else set -- "$ROOT/test/fixtures/$file"; fi
  # shellcheck disable=SC2086
  in_pty env HOME="$TMP/home" MY_VIM_LOCAL="$TMP/local" MY_VIM_NO_AUTOUPDATE=1 VIMTEST_OUT="$out" \
    VIMTEST_SUITE="$suite" EXPECT_TIER="${EXPECT_TIER:-}" \
    EXPECT_THEME="${EXPECT_THEME:-}" EXPECT_FT="${EXPECT_FT:-}" $envs \
    sh -c 'stty rows 40 cols 120 2>/dev/null; exec "$0" "$@"' \
    "$vimbin" -N -u "$ROOT/vimrc" -i NONE -S "$ROOT/test/probe.vim" "$@"
}

# vim sans +eval (vim-tiny) : la sonde ne peut pas tourner ; on relève
# seulement les messages d'erreur au démarrage.
run_tiny() { # run_tiny <vim> <env> <fichier> <sortie>
  vimbin=$1; envs=$2; file=$3; out=$4
  rm -f "$out"
  if [ "$file" = NONE ]; then set -- ; else set -- "$ROOT/test/fixtures/$file"; fi
  # shellcheck disable=SC2086
  in_pty env HOME="$TMP/home" MY_VIM_NO_AUTOUPDATE=1 $envs \
    sh -c 'stty rows 40 cols 120 2>/dev/null; exec "$0" "$@"' \
    "$vimbin" -N -u "$ROOT/vimrc" -i NONE -c "redir! > $out" -c 'silent messages' \
    -c 'redir END' -c 'qa!' "$@"
}

expected_ft() {
  case $1 in
    *.md|*.txt) case $1 in doc/*) echo help ;; *) echo markdown ;; esac ;;
    *.py) echo python ;; *.js) echo javascript ;;
    *.json) if [ "${ver:-0}" -ge 704 ]; then echo json; else echo javascript; fi ;;
    *.xml) echo xml ;; *.html) echo html ;; *.css) echo css ;; *.scss) echo scss ;;
    *.sh) echo sh ;; *.toml) echo toml ;; *.pl) echo perl ;;
    *.csv) if [ "${ver:-0}" -ge 800 ]; then echo csv; else echo ""; fi ;;
    *.vim) echo vim ;; Makefile) echo make ;; *.mq4) echo mql4 ;; *) echo "" ;;
  esac
}

for vimbin in $VIMS; do
  if ! command -v "$vimbin" >/dev/null 2>&1; then
    echo "${Y}vim introuvable : $vimbin (ignoré)$N"; SKIP=$((SKIP + 1)); continue
  fi
  set -- $(vim_info "$vimbin"); ver=$1; has_eval=$2; has_job=$3; has_tgc=$4
  if [ "$has_eval" != 1 ]; then tier=none
  elif [ "$ver" -ge 800 ] && [ "$has_job" = 1 ]; then tier=full
  elif [ "$ver" -ge 703 ]; then tier=compat
  else tier=minimal; fi
  echo "$B== $vimbin (version $ver, niveau attendu : $tier) ==$N"

  OLDIFS=$IFS
  IFS='
'
  for profile in $PROFILES; do
    IFS=$OLDIFS
    pname=${profile%%|*}; penv=${profile#*|}
    np=0; nf=0
    for file in $FILES; do
      out="$TMP/out.txt"
      label="vim$ver [$pname] $file"
      if [ "$tier" = none ]; then
        run_tiny "$vimbin" "$penv" "$file" "$out"
        if [ ! -f "$out" ]; then record FAIL "$label : pas de sortie"; nf=$((nf + 1))
        elif grep -Eq '^E[0-9]+:|Error detected|line [0-9]+:$' "$out"; then
          record FAIL "$label : $(grep -E '^E[0-9]+:|Error' "$out" | head -3 | tr '\n' ' ')"; nf=$((nf + 1))
        else record PASS "$label"; np=$((np + 1)); fi
        continue
      fi
      EXPECT_TIER=$tier
      if [ "$file" = NONE ]; then EXPECT_FT=; else EXPECT_FT=$(expected_ft "$file"); fi
      # le thème attendu ne vaut que s'il n'a pas été changé dans local/
      rm -f "$TMP/local/theme.vim"
      EXPECT_THEME=$(expect_theme "$ver" "$pname" "$has_tgc")
      [ -d "$ROOT/plugged/everforest" ] || { [ "$EXPECT_THEME" = everforest ] && EXPECT_THEME=PaperColor; }
      run_vim "$vimbin" "$penv" startup "$file" "$out"
      if [ ! -f "$out" ]; then
        record FAIL "$label : vim n'a rien écrit (plantage ou blocage ?)"; nf=$((nf + 1)); continue
      fi
      while IFS= read -r line; do
        case $line in
          PASS*) np=$((np + 1)); PASS=$((PASS + 1)) ;;
          FAIL*) nf=$((nf + 1)); record FAIL "$label : ${line#FAIL }" ;;
        esac
      done < "$out"
    done
    # suite complète, une fois par profil
    if [ "$tier" != none ]; then
      out="$TMP/full.txt"; rm -f "$TMP/local/theme.vim"
      EXPECT_FT=; EXPECT_THEME=
      run_vim "$vimbin" "$penv" full NONE "$out"
      if [ ! -f "$out" ]; then
        record FAIL "vim$ver [$pname] suite : pas de sortie"; nf=$((nf + 1))
      else
        while IFS= read -r line; do
          case $line in
            PASS*) np=$((np + 1)); PASS=$((PASS + 1)) ;;
            FAIL*) nf=$((nf + 1)); record FAIL "vim$ver [$pname] ${line#FAIL }" ;;
            INFO*) [ -n "${VERBOSE:-}" ] && echo "    ${line#INFO }" ;;
          esac
        done < "$out"
      fi
    fi
    if [ "$nf" -eq 0 ]; then st="${G}OK$N"; else st="${R}$nf échec(s)$N"; fi
    printf '  %-10s %4d tests  %s\n' "$pname" $((np + nf)) "$st"
    IFS='
'
  done
  IFS=$OLDIFS
done

echo
if [ "$FAIL" -eq 0 ]; then
  echo "${G}${B}Tous les tests passent$N : $PASS réussis."
  exit 0
fi
echo "${R}${B}$FAIL échec(s)$N, $PASS réussis :$FAILED"
exit 1
