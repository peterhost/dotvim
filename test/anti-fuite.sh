#!/bin/sh
# test/anti-fuite.sh — ce dépôt est PUBLIC.
# Repris de github.com/peterhost/dotlib (test/anti-fuite.sh), avec trois
# adaptations propres à ce dépôt, signalées par « ADAPTÉ » ci-dessous. Rien de personnel ne doit y entrer : ni adresse IP, ni
# adresse MAC, ni courriel, ni chemin de home nommé, ni nom de machine réelle — y compris dans un
# test, un exemple ou un commentaire, et y compris dans l'identité des commits.
#
# DEUX ÉTAGES, et c'est volontaire :
#   1. des MOTIFS génériques, ici, qui ne nomment personne. Ils voyagent avec le dépôt et protègent
#      n'importe quel contributeur.
#   2. une liste de LITTÉRAUX interdits (les vrais noms de machines, de comptes, de réseaux), tenue
#      HORS du dépôt et jamais suivie par git. Par défaut ~/.dotlib/local/mots-interdits, sinon
#      $DOTLIB_MOTS_INTERDITS. Sur nos machines elle existe, donc le test est strict ; sur un clone
#      public elle est absente, et le test reste utile sans rien révéler.
# Écrire la liste des vrais noms DANS le dépôt publierait exactement ce qu'on veut protéger. C'est
# l'erreur à ne pas commettre, et elle a déjà été commise ailleurs.
#
# Format de la liste : un littéral par ligne (insensible à la casse). Une ligne « mot ! chemin… »
# autorise ce mot dans les chemins nommés — cas réel : un hôte porte parfois le nom de sa
# distribution, qu'il faut bien citer là où les systèmes sont énumérés. Lignes vides et # ignorés.
# Un mot ne doit figurer qu'une fois : une seconde ligne sans exception annulerait la première.
#
# Lancé par « make check » (via test/), par le crochet pre-push, et à la main avant toute poussée.

# Avec des ARGUMENTS, on vérifie ces fichiers-là au lieu des fichiers suivis. C'est le
# mode à employer avant de donner un fichier à un autre projet : ce qui sort d'ici n'est
# plus protégé par notre crochet, et un chemin de home nommé s'y glisse vite (déjà vu :
# deux tests livrés avec le chemin du dépôt en valeur par défaut).
#     sh test/anti-fuite.sh fichier…
cd "$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "anti-fuite : pas dans un dépôt git"; exit 2; }
NB=0
signaler() { NB=$((NB + 1)); printf '  ✗ %s\n' "$1"; }
if [ $# -gt 0 ]; then
  LISTE_ARGS=$*
  suivis() { for f in $LISTE_ARGS; do [ -e "$f" ] && printf '%s\n' "$f"; done; }
  echo "anti-fuite : $(suivis | wc -l | tr -d ' ') fichier(s) donné(s) en argument"
else
  suivis() { git ls-files; }
  echo "anti-fuite : $(suivis | wc -l | tr -d ' ') fichier(s) suivi(s)"
fi

# ---------------------------------------------------------------- 1. motifs génériques
# Adresses IPv4, sauf celles réservées à la documentation et aux exemples (RFC 5737, RFC 5735).
trouve=$(suivis | xargs grep -nE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' 2>/dev/null \
  | grep -vE '\b(0\.0\.0\.0|127\.0\.0\.1|255\.255\.255\.255|192\.0\.2\.[0-9]+|198\.51\.100\.[0-9]+|203\.0\.113\.[0-9]+|1\.2\.3\.4)\b')
[ -n "$trouve" ] && signaler "adresse IP :
$trouve"

# Adresses MAC.
trouve=$(suivis | xargs grep -nE '\b([0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2}\b' 2>/dev/null)
[ -n "$trouve" ] && signaler "adresse MAC :
$trouve"

# Courriels, sauf la forme noreply de GitHub (la seule admise dans ce dépôt).
# ADAPTÉ : deux exclusions supplémentaires, justifiées.
#   - « git@github.com:… » est une URL ssh, pas une adresse de courriel ;
#   - colors/, syntax/, autoload/plug.vim et spell/ sont repris tels quels de
#     leurs auteurs : leur en-tête porte LEUR adresse, la retirer serait leur
#     retirer leur signature. Aucun de ces fichiers n'est écrit ici.
trouve=$(suivis | grep -vE '^(colors/|syntax/|spell/|autoload/plug\.vim$)' \
  | xargs grep -nE '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' 2>/dev/null \
  | grep -vE '@users\.noreply\.github\.com|@example\.(com|org)|git@github\.com')
[ -n "$trouve" ] && signaler "adresse de courriel :
$trouve"

# Chemins de home nommés : /Users/<nom>, /home/<nom>, /var/services/homes/<nom> (Synology).
# $HOME, ~ et les exemples génériques (<nom>, USER, utilisateur) restent permis.
trouve=$(suivis | xargs grep -nE '(/Users/|/home/|/var/services/homes/)[a-z][a-z0-9._-]+' 2>/dev/null \
  | grep -vE '(/Users/|/home/|/var/services/homes/)(\$|<|\{|USER|utilisateur|nom|moi|test)')
[ -n "$trouve" ] && signaler "chemin de home nommé :
$trouve"

# Noms d'hôte d'un réseau local ou d'une machine désignée. « example.* » et « exemple.* » sont
# réservés à la documentation (RFC 2606) : ce sont justement les noms à employer dans un exemple.
# ADAPTÉ : ici « .local » est surtout un suffixe de fichier de configuration
# (vimrc.local, gvimrc.local, theme.local…), pas un nom d'hôte. Ces formes sont
# écartées ; un vrai nom de machine reste attrapé par la liste privée. Une VARIABLE suivie de
# « .local » (« $nom.local », construction de chemin) n'est pas davantage un nom d'hôte.
trouve=$(suivis | xargs grep -nE '\b[a-z0-9-]+\.(local|lan|home|internal|invalid)\b' 2>/dev/null \
  | grep -vE '\b(example|exemple|test|hote|host|machine)\.(local|lan|home|internal|invalid)\b' \
  | grep -vE '\b(g?vimrc|rc|conf|theme|config)\.local\b' \
  | grep -vE '\$\{?[A-Za-z_][A-Za-z0-9_]*\}?\.local\b')
[ -n "$trouve" ] && signaler "nom d'hôte local :
$trouve"

# ---------------------------------------------------------------- 2. identité des commits
# Une adresse dans les métadonnées d'un commit est publique pour toujours : réécrire l'historique
# après coup ne la retire ni des clones ni des caches de GitHub.
# ADAPTÉ : ici, c'est un AVERTISSEMENT et non une erreur. Ces adresses sont
# déjà publiques dans 356 commits : faire échouer le test à chaque exécution
# n'y changerait rien et le rendrait inutile. ANTIFUITE_STRICT=1 le rend
# bloquant, pour un dépôt qui démarre propre.
trouve=
[ $# -gt 0 ] || trouve=$(git log --format='%ae%n%ce' | sort -u | grep -vE '@users\.noreply\.github\.com$')
if [ -n "$trouve" ]; then
  if [ -n "${ANTIFUITE_STRICT:-}" ]; then
    signaler "adresse non-noreply dans l'historique (auteur ou validateur) :
$trouve"
  else
    printf '  ! adresse non-noreply dans l'"'"'historique (déjà publiée, non réparable après coup) :\n%s\n' "$trouve"
    printf '    pour n'"'"'en plus ajouter : git config user.email <identifiant>@users.noreply.github.com\n'
  fi
fi

# ---------------------------------------------------------------- 3. littéraux interdits (hors dépôt)
# ADAPTÉ : liste propre à ce dépôt (local/ n'est jamais suivi par git), ou
# celle partagée par dotlib si elle est là.
LISTE=${DOTVIM_MOTS_INTERDITS:-}
[ -n "$LISTE" ] || for essai in "$HOME/.vim/local/mots-interdits" "$HOME/.dotlib/local/mots-interdits"; do
  [ -r "$essai" ] && { LISTE=$essai; break; }
done
LISTE=${LISTE:-$HOME/.vim/local/mots-interdits}
if [ -r "$LISTE" ]; then
  echo "anti-fuite : liste privée lue ($LISTE, jamais suivie par git)"
  while IFS= read -r ligne; do
    case "$ligne" in ''|'#'*) continue ;; esac
    mot=${ligne%%!*}; mot=$(printf '%s' "$mot" | tr -d ' \t')
    [ -n "$mot" ] || continue
    exceptions=""
    case "$ligne" in *!*) exceptions=${ligne#*!} ;; esac
    t=$(suivis | xargs grep -niF -- "$mot" 2>/dev/null)
    # ADAPTÉ : une exception vaut pour un PRÉFIXE de chemin, fichier ou dossier
    # (« spell/ » couvre tout le dictionnaire). L'original exigeait un chemin de
    # fichier exact, si bien qu'une exception de dossier ne faisait rien.
    for ex in $exceptions; do
      [ -n "$t" ] || break
      motif=$(printf '%s' "$ex" | sed 's/[][\\.*^$]/\\&/g')
      t=$(printf '%s\n' "$t" | grep -v "^$motif")
    done
    if [ -n "$t" ]; then signaler "mot interdit « $mot » :
$t"; fi
  done < "$LISTE"
else
  echo "anti-fuite : pas de liste privée ici ($LISTE) — seuls les motifs génériques s'appliquent."
fi

# ---------------------------------------------------------------- verdict
if [ "$NB" -gt 0 ]; then
  printf '\nanti-fuite : %d problème(s). RIEN NE DOIT ÊTRE POUSSÉ EN L ÉTAT.\n' "$NB"
  exit 1
fi
echo "anti-fuite : rien à signaler ✓"
