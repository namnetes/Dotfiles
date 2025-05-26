#!/bin/bash

## standard aliases
alias ls='ls --color'
alias ll='ls -ltr'
alias ld='ls -ltrd'
#alias lh='ls -dl .[^.]*'
alias lh='shopt -s nullglob dotglob; hidden=(.[^.]*); \
[[ ${#hidden[@]} -gt 0 ]] && ls -dl .[^.]* || echo "No hidden file"'

## colorize the grep command output for ease of use (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

## make mount command output pretty and human readable format
alias mount='mount | column -t'

## handy short cuts
alias c='clear'
alias f='free -t'
alias h='history'
alias j='jobs -l'
alias fd='fdfind'

## neovim/lazyvin
if [ -d "/usr/local/nvim" ]; then
  PATH=/usr/local/nvim/bin:$PATH
  alias nv=vim
  alias lv=nvim
  alias vim=nvim
fi

## fzf integration
if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --bash)"
  alias fnv="fzf --preview 'batcat --style=numbers --color=always {}' | xargs -n 1 nvim"
fi

## zoxide integration
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init bash)"
fi

## new set of commands
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

## show open ports
## '-t' affiche les conenions TCP
## '-u' affiche les conenxion UDP
## '-l' affiche uniquement les sockets d'écoute
## '-n' affiche les IP et les ports sous forme numérique
## '-p' affiche le nom du processus et son PID
alias ports='ss -tulnp'

## update ubuntu system
alias u='sudo apt update && sudo apt upgrade && sudo snap refresh'

## xclip
alias xclip='xclip -selection clipboard'

# own_script KVM
if [ -f "$HOME/Scripts/csv_checker/csv_checker.py" ]; then
  alias csvc="python $HOME/Scripts/csv_checker/csv_checker.py"
fi

# Check if the kvm scripts exist
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
