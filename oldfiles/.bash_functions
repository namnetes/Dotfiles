###############################################################################
# Function to remove duplicate paths from PATH                                #
###############################################################################
clean_path() {
    # Split PATH into an array
    IFS=':' read -r -a path_array <<<"$PATH"

    # Use a temporary array to store unique paths while preserving order
    declare -a unique_paths=()

    # Use a associative array to track seen paths
    declare -A seen

    # Iterate over each path in path_array
    for dir in "${path_array[@]}"; do
        if [[ -n "$dir" && -z "${seen[$dir]}" ]]; then
            # If path is not empty and hasn't been seen before, add it to
            # unique_paths
            unique_paths+=("$dir")
            seen[$dir]=1
        fi
    done

    # Rebuild the PATH variable with unique paths in the original order
    export PATH=$(
        IFS=':'
        echo "${unique_paths[*]}"
    )
}

###############################################################################
# To display the path one line per path                                       #
###############################################################################
function path() {
    echo "$PATH" | tr ':' '\n' | nl
}

# To display ldpath one line per path
function ldpath() {
    echo "$LD_LIBRARY_PATH" | tr ':' '\n' | nl
}

# To activate a Python environment
function ve() {
    if [ $# -eq 0 ]; then
        if [ -d "./.venv" ]; then
            source ./.venv/bin/activate
        else
            echo "No .venv directory found here in $PWD!"
        fi
    else
        cd "$1"
        source "$1/.venv/bin/activate"
    fi
}

jl() {
    local sandbox_dir="$HOME/Workspaces/sandbox"
    
    if [ -d "$sandbox_dir" ]; then
        cd "$sandbox_dir" || return
        ve
        jupyter lab
    else
        echo "Le dossier $sandbox_dir n'existe pas."
    fi
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

    # Replace each 0 with the sequence +123456789
    rule=$(echo "$rule" | sed 's/0/123456789+/g')

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
        printf "%s %s\n" "$line_length" "$line"
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
  if ! command -v curl &> /dev/null; then
    echo "Error: curl is not installed."
    return 1
  fi

  if ! command -v jq &> /dev/null; then
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

