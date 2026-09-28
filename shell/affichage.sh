# shell/affichage.sh — la couche d'affichage de vrc (sh POSIX, à sourcer)
#
# Les noms sont ceux de lib/tui.sh de dotlib (tui_title, tui_ok, TUI_INTERACTIVE,
# C_R_KEY…) pour que vrc ait exactement l'allure des outils du shell. On ne
# source PAS dotlib : sa bibliothèque demande bash 3.2, alors que vrc doit
# tourner sous le sh des NAS Synology. Ce sont donc les mêmes noms, pas le même
# code — et une seule apparence sur toutes les machines, dotlib ou non.
#
# Le RÉGLAGE du thème, lui, vient bien de dotlib quand il est là : variables
# exportées par le shell (DOTLIB_THEME_EFF), sinon ~/.dotlib/local/theme.conf.
# Absent : clair/sombre par défaut. Aucune dépendance dure, aucun processus lancé.

TUI_INTERACTIVE=0
[ -t 0 ] && [ -t 1 ] && TUI_INTERACTIVE=1

# Clair ou sombre : ce que le shell a résolu, sinon le fichier de dotlib, sinon sombre.
TUI_FOND=${DOTLIB_THEME_EFF:-}
if [ -z "$TUI_FOND" ] && [ -r "${DOTLIB_DIR:-$HOME/.dotlib}/local/theme.conf" ]; then
  TUI_FOND=$(sed -n 's/^[ 	]*DOTLIB_THEME=//p' "${DOTLIB_DIR:-$HOME/.dotlib}/local/theme.conf" | tail -1)
fi
case $TUI_FOND in light|dark) ;; *) TUI_FOND=dark ;; esac

# Profondeur de couleur : sans tput (absent de certains systèmes).
TUI_COULEURS=8
case ${TERM:-} in
  *256*|*direct*) TUI_COULEURS=256 ;;
  linux|vt100|vt220|dumb) TUI_COULEURS=8 ;;
esac
[ -n "${COLORTERM:-}" ] && TUI_COULEURS=256
[ -t 1 ] && [ -z "${NO_COLOR:-}" ] || TUI_COULEURS=0

if [ "$TUI_COULEURS" = 0 ]; then
  T_RESET= T_BOLD= T_DIM= T_UL= T_REV=
  T_RED= T_GREEN= T_YELLOW= T_BLUE= T_MAGENTA= T_CYAN= T_GREY=
  C_R_NUM= C_R_DATE= C_R_TEXT= C_R_MATCH= C_R_KEY= C_R_PATH= C_R_BAD= C_R_NOTE=
else
  e=$(printf '\033')
  T_RESET="${e}[0m" T_BOLD="${e}[1m" T_DIM="${e}[2m" T_UL="${e}[4m" T_REV="${e}[7m"
  T_RED="${e}[31m" T_GREEN="${e}[32m" T_YELLOW="${e}[33m" T_BLUE="${e}[34m"
  T_MAGENTA="${e}[35m" T_CYAN="${e}[36m" T_GREY="${e}[90m"
  C_R_KEY="${e}[1;36m" C_R_TEXT="$T_GREY" C_R_PATH="$T_GREY" C_R_NUM="${e}[35m"
  C_R_DATE="${e}[34m" C_R_BAD="${e}[31m" C_R_NOTE="${e}[33m" C_R_MATCH="${e}[1;33m"
  if [ "$TUI_FOND" = light ]; then
    T_GREY="${e}[37m"; C_R_TEXT=; C_R_PATH="${e}[34m"; C_R_MATCH="${e}[1;7;33m"
  fi
  # console linux : pas de « dim », bleu foncé illisible
  case ${TERM:-} in linux) T_DIM=; T_BLUE="${e}[1;34m"; C_R_DATE="${e}[1;34m"; C_R_TEXT= ;; esac
  unset e
fi

TUI_OK='✓' TUI_KO='✗' TUI_WARN='!' TUI_PTR='›'
case ${LC_ALL:-${LC_CTYPE:-${LANG:-}}} in *[Uu][Tt][Ff]*8*) ;; *) TUI_OK='+' TUI_KO='x' TUI_PTR='>' ;; esac
[ "${TERM:-}" = linux ] && TUI_OK='+' TUI_KO='x' TUI_PTR='>'

tui_title() { printf '\n%s%s== %s ==%s\n' "$T_BOLD" "$T_CYAN" "$*" "$T_RESET"; }
tui_info()  { printf '  %s\n' "$*"; }
tui_ok()    { printf '  %s%s%s %s\n' "$T_GREEN" "$TUI_OK" "$T_RESET" "$*"; }
tui_warn()  { printf '  %s%s%s %s\n' "$T_YELLOW" "$TUI_WARN" "$T_RESET" "$*" >&2; }
tui_err()   { printf '  %s%s%s %s\n' "$T_RED" "$TUI_KO" "$T_RESET" "$*" >&2; }
tui_die()   { tui_err "$1"; exit "${2:-1}"; }

# tui_confirm "Question ?" [o|n] — sans terminal, le défaut répond (jamais de blocage)
tui_confirm() {
  [ "${TUI_YES:-0}" = 1 ] && return 0
  if [ "$TUI_INTERACTIVE" = 0 ]; then [ "${2:-n}" = o ]; return; fi
  if [ "${2:-n}" = o ]; then hint='[O/n]'; else hint='[o/N]'; fi
  printf '%s%s%s %s ' "$T_BOLD" "$1" "$T_RESET" "$hint"
  read -r ans || ans=
  [ -n "$ans" ] || ans=${2:-n}
  case $ans in [oOyY]*) return 0 ;; *) return 1 ;; esac
}

# tui_table : colonnes séparées par des tabulations → alignées (stdin).
# Les codes couleur et les octets de continuation UTF-8 ne comptent pas.
tui_table() {
  LC_ALL=C awk -F '\t' '
    function vis(s) { gsub(/\033\[[0-9;]*m/, "", s); gsub(/[\200-\277]/, "", s); return length(s) }
    { for (i = 1; i <= NF; i++) { cell[NR, i] = $i; w = vis($i); if (w > max[i]) max[i] = w }
      if (NF > nf) nf = NF; rows = NR }
    END { for (r = 1; r <= rows; r++) { line = ""
            for (i = 1; i <= nf; i++) { c = cell[r, i]; pad = max[i] - vis(c)
              line = line c (i < nf ? sprintf("%" (pad + 2) "s", "") : "") }
            print line } }'
}
