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

## neovim
alias nv='nvim'
alias vim='nv'

## handy short cuts
alias c='clear'
alias f='free -t'
alias h='history'
alias j='jobs -l'

## new set of commands
alias ..='cd ..'
alias ...='cd ../..'

## show open ports
## '-t' affiche les conenions TCP
## '-u' affiche les conenxion UDP
## '-l' affiche uniquement les sockets d'écoute
## '-n' affiche les IP et les ports sous forme numérique
## '-p' affiche le nom du processus et son PID
alias ports='ss -tulnp'

## update ubuntu system
alias u='sudo apt update && sudo apt upgrade'

## xclip
alias xclip='xclip -selection clipboard'
