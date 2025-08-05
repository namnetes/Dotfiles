#!/usr/bin/env bash

############################################################################
## Jupyter Lab : Environnement bac à sable                                #
############################################################################
JUPYTER_DIR="$HOME/Workspace/sandbox"

# Python3 est installé
if command -v python3 &> /dev/null; then
  # Pour activer un environnement Python
  function ve() {
    # Si le nombre d'arguments est égal à 0
    if [ $# -eq 0 ]; then
      if [ -d "./.venv" ]; then
        source ./.venv/bin/activate
      else
        echo "Aucun répertoire .venv trouvé ici dans $PWD !"
      fi
    # Si le nombre d'arguments est supérieur à 0
    else
      cd "$1" || return # Changer de répertoire et retourner en cas d'échec
      source "$1/.venv/bin/activate"
    fi
  }
fi

if [ -d "$JUPYTER_DIR" ]; then
  export SANDBOX_HOME="$JUPYTER_DIR"
  if grep -qE "(Microsoft|WSL)" /proc/version; then
    export BROWSER="/mnt/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe"
  fi

  function jl() {
    ve "$SANDBOX_HOME"
    jupyter lab
    deactivate
    cd "$HOME" || return # Retourner au répertoire personnel et retourner en cas d'échec
  }

  function ipy() {
    ve "$SANDBOX_HOME"
    ipython
    deactivate
    cd "$HOME" || return # Retourner au répertoire personnel et retourner en cas d'échec
  }
fi


############################################################################
## NodeJS                                                                 #
############################################################################
# Définit le répertoire où NVM (Node Version Manager) sera installé
export NVM_DIR="$HOME/.nvm"

# Vérifie si le script nvm.sh existe dans le répertoire NVM_DIR
# S'il existe, le charge (ceci charge NVM)
if [ -s "$NVM_DIR/nvm.sh" ]; then
  source "$NVM_DIR/nvm.sh"
  
  # Vérifie si le script de complétion bash pour NVM existe dans le répertoire NVM_DIR
  # S'il existe, le charge (ceci charge la complétion bash de NVM)
  if [ -s "$NVM_DIR/bash_completion" ]; then
    source "$NVM_DIR/bash_completion"
  fi
fi


############################################################################
## Configuration de Helix Editor                                           #
############################################################################
if command -v hx >/dev/null 2>&1; then
    export EDITOR="hx"
    export VISUAL="hx"
fi


############################################################################
## Configuration de Neovim                                                #
############################################################################
# Définit le répertoire d'installation potentiel de Neovim
export NVIM_HOME=/usr/local/nvim

# Vérifie si le répertoire des binaires de Neovim existe
if [ -d "$NVIM_HOME/bin" ]; then
  # S'il existe, l'ajoute au PATH et définit Neovim comme éditeur par défaut
  PATH="$NVIM_HOME/bin:$PATH"
  export EDITOR=nvim
else
  # Sinon, définit nano comme éditeur par défaut
  export EDITOR=nano
fi


############################################################################
## Starship Shell                                                         #
############################################################################
STARSHIP_VERSION=$(starship --version 2>/dev/null | head -n 1)

if [[ "$STARSHIP_VERSION" =~ ^starship\ [0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  eval "$(starship init bash)"
fi


############################################################################
## Gestionnaire de paquets Python UV                                      #
############################################################################
# Récupère la version de UV, supprime les erreurs et ne prend que le dernier champ (le numéro de version)
UV_VERSION=$("$HOME/.local/bin/uv" --version 2>/dev/null | awk '{print $NF}')

# Vérifie si UV_VERSION n'est pas vide, indiquant que UV est probablement installé
if [[ -n "$UV_VERSION" ]]; then
  # Si UV est installé, source son script d'environnement
  source "$HOME/.local/bin/env"
fi


############################################################################
## Configuration de Groovy + SDKMAN                                       #
############################################################################
export SDKMAN_DIR="$HOME/.sdkman"

# Vérifie si le script sdkman-init.sh existe dans le répertoire SDKMAN_DIR/bin
# S'il existe, le source (ceci initialise SDKMAN)
if [ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]; then
  source "$SDKMAN_DIR/bin/sdkman-init.sh"
fi

export GTK_MODULES=canberra-gtk-module


############################################################################
## Supprimer les chemins en double dans la variable PATH.                  #
############################################################################
clean_path() {
  local old_IFS="$IFS"
  IFS=':'
  local unique_paths=()
  local path

  for path in $PATH; do
    if [[ ! " ${unique_paths[@]} " =~ " $path " ]]; then
      unique_paths+=("$path")
    fi
  done

  IFS=':'
  PATH="${unique_paths[*]}"
  IFS="$old_IFS"
}


###############################################################################
# Pour afficher le PATH une ligne par chemin                                  #
###############################################################################
function path() {
  echo "$PATH" | tr ':' '\n' | nl
}


###############################################################################
# Pour afficher LD_LIBRARY_PATH une ligne par chemin                          #
###############################################################################
function ldpath() {
  echo "$LD_LIBRARY_PATH" | tr ':' '\n' | nl
}


###############################################################################
# Afficher les règles                                                         #
###############################################################################
function rule() {
  if [ $# -eq 0 ]; then
    local offset=0 # Pas de paramètres, pas d'espace avant la règle
  else
    local offset=$1 # Le premier paramètre est le décalage en espaces
  fi

  # Déterminer la largeur du terminal
  local width
  width=$(tput cols)

  # Créer une chaîne remplie de '0' avec la longueur de la largeur du terminal
  local rule
  rule=$(printf "%*s" "$width" "" | tr ' ' '0')

  # Remplacer chaque 0 par la séquence 123456789
  rule=$(echo "$rule" | sed 's/0/123456789 /g')

  # Ajouter des espaces de décalage avant d'afficher la règle
  local spaces
  spaces=$(printf "%${offset}s" "")
  echo "${spaces}${rule:0:$((width - offset))}"
}


###############################################################################
# Intégration de la fonction rule avec la commande head, où rule est         #
# invoquée avant head.                                                        #
###############################################################################
function rh() {
  # Appelle la fonction rule pour afficher la règle dynamique
  rule

  # Appelle la commande head avec tous les arguments fournis
  head "$@"
}


###############################################################################
# Intégration de la fonction rule avec la commande head, où rule est         #
# invoquée avant head, et précédant l'affichage de la longueur de ligne.     #
###############################################################################
function rhc() {
  # Appelle la fonction rule pour afficher la règle dynamique
  rule 5

  # Utilise head pour obtenir les n premières lignes
  head_lines=$(head "$@")

  # Traite chaque ligne pour y ajouter sa longueur (toujours 4 caractères)
  while IFS= read -r line; do
    # Calcule la longueur de la ligne
    line_length=$(echo -n "$line" | wc -c)

    # Formate line_length pour toujours avoir 4 caractères avec des espaces de début
    line_length=$(printf "%4s" "$line_length")

    # Affiche la sortie formatée
    printf "%s %s\n" "$line_length" "$line"
  done <<<"$head_lines"
}


###############################################################################
# Intégration de la fonction rule avec la commande tail, où rule est         #
# invoquée avant tail.                                                        #
###############################################################################
function th() {
  # Appelle la fonction rule pour afficher la règle dynamique
  rule

  # Appelle la commande tail avec tous les arguments fournis
  tail "$@"
}


###############################################################################
# Obtient le tag de la dernière version d'images Docker pour tous les noms    #
# fournis                                                                     #
###############################################################################
dlvi() {
  # Vérifier si curl et jq sont installés
  if ! command -v curl &>/dev/null; then
    echo "Erreur : curl n'est pas installé."
    return 1
  fi

  if ! command -v jq &>/dev/null; then
    echo "Erreur : jq n'est pas installé."
    return 1
  fi

  # Vérifier que des noms d'images sont fournis
  if [ "$#" -eq 0 ]; then
    echo "Utilisation : dlvi <nom_image1> [<nom_image2> ...]"
    echo "Exemple : dlvi elasticsearch logstash kibana"
    return 1
  fi

  # Traiter chaque nom d'image fourni en argument
  for image in "$@"; do
    echo "Récupération de la dernière version de l'image Docker : $image"

    # Obtenir les tags pour l'image spécifiée depuis Docker Hub
    response=$(curl -s "https://registry.hub.docker.com/v2/repositories/library/${image}/tags/?page_size=100")

    # Vérifiez si la requête a réussi
    if [ "$?" -ne 0 ]; then
      echo "Échec de la récupération des tags pour l'image : $image"
      continue
    fi

    # Extraire et trier les tags
    tags=$(echo "$response" | jq -r '.results[].name' | sort -V)

    # Vérifiez si des tags ont été trouvés
    if [ -z "$tags" ]; then
      echo "Aucun tag trouvé pour l'image : $image"
      continue
    fi

    # Récupérer le dernier tag
    latest_version=$(echo "$tags" | tail -n 1)

    echo "La dernière version de $image est : $latest_version"
  done
}


###############################################################################
# Alias pour gnome-text-editor                                                #
###############################################################################
ge() {
  gnome-text-editor "$@" &
}


###############################################################################
# Surveiller certains de ses propres projets Git                             #
###############################################################################
gsp() {
  # Sauvegarder le répertoire actuel
  local current_dir="$(pwd)"

  # Définir les projets et leurs chemins
  projects=(
    "$HOME/alm-dotfiles"
    "$HOME/alm-tools"
    "$HOME/alm-technook"
  )

  # Codes de couleur ANSI
  GREEN="\e[32m"
  RED="\e[31m"
  BLUE="\e[34m"
  RESET="\e[0m"

  # Icônes pour la police Firacode avec couleurs
  icon_clean="${GREEN}✔${RESET}"    # Vert pour un dépôt propre
  icon_dirty="${RED}✖${RESET}"      # Rouge pour un dépôt modifié
  icon_not_git="${BLUE}🚫${RESET}"  # Bleu pour un dépôt non-Git

  # Fonction pour vérifier l'état de chaque projet
  for project in "${projects[@]}"; do
    if [ -d "$project/.git" ]; then
      cd "$project" || continue # Changer de répertoire et continuer en cas d'échec

      # git status --porcelain
      #  - affiche une sortie simplifiée adaptée aux scripts.
      # grep -qE '^[ MADRCU?]'
      #  - détecte les lignes indiquant des fichiers modifiés ou non suivis.
      if git status --porcelain | grep -qE '^[ MADRCU?]'; then
          status="$icon_dirty Modifié"
      else
          status="$icon_clean Propre"
      fi

      echo -e "$(basename "$project"):\t$status"
    else
      echo -e "$(basename "$project"):\t🚫 Pas un dépôt Git"
    fi
  done

  # Restaurer le répertoire original
  cd "$current_dir" || return # Restaurer le répertoire et retourner en cas d'échec
}


###############################################################################
# Afficher le résumé des informations de Gnome User Share WebDAV              #
###############################################################################
gus() {
  # Vérifier si le service est en cours d'exécution
  STATUS=$(systemctl --user is-active gnome-user-share-webdav.service)

  # Obtenir la sortie complète de l'état
  INFO=$(systemctl --user status gnome-user-share-webdav.service)

  # Extraire le PID principal
  PID=$(echo "$INFO" | grep -oP 'Main PID: \K[0-9]+')

  # Extraire l'utilisation de la mémoire
  MEMORY=$(echo "$INFO" | grep -oP 'Memory:\s+\K.*')

  # Extraire le port d'écoute Apache (rechercher l'argument "Listen")
  PORT=$(echo "$INFO" | grep -oP 'Listen \K[0-9]+' | head -n 1)

  echo "🔍 Gnome User Share WebDAV - Résumé des infos"
  echo "---------------------------------------------"
  echo "✅ Statut         : $STATUS"
  echo "🆔 PID principal  : $PID"
  echo "📦 Utilisation mémoire : $MEMORY"
  echo "🌐 Écoute sur     : Port $PORT"
}

###############################################################################
# Renommer en lot les fichiers image dans le répertoire courant.             #
###############################################################################
renimg() {
  python3 "$HOME/.oh-my-bash/custom/functions/rename_images.py" "$@"
}


###############################################################################
# Fonction csv_checker                                                        #
###############################################################################
csvc() {
  python3 "$HOME/.oh-my-bash/custom/functions/csv_checker.py" "$@"
}
