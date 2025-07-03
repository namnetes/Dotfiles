#!/usr/bin/env bash

############################################################################
## Jupyter Lab : Sandbox environment                                       #
############################################################################
JUPYTER_DIR="$HOME/Workspace/sandbox"

# Python3 installed
if command -v python3 &> /dev/null; then
  # To activate a Python environment
  function ve() {
    # Si le nombre d'arguments est égal à 0
    if [ $# -eq 0 ]; then
      if [ -d "./.venv" ]; then
        source ./.venv/bin/activate
      else
        echo "No .venv directory found here in $PWD!"
      fi
    # Si le nombre d'arguments est supérieur à 0
    else
      cd "$1"
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
    cd "$HOME" || return
  }

  function ipy() {
    ve "$SANDBOX_HOME"
    ipython
    deactivate
    cd "$HOME" || return
  }
fi


############################################################################
## NodeJS                                                                  #
############################################################################
# Define the directory where NVM (Node Version Manager) will be installed
export NVM_DIR="$HOME/.nvm"

# Check if the nvm.sh script exists in the NVM_DIR directory
# If it exists, load it (this loads NVM)
if [ -s "$NVM_DIR/nvm.sh" ]; then
  source "$NVM_DIR/nvm.sh"
fi

# Check if the bash_completion script for NVM exists in the NVM_DIR
# directory. If it exists, load it (this loads NVM bash completion)
if [ -s "$NVM_DIR/bash_completion" ]; then
  source "$NVM_DIR/bash_completion"
fi


############################################################################
## Neovim configuration                                                    #
############################################################################
export NVIM_HOME=/usr/local/nvim

if [ -d "$NVIM_HOME/bin" ]; then
  PATH="$NVIM_HOME/bin:$PATH"
  export EDITOR=nvim
else
  export EDITOR=nano
fi


############################################################################
## Starship Shell                                                          #
############################################################################
STARSHIP_VERSION=$(starship --version | head -n 1)

if [[ "$STARSHIP_VERSION" =~ ^starship\ [0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  eval "$(starship init bash)"
else
  echo "Starship n'est pas encore installé."
fi


############################################################################
## Python packager UV                                                      #
############################################################################
UV_VERSION=$("$HOME/.local/bin/uv" --version | awk '{print $NF}')

if [[ -n "$UV_VERSION" ]]; then
  source "$HOME/.local/bin/env"
else
  echo "UV n'est pas encore installé."
fi


############################################################################
## Groovy + SDKMAN Configuration                                          #
############################################################################
export SDKMAN_DIR="$HOME/.sdkman"

if [ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]; then
  source "$SDKMAN_DIR/bin/sdkman-init.sh"
fi

export GTK_MODULES=canberra-gtk-module

############################################################################
## Remove duplicate paths in the PATH variable.                            #
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
# To display the path one line per path                                       #
###############################################################################
function path() {
  echo "$PATH" | tr ':' '\n' | nl
}

###############################################################################
# To display ldpath one line per path                                         #
###############################################################################
function ldpath() {
  echo "$LD_LIBRARY_PATH" | tr ':' '\n' | nl
}

###############################################################################
# Display Rules                                                               #
###############################################################################
function rule() {
  if [ $# -eq 0 ]; then
    local offset=0 # No parameters, no space before the rule
  else
    local offset=$1 # The first parameter is the offset in spaces
  fi

  # Determine the width of the terminal
  local width
  width=$(tput cols)

  # Create a string filled with '0' with the length of the terminal width
  local rule
  rule=$(printf "%*s" $width "" | tr ' ' '0')

  # Replace each 0 with the sequence  123456789
  rule=$(echo "$rule" | sed 's/0/123456789 /g')

  # Add offset spaces before displaying the rule
  local spaces
  spaces=$(printf "%${offset}s" "")
  echo "${spaces}${rule:0:$((width - offset))}"
}


###############################################################################
# Integrating the rule function with the head command, where rule is invoked  #
# before head.                                                                #
###############################################################################
function rh() {
  # Call the rule function to display the dynamic rule
  rule

  # Call the head command with all the provided arguments
  head "$@"
}


###############################################################################
# Integrating the rule function with the head command, where rule is invoked  #
# before head, and preceding the display with the line length.                #
###############################################################################
function rhc() {
  # Call the rule function to display the dynamic rule
  rule 5

  # Use head to get the first n lines
  head_lines=$(head "$@")

  # Process each line to prepend its length (always 4 characters)
  while IFS= read -r line; do
    # Calculate the length of the line
    line_length=$(echo -n "$line" | wc -c)

    # Format line_length to always be 4 characters with leading spaces
    line_length=$(printf "%4s" "$line_length")

    # Print the formatted output
    printf "%s %sn" "$line_length" "$line"
  done <<<"$head_lines"
}


###############################################################################
# Integrating the rule function with the tail command, where rule is invoked  #
# before tail.                                                                #
###############################################################################
function th() {
  # Call the rule function to display the dynamic rule
  rule

  # Call the tail command with all the provided arguments
  tail "$@"
}


###############################################################################
# Get the tag of the latest Docker version Images for all provided names      #
###############################################################################
dlvi() {
  # Vérifier si curl et jq sont installés
  if ! command -v curl &>/dev/null; then
    echo "Error: curl is not installed."
    return 1
  fi

  if ! command -v jq &>/dev/null; then
    echo "Error: jq is not installed."
    return 1
  fi

  # Vérifier que des noms d'images sont fournis
  if [ "$#" -eq 0 ]; then
    echo "Usage: dlvi <image_name1> [<image_name2> ...]"
    echo "Example: dlvi elasticsearch logstash kibana"
    return 1
  fi

  # Traiter chaque nom d'image fourni en argument
  for image in "$@"; do
    echo "Fetching the latest version of Docker image: $image"

    # Obtenir les tags pour l'image spécifiée depuis Docker Hub
    response=$(curl -s "https://registry.hub.docker.com/v2/repositories/library/${image}/tags/?page_size=100")

    # Vérifiez si la requête a réussi
    if [ "$?" -ne 0 ]; then
      echo "Failed to fetch tags for image: $image"
      continue
    fi

    # Extraire et trier les tags
    tags=$(echo "$response" | jq -r '.results[].name' | sort -V)

    # Vérifiez si des tags ont été trouvés
    if [ -z "$tags" ]; then
      echo "No tags found for image: $image"
      continue
    fi

    # Récupérer le dernier tag
    latest_version=$(echo "$tags" | tail -n 1)

    echo "The latest version of $image is: $latest_version"
  done
}


###############################################################################
# gnome-text-editor alias                                                     #
###############################################################################
ge() {
  gnome-text-editor "$@" &
}


###############################################################################
# Monitor some own Git projects                                                #
###############################################################################
gsp() {
  # Save the current directory
  local current_dir="$(pwd)"

  # Define projects and their paths
  projects=(
    "$HOME/Dotfiles"
    "$HOME/Scripts"
    "$HOME/Technook"
  )

  # ANSI color codes
  GREEN="\e[32m"
  RED="\e[31m"
  BLUE="\e[34m"
  RESET="\e[0m"

  # Icons for Firacode font with colors
  icon_clean="${GREEN}✔${RESET}"   # Green for clean repo
  icon_dirty="${RED}✖${RESET}"      # Red for modified repo
  icon_not_git="${BLUE}🚫${RESET}"  # Blue for non-Git repo

  # Function to check the status of each project
  for project in "${projects[@]}"; do
    if [ -d "$project/.git" ]; then
      cd "$project" || continue

      # git status --porcelain 
      #  - affiche une sortie simplifiée adaptée aux scripts.
      # grep -qE '^[ MADRCU?]'
      #  - détecte les lignes indiquant des fichiers modifiés ou non suivis.
      if git status --porcelain | grep -qE '^[ MADRCU?]'; then
         status="$icon_dirty Modified"
      else
         status="$icon_clean Clean"
      fi

      echo -e "$(basename "$project"):\t$status"
    else
      echo -e "$(basename "$project"):\t🚫 Not a Git repository"
    fi
  done

  # Restore the original directory
  cd "$current_dir"
}


###############################################################################
# Display Gnome user Share WebDAV - Info Summary                              #
###############################################################################
gus() {
  # Check if the service is running
  STATUS=$(systemctl --user is-active gnome-user-share-webdav.service)

  # Get full status output
  INFO=$(systemctl --user status gnome-user-share-webdav.service)

  # Extract main PID
  PID=$(echo "$INFO" | grep -oP 'Main PID: \K[0-9]+')

  # Extract memory usage
  MEMORY=$(echo "$INFO" | grep -oP 'Memory:\s+\K.*')

  # Extract Apache listening port (look for "Listen" argument)
  PORT=$(echo "$INFO" | grep -oP 'Listen \K[0-9]+' | head -n 1)

  echo "🔍 Gnome User Share WebDAV - Info Summary"
  echo "-----------------------------------------"
  echo "✅ Status       : $STATUS"
  echo "🆔 Main PID     : $PID"
  echo "📦 Memory Usage : $MEMORY"
  echo "🌐 Listening on : Port $PORT"
}

###############################################################################
# Batch rename the image files in the current directory.                      #
###############################################################################
renimg() {
  python3 "$HOME/.oh-my-bash/custom/functions/rename_images.py" "$@"
}


