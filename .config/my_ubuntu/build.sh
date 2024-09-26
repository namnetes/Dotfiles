#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user" 2>&1
  exit 1
fi

# Go to home of root
cd /root

# Reconfigure Locales
#dpkg-reconfigure locales

# Reconfigure local time 
#dpkg-reconfigure tzdata

# Update system
apt-get update && apt-get dist-upgrade -y

# remove unnecessary package
apt-get -y remove --purge screen
apt-get -y autoremove --purge

# Install all needed packages
apt-get install -y \
apt-transport-https \
autoconf \
automake \
binutils \
build-essential \
ccache \
ccls \
cifs-utils \
colordiff \
curl \
dbus-x11 \
dislocker \
dos2unix \
elfutils \
exuberant-ctags \
flex \
gawk \
gdb \
git \
gnome-shell-extensions \
graphviz \
htop \
imagemagick \
indent \
jq \
libaio1t64 \
libbz2-dev \
libcurl4-openssl-dev \
libexpat1-dev \
libpam0g \
libtool \
libxext6 libxrender1 libxtst6 \
lsb-release \
man \
neofetch \
nmap \
plocate \
software-properties-common \
sqlite3 sqlite3-doc \
sharutils \
stow \
strace \
sudo \
timeshift \
tmux \
tree \
unixodbc unixodbc-dev libsqliteodbc \
wget \
xclip \
zlib1g-dev

# Gnome tools
echo "Voulez-vous installer quelques utilitaires Gnome. ? (y/n)"
read answer
if [ "$answer" == "y" ]; then
  apt install -y \
  dconf-editor \
  gnome-tweaks \
  gnome-shell-extension-manager
fi

# VLC and Media codecs to play various kinds of media files
echo "Voulez-vous installer VLC et les codecs pour lire différents types de fichiers multimédias. ? (y/n)"
read answer
if [ "$answer" == "y" ]; then
  apt-get install -y \
  ubuntu-restricted-extras \
  vlc
fi

# X11 Forwarding dependencies
echo "Voulez-vous installer les dépendances X11 Forwarding ? (y/n)"
read answer
if [ "$answer" == "y" ]; then
  apt-get install -y \
  dbus-x11 \
  x11-apps \
  xvfb \
  xdm \
  xfonts-base \
  xfonts-100dpi \
  sxiv \
  twm \
  xterm
fi

# Install Python3
# to upgrade pip: python3 -m pip install --upgrade pip
# to create python environnement: python3 -m venv env 
echo "Voulez-vous installer Python3 ? (y/n)"
read answer
if [ "$answer" == "y" ]; then
  apt-get install -y \
  build-essential \
  libffi-dev \
  libssl-dev \
  python3 \
  python3-pip \
  python3-venv
fi

# Install and start SSH Server
echo "Voulez-vous installer le serveur SSH ? (y/n)"
read answer
if [ "$answer" == "y" ]; then
  readonly PKG=openssh-server
  if dpkg --get-selections | grep -q "^$PKG[[:space:]]*install$" >/dev/null; then
    echo "OpenSSH Server is already Installed"
  else
    apt-get install -y $PKG
  # service ssh stop
  # service ssh start
  # echo -ne '\n'
  fi
fi

# Update locate db
updatedb

# Clean Up
apt-get -y autoremove --purge
apt-get -y clean autoclean
rm -rf /tmp/*

###############################################################################
# Exit here if WSL system                                                     #
###############################################################################
readonly STR=$(uname -a)
readonly SUB='^.*microsoft.*WSL.*'
if egrep -q "$SUB" <<< "$STR" ; then
  echo 'Microsoft WSL2 System.'
  echo 'End of installation process'
  exit
fi
