# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

############################################################################
## Macros                                                                  #
############################################################################

# To display the path one line per path
function path() {
	echo $PATH | tr ':' '\n' | nl
}

# To display ldpath one line per path
function ldpath() {
	echo $LD_LIBRARY_PATH | tr ':' '\n' | nl
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
		cd $1
		source $1/.venv/bin/activate
	fi
}

############################################################################
## Définir la variable d’environnement TERM à screen-256color, qui est     #
## la même valeur que celle définie dans la configuration de tmux.         #
## Cela permettra à tmux de prendre en charge les 256 couleurs dans les    #
## terminaux qui le prennent en charge.                                    #
############################################################################
export TERM=screen-256color

############################################################################
## WSL - Windows home directory of the current User                        #
############################################################################
unset WINHOME
if grep -qi Microsoft /proc/version; then
	export WINHOME=/mnt/c/Users/galan
	alias xclip='xclip -sel clip'
fi

############################################################################
## Jupyter Lab : Sandbox environment                                       #
############################################################################
export SANDBOX_HOME="$HOME/workspace/sandbox"
export BROWSER="/mnt/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe"
function jl() { # to start jupyter lab sandbox environnement
	ve $SANDBOX_HOME
	jupyter lab
	deactivate
	cd $HOME
}

function ipy() { # to start ipython in the sandbox environnement
	ve $SANDBOX_HOME
	ipython
	deactivate
	cd $HOME
}

############################################################################
## Git                                                                     #
############################################################################

## Git completion
if [ ! -f "$HOME/.git-completion.bash" ]; then
	echo "file does not exist"
	curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
fi

source ~/.git-completion.bash

############################################################################
## NodeJS                                                                  #
############################################################################
export NVM_DIR=$HOME/.nvm

# Loads NVM
if [ -s "$NVM_DIR/nvm.sh" ]; then
	# shellcheck source=/home/galan/.nvm
	source "$NVM_DIR/nvm.sh"
fi

# Loads NVM bash_completion
if [ -s "$NVM_DIR/bash_completion" ]; then
	# shellcheck source=/home/galan/.nvm
	source "$NVM_DIR/bash_completion"
fi

############################################################################
## My own nvim scripts                                                     #
############################################################################
export PATH=$PATH:~/.config/nvim/scripts

############################################################################
## Start tstartship shell                                                  #
############################################################################
eval "$(starship init bash)"

############################################################################
## Groovy                                                                  #
## This must be at the end of the file for SDKMAN to work !                #
############################################################################
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
export GTK_MODULES=canberra-gtk-module
