# Add your own custom alias in the custom/aliases directory. Aliases placed
# here will override ones with the same name in the main alias directory.
#
# Usage:
#
# 1. use the exact naming schema like '<my_aliases>.aliases.sh' where the
#    filename needs to end with .aliases.sh (just <my_aliases>.sh does not
#    work)
# 2. add the leading part of that filename ('<my_aliases>' in this example) to
#    the 'aliases' array in your ~/.bashrc

## fzf integration
if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --bash)"
  alias fnv="fzf --preview 'batcat --style=numbers --color=always {}' | xargs -n 1 nvim"
fi

## zoxide integration
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init bash)"
  alias cd='z'
fi

## dotfiles only
alias lh='shopt -s nullglob dotglob; hidden=(.[^.]*); \
[[ ${#hidden[@]} -gt 0 ]] && ls -dl .[^.]* || echo "No hidden file"'

## make mount command output pretty and human readable format
alias mount='mount | column -t'

## handy aliases
alias f='free -t'
alias h='history | fzf'
alias j='jobs -l'
alias fd='fdfind'

## make mount command output pretty and human readable format
alias mount='mount | column -t'

## show open ports
## '-t' affiche les connexions TCP
## '-u' affiche les connaxions UDP
## '-l' affiche uniquement les sockets d'écoute
## '-n' affiche les IP et les ports sous forme numérique
## '-p' affiche le nom du processus et son PID
alias p='ss -tulnp'

## update ubuntu system
alias u='sudo apt update && sudo apt upgrade && pkill firefox && sudo snap refresh'

## xclip
if grep -qE "(Microsoft|WSL)" /proc/version; then
  unset WINHOME
  export WINHOME="/mnt/c/Users/galan"
  alias xclip='xclip -sel clip'
else
  alias xclip='xclip -selection clipboard'
fi

## display fucntion defined in the custom folder of .oh-my-bash
if [ -f "$HOME//.oh-my-bash/custom/functions/own.functions.sh" ]; then
  alias func="grep -E '^\s*[a-zA-Z0-9_]+\s*\(\)\s*\{' ~/.oh-my-bash/custom/functions/own.functions.sh | sed s'/{//g'"
fi

## own_script KVM
if [ -f "$HOME/Scripts/csv_checker/csv_checker.py" ]; then
  alias csvc="python $HOME/Scripts/csv_checker/csv_checker.py"
fi

if [ -f "$HOME/Scripts/kvm/vm-clone.sh" ]; then
  alias vclone='bash $HOME/Scripts/kvm/vm-clone.sh'
fi

if [ -f "$HOME/Scripts/kvm/vm-get-ip.sh" ]; then
  alias vip='bash $HOME/Scripts/kvm/vm-get-ip.sh'
fi

if [ -f "$HOME/Scripts/kvm/vm-list.sh" ]; then
  alias vlist='bash $HOME/Scripts/kvm/vm-list.sh'
fi

if [ -f "$HOME/Scripts/kvm/vm-set-hostname.sh" ]; then
  alias vhost='bash $HOME/Scripts/kvm/vm-set-hostname.sh'
fi

if [ -f "$HOME/Scripts/kvm/vm-update-sshconfig.sh" ]; then
  alias vssh='bash $HOME/Scripts/kvm/vm-update-sshconfig.sh'
fi

