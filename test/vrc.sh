#!/bin/sh
# test/vrc.sh — tests de bin/vrc, shell/affichage.sh et shell/vrc.bash
#
# Rien n'est modifié : ces commandes sont en lecture seule (etat, greffons,
# raccourcis…). Les commandes qui écrivent (maj, nettoyer, verifier) sont
# couvertes par test/install.sh ; ici on vérifie leur refus d'arguments.
# TEST_SH=dash : passer bin/vrc à un autre shell.

set -u
ROOT=$(cd "$(dirname "$0")/.." && pwd)
TMP=$(mktemp -d "${TMPDIR:-/tmp}/vimtest-vrc.XXXXXX")
trap 'rm -rf "$TMP"' EXIT INT TERM
PASS=0; FAIL=0
SH=${TEST_SH:-sh}
VRC="$SH $ROOT/bin/vrc"

check() { # check <libellé> <commande…>
  label=$1; shift
  if "$@" >/dev/null 2>&1; then PASS=$((PASS + 1)); printf '  ok   %s\n' "$label"
  else FAIL=$((FAIL + 1)); printf '  ÉCHEC %s\n' "$label"; fi
}
sortie() { $VRC "$@" >"$TMP/out" 2>"$TMP/err"; printf '%s' $? > "$TMP/code"; }
code() { cat "$TMP/code"; }

echo "== Liste des commandes et commande inconnue"
sortie
check "sans argument : la liste, code 0"  sh -c "[ \"$(code)\" = 0 ]"
check "la liste nomme les sous-commandes" grep -q 'vrc raccourcis' "$TMP/out"
sortie inconnue
check "commande inconnue : code 2"        sh -c "[ \"$(code)\" = 2 ]"
check "erreur sur stderr, préfixée vrc :" grep -q '^vrc : commande inconnue' "$TMP/err"
check "rien sur stdout"                   test ! -s "$TMP/out"
sortie aide
check "vrc aide : code 0"                 sh -c "[ \"$(code)\" = 0 ]"

echo "== Raccourcis"
sortie raccourcis
check "aide des raccourcis non vide"      test -s "$TMP/out"
check "un thème connu y figure"           grep -q 'buffers' "$TMP/out"
sortie raccourcis git
check "un seul thème : code 0"            sh -c "[ \"$(code)\" = 0 ]"
check "le thème demandé est là"           grep -q 'GBrowse\|:Git' "$TMP/out"
check "les autres thèmes sont absents"    sh -c "! grep -q 'NERDTree' '$TMP/out'"
sortie raccourcis pasuntheme
check "thème inconnu : code 2"            sh -c "[ \"$(code)\" = 2 ]"
check "les thèmes possibles sont dits"    grep -q 'thèmes :' "$TMP/err"
sortie raccourcis --tsv
check "--tsv : cinq colonnes"             awk -F'\t' 'NF != 5 { exit 1 }' "$TMP/out"
check "--tsv : source = vim"              awk -F'\t' '$1 != "vim" { exit 1 }' "$TMP/out"
sortie raccourcis --pasuneoption
check "option inconnue : code 2"          sh -c "[ \"$(code)\" = 2 ]"
# Un lecteur qui s'arrête tôt (grep -q sur la liste des thèmes, « | head »,
# « less » quitté avant la fin) ne doit rien faire écrire sur la sortie d'erreur.
sortie raccourcis thèmes
check "un thème nommé : rien sur stderr"  test ! -s "$TMP/err"
for CMD in "raccourcis" "raccourcis git" "etat" "greffons" "themes" "journal"; do
  check "lecture interrompue, rien sur stderr : vrc $CMD" sh -c \
    "$VRC $CMD 2>'$TMP/e' | head -2 >/dev/null; test ! -s '$TMP/e'"
done
for OPT in "" "--tsv" "--themes" "--ordre" "--commandes" "--touches"; do
  check "lecture interrompue, rien sur stderr : keys $OPT" sh -c \
    "$SH '$ROOT/bin/keys' $OPT 2>'$TMP/e' | head -2 >/dev/null; test ! -s '$TMP/e'"
done

echo "== État"
sortie etat --json
check "--json : une seule ligne"          sh -c "[ \"$(grep -c . "$TMP/out")\" = 1 ]"
check "--json : JSON valide"              sh -c "command -v python3 >/dev/null || exit 0; python3 -m json.tool < '$TMP/out' >/dev/null"
check "--json : champ dotlib présent"     grep -q '"dotlib":' "$TMP/out"
check "--json : champ theme_follows"      grep -q '"theme_follows":"fond"' "$TMP/out"
sortie etat
check "état lisible : le dépôt"           grep -q 'dépôt' "$TMP/out"
check "état lisible : les greffons"       grep -q 'greffons' "$TMP/out"
check "état lisible : le thème et dotlib" sh -c "grep -q 'thème' '$TMP/out' && grep -q 'dotlib' '$TMP/out'"
sortie etat --pasuneoption
check "argument de trop : code 2"         sh -c "[ \"$(code)\" = 2 ]"

echo "== Greffons, thèmes, journal, version"
sortie greffons
check "greffons : au moins un installé"   grep -q 'installé' "$TMP/out"
check "greffons : un compte final"        grep -q 'installé(s)' "$TMP/out"
sortie themes
check "thèmes : celui en cours"           grep -q 'en cours' "$TMP/out"
check "thèmes : les disponibles"          grep -q 'disponibles' "$TMP/out"
sortie journal 5
check "journal : code 0"                  sh -c "[ \"$(code)\" = 0 ]"
sortie journal pasunnombre
check "journal : nombre attendu, code 2"  sh -c "[ \"$(code)\" = 2 ]"
sortie journal --install 3
check "journal --install : code 0"        sh -c "[ \"$(code)\" = 0 ]"
sortie version
check "version : parle de vim"            grep -q 'vim' "$TMP/out"
sortie cd
check "cd : imprime le dépôt"             sh -c "[ \"$(cat "$TMP/out")\" = \"$ROOT\" ]"

echo "== Édition"
sortie edit pasunfichier
check "fichier inconnu : code 2"          sh -c "[ \"$(code)\" = 2 ]"
check "les fichiers connus sont dits"     grep -q 'connus :' "$TMP/err"
sortie --fichiers-edit
check "liste pour la complétion"          grep -q '^mappings$' "$TMP/out"

echo "== Commandes qui écrivent : refus d'arguments inutiles"
sortie nettoyer trop
check "nettoyer : code 2"                 sh -c "[ \"$(code)\" = 2 ]"
sortie maj trop
check "maj : code 2"                      sh -c "[ \"$(code)\" = 2 ]"
sortie verifier trop
check "verifier : code 2"                 sh -c "[ \"$(code)\" = 2 ]"

echo "== Couche d'affichage (shell/affichage.sh)"
check "sourçable telle quelle"            sh -c ". '$ROOT/shell/affichage.sh'"
check "sans terminal : TUI_INTERACTIVE=0" sh -c ". '$ROOT/shell/affichage.sh'; [ \"\$TUI_INTERACTIVE\" = 0 ]"
check "sans terminal : aucune couleur"    sh -c ". '$ROOT/shell/affichage.sh'; [ -z \"\$T_RESET\" ]"
check "tui_ok écrit sur stdout"           sh -c ". '$ROOT/shell/affichage.sh'; [ -n \"\$(tui_ok essai 2>/dev/null)\" ]"
check "tui_err écrit sur stderr"          sh -c ". '$ROOT/shell/affichage.sh'; [ -z \"\$(tui_err essai 2>/dev/null)\" ]"
check "tui_confirm : défaut non, sans tty" sh -c ". '$ROOT/shell/affichage.sh'; ! tui_confirm 'Q ?' n"
check "tui_confirm : défaut oui, sans tty" sh -c ". '$ROOT/shell/affichage.sh'; tui_confirm 'Q ?' o"
check "tui_table aligne les colonnes"     sh -c ". '$ROOT/shell/affichage.sh'; printf 'a\tx\nbbbb\ty\n' | tui_table | awk 'NR==1{p=index(\$0,\"x\")} NR==2{exit index(\$0,\"y\") != p}'"
# les accents comptent pour un caractère, pas pour deux octets : vérifié en
# python quand il est là (awk, lui, compte tantôt l'un tantôt l'autre)
check "tui_table compte les caractères"   sh -c "command -v python3 >/dev/null || exit 0
  . '$ROOT/shell/affichage.sh'
  printf 'aé\tx\nbbbb\ty\n' | tui_table | python3 -c \"
import sys
l = sys.stdin.read().splitlines()
sys.exit(0 if l[0].index('x') == l[1].index('y') else 1)\""
check "aucune séquence ANSI hors terminal" sh -c ". '$ROOT/shell/affichage.sh'; tui_title T | grep -q '\033' && exit 1; exit 0"

echo "== Fonction bash (shell/vrc.bash)"
if command -v bash >/dev/null 2>&1; then
  B="bash --noprofile --norc -c"
  check "syntaxe bash valide"             bash -n "$ROOT/shell/vrc.bash"
  check "chargement silencieux"           sh -c "[ -z \"\$($B '. $ROOT/shell/vrc.bash' 2>&1)\" ]"
  check "définit vrc, vivrc, _brc_cmd_vim" $B ". '$ROOT/shell/vrc.bash'; declare -F vrc >/dev/null && declare -F vivrc >/dev/null && declare -F _brc_cmd_vim >/dev/null"
  check "définit la complétion"           $B ". '$ROOT/shell/vrc.bash'; complete -p vrc >/dev/null"
  check "vrc cd change de dossier"        $B ". '$ROOT/shell/vrc.bash'; vrc cd && [ \"\$PWD\" = '$ROOT' ]"
  check "vrc délègue à bin/vrc"           $B ". '$ROOT/shell/vrc.bash'; vrc version | grep -q vim"
  check "brc vim : résumé sur une ligne"  $B ". '$ROOT/shell/vrc.bash'; [ \"\$(_brc_cmd_vim --summary | grep -c .)\" = 1 ]"
  check "complétion : les sous-commandes" $B ". '$ROOT/shell/vrc.bash'; COMP_WORDS=(vrc r); COMP_CWORD=1; _vrc_complete; printf '%s\n' \"\${COMPREPLY[@]}\" | grep -q raccourcis"
  check "complétion : les thèmes"         $B ". '$ROOT/shell/vrc.bash'; COMP_WORDS=(vrc raccourcis g); COMP_CWORD=2; _vrc_complete; printf '%s\n' \"\${COMPREPLY[@]}\" | grep -q git"
else
  echo "  (bash absent : tests de shell/vrc.bash sautés)"
fi

echo "== Interface à onglets"
check "vrc ui est bien le synonyme de vrc interface" sh -c \
  "$VRC ui --pasuneoption 2>&1 | grep -q 'usage : vrc interface'"
if command -v python3 >/dev/null 2>&1; then
  check "python valide"                   python3 -c "import ast; ast.parse(open('$ROOT/bin/vrc-interface').read())"
  check "sans terminal : code 4"          sh -c "python3 '$ROOT/bin/vrc-interface' </dev/null >/dev/null 2>&1; [ \$? = 4 ]"
  check "sans terminal : le dit sur stderr" sh -c "python3 '$ROOT/bin/vrc-interface' </dev/null 2>&1 >/dev/null | grep -q '^vrc :'"
  # Le premier onglet mêle les raccourcis de vim et ceux du shell. On ne dépend
  # pas de la présence de dotbash : un faux « bindhelp » suffit à vérifier le
  # mélange, le format à cinq colonnes et la tolérance à son absence.
  mkdir -p "$TMP/faux"
  printf '#!/bin/sh\nprintf "bash\\thistorique\\tCtrl-x\\tfaire quelque chose\\tmode insertion\\n"\n' \
    > "$TMP/faux/bindhelp"
  chmod +x "$TMP/faux/bindhelp"
  cat > "$TMP/melange.py" <<'PYFIN'
# bin/vrc-interface n'a pas de suffixe .py : on le charge par un chargeur explicite.
# Et surtout : PAS de cache — un __pycache__ dans le dépôt serait un reste, et un
# .pyc contient le chemin absolu de son source (donc un chemin de home nommé).
import os
import subprocess
import sys
sys.dont_write_bytecode = True
import importlib.machinery, importlib.util


def sortie(commande, cwd=None, env=None, delai=60):
    # l'affichage vit chez dotlib ; ce test n'éprouve que notre mélange des deux aides,
    # il lui suffit donc d'une fonction de sortie minimale
    e = dict(os.environ, NO_COLOR="1")
    if env:
        e.update(env)
    try:
        r = subprocess.run(commande, cwd=cwd, env=e, stdin=subprocess.DEVNULL,
                           stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=delai)
    except (OSError, subprocess.TimeoutExpired):
        return []
    return [l.rstrip() for l in r.stdout.decode("utf-8", "replace").splitlines()]
chargeur = importlib.machinery.SourceFileLoader("interface", sys.argv[1])
module = importlib.util.module_from_spec(importlib.util.spec_from_loader("interface", chargeur))
chargeur.exec_module(module)
entrees = module.raccourcis_tsv(sortie)
attendu = ["bash", "historique", "Ctrl-x", "faire quelque chose", "mode insertion"]
if not entrees or not all(len(e) == 5 for e in entrees):
    sys.exit(1)
if sys.argv[2] == "melange":
    sys.exit(0 if attendu in entrees and any(e[0] == "vim" for e in entrees) else 1)
sys.exit(0 if all(e[0] == "vim" for e in entrees) else 1)
PYFIN
  CHEMIN=$PATH; PATH="$TMP/faux:$PATH"
  check "l'onglet mêle vim et le shell"  sh -c \
    "VRC_REPO='$ROOT' PYTHONDONTWRITEBYTECODE=1 python3 -B '$TMP/melange.py' '$ROOT/bin/vrc-interface' melange"
  PATH=$CHEMIN
  # HOME déplacé : sinon, sur une machine qui a dotbash, ~/.bash/bin/bindhelp
  # répondrait et le cas « aide du shell absente » ne serait pas testable.
  check "shell absent : vim seul, sans erreur" sh -c \
    "HOME='$TMP' VRC_REPO='$ROOT' PYTHONDONTWRITEBYTECODE=1 python3 -B '$TMP/melange.py' '$ROOT/bin/vrc-interface' seul"
  # ces tests importent un module du dépôt : ils ne doivent pas y laisser de cache
  check "aucun __pycache__ laissé dans le dépôt" sh -c "! find '$ROOT' -name __pycache__ -type d | grep -q ." 
  # Le socle commun de dotlib est préféré quand il est là et que son API convient,
  # sinon l'interface de ce dépôt prend le relais. On l'éprouve avec un FAUX module,
  # pour ne dépendre ni de la présence de dotlib ni de sa version.
  faux_module() { # faux_module <dossier> <API> <API_COMPATIBLES>
    mkdir -p "$1/lib"
    { printf 'API = %s\n' "$2"
      printf 'API_COMPATIBLES = %s\n' "$3"
      printf 'class Onglet:\n    def __init__(self, titre, produire, genre="texte", action=None):\n'
      printf '        self.titre = titre\n'
      printf 'def sortie(commande, cwd=None, env=None, delai=60):\n    return ["x"]\n'
      printf 'def lancer(liste, nom=""):\n'
      printf '    print("FAUX-MODULE %%d onglets pour %%s" %% (len(liste), nom))\n'
      printf '    return 7\n'; } > "$1/lib/onglets.py"
  }
  faux_module "$TMP/dl1" 1 "(1,)"
  faux_module "$TMP/dl2" 2 "(2,)"
  mkdir -p "$TMP/dl3/lib"        # dotlib présent, mais SANS le module
  check "socle d'API 1 : employé, six onglets" sh -c \
    "DOTLIB_DIR='$TMP/dl1' VRC_REPO='$ROOT' PYTHONDONTWRITEBYTECODE=1 python3 -B '$ROOT/bin/vrc-interface' 2>/dev/null | grep -q 'FAUX-MODULE 6 onglets pour vrc'"
  check "socle d'API 1 : son code de retour est rendu" sh -c \
    "DOTLIB_DIR='$TMP/dl1' VRC_REPO='$ROOT' PYTHONDONTWRITEBYTECODE=1 python3 -B '$ROOT/bin/vrc-interface' >/dev/null 2>&1; [ \$? = 7 ]"
  check "socle d'API 2 : écarté, affichage à la suite" sh -c \
    "DOTLIB_DIR='$TMP/dl2' VRC_REPO='$ROOT' PYTHONDONTWRITEBYTECODE=1 python3 -B '$ROOT/bin/vrc-interface' 2>&1 | grep -q \"socle d'interface indisponible\""
  check "dotlib sans le module : affichage à la suite" sh -c \
    "DOTLIB_DIR='$TMP/dl3' VRC_REPO='$ROOT' PYTHONDONTWRITEBYTECODE=1 python3 -B '$ROOT/bin/vrc-interface' 2>&1 | grep -q \"socle d'interface indisponible\""
  check "dotlib absent : affichage à la suite" sh -c \
    "DOTLIB_DIR='$TMP/inexistant' VRC_REPO='$ROOT' PYTHONDONTWRITEBYTECODE=1 python3 -B '$ROOT/bin/vrc-interface' 2>&1 | grep -q \"socle d'interface indisponible\""
  check "aucun __pycache__ chez le faux dotlib"  sh -c "! find '$TMP/dl1' -name __pycache__ | grep -q ."
  if command -v script >/dev/null 2>&1 && [ "${TEST_NO_PTY:-0}" != 1 ]; then
    check "dans un terminal : s'ouvre et se ferme sur q" sh -c \
      "printf q | TERM=xterm script -q /dev/null python3 '$ROOT/bin/vrc-interface' >/dev/null 2>&1"
  fi
else
  echo "  (python3 absent : interface sautée, bin/vrc affiche à la suite)"
fi

printf '\nvrc : %d réussis, %d échoués\n' "$PASS" "$FAIL"
[ "$FAIL" = 0 ]
