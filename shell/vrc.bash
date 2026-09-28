# shell/vrc.bash — la commande « vrc » dans bash (bash 3.2+, à sourcer)
#
# Chargé par la configuration bash (lots/80-vim.sh), ou à la main :
#   [ -r ~/.vim/shell/vrc.bash ] && . ~/.vim/shell/vrc.bash
#
# AU CHARGEMENT : aucune sortie, aucun processus lancé — ni vim, ni git, ni
# command -v. Un shell qui démarre ne doit rien payer pour cette commande.
# Tout le travail est dans bin/vrc (sh POSIX) ; ici, seulement ce qui doit
# vivre DANS le shell : « vrc cd », la complétion, et le pont vers brc.

_VRC_DIR=${BASH_SOURCE[0]%/shell/vrc.bash}
[ -n "$_VRC_DIR" ] || _VRC_DIR=$HOME/.vim

# Chemin absolu, résolu au premier appel seulement.
_vrc_dir() {
  case $_VRC_DIR in
    /*) ;;
    *) _VRC_DIR=$(cd "$_VRC_DIR" 2>/dev/null && pwd -P) || _VRC_DIR=$HOME/.vim ;;
  esac
  printf '%s' "$_VRC_DIR"
}

vrc() {
  local d
  d=$(_vrc_dir)
  case ${1:-} in
    cd) shift; cd "$d" || return 1 ;;                 # doit rester dans ce shell
    reload) . "${HOME}/.bashrc" ;;                    # pendant de « brc reload »
    *) sh "$d/bin/vrc" "$@" ;;
  esac
}

# Pendant de « vibrc » : éditer la configuration vim.
vivrc() { vrc edit "$@"; }

# Pont vers brc : « brc vim … » marche, et brc help annonce vrc.
# (brc appelle _brc_cmd_<nom> --summary pour construire son aide.)
_brc_cmd_vim() {
  if [ "${1:-}" = --summary ]; then
    printf 'brc vim …     = vrc : la configuration vim (raccourcis, état, greffons, thèmes)\n'
    return 0
  fi
  vrc "$@"
}

# --- Complétion -------------------------------------------------------------------------
_vrc_complete() {
  local cur prev cmds d
  cur=${COMP_WORDS[COMP_CWORD]}
  prev=${COMP_WORDS[COMP_CWORD-1]}
  cmds="interface raccourcis etat greffons themes journal maj nettoyer verifier edit cd version aide"
  d=$(_vrc_dir)
  if [ "$COMP_CWORD" -le 1 ]; then
    COMPREPLY=($(compgen -W "$cmds" -- "$cur"))
    return
  fi
  case $prev in
    raccourcis|touches)
      COMPREPLY=($(compgen -W "$(sh "$d/bin/keys" --themes 2>/dev/null | tr '\n' ' ') --tsv --regenerer" -- "$cur")) ;;
    edit|editer|éditer)
      COMPREPLY=($(compgen -W "$(sh "$d/bin/vrc" --fichiers-edit 2>/dev/null | tr '\n' ' ')" -- "$cur")) ;;
    etat|état|doctor) COMPREPLY=($(compgen -W "--json" -- "$cur")) ;;
    journal|log) COMPREPLY=($(compgen -W "--install" -- "$cur")) ;;
    verifier|vérifier|check) COMPREPLY=($(compgen -W "--rapide" -- "$cur")) ;;
    *) COMPREPLY=() ;;
  esac
}
complete -F _vrc_complete vrc vivrc
