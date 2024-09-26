#!/bin/bash

# Désactiver l'extension Dash to Dock étendue (extend-height)
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false

# Définir la position du dock en bas de l'écran
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'

# Définir le mode de transparence du dock sur 'FIXED' (fixe)
gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode 'FIXED'

# Définir l'opacité du fond du dock à 0 (complètement transparent)
gsettings set org.gnome.shell.extensions.dash-to-dock background-opacity 0

# Minimiser en un clic
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'

#######################################################################################
# Energy saving
#######################################################################################

# Définir le mode d'énergie
# 'powerprofilesctl' sans paramètre liste les modes disponibles
powerprofilesctl set performance

# Affiche le % de batterie dans la System Tray
gsettings set org.gnome.desktop.interface show-battery-percentage true

# Eteind l'affichage de l'écran après x secondes. Ici 10 minutes.
gsettings set org.gnome.desktop.session idle-delay 600

#######################################################################################
# Night light & Time définition & color temperature
#######################################################################################
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
#gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-from 20.0
#gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-to 6.0
gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature 4000

#######################################################################################
# Auto hide du dock
#######################################################################################

# Désactiver l'option 'dock toujours visible' 
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false

# Activer le masquage automatique intelligent du dock
gsettings set org.gnome.shell.extensions.dash-to-dock intellihide false

# Activer le masquage automatique du dock en mode plein écran
gsettings set org.gnome.shell.extensions.dash-to-dock autohide-in-fullscreen false

# Activer le masquage automatique du dock
gsettings set org.gnome.shell.extensions.dash-to-dock autohide true

#######################################################################################
# Ne pas inclure dans le dock les volumes non montés
#######################################################################################
gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts false

#!/bin/bash

# Désactiver l'extension Dash to Dock étendue (extend-height)
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false

# Définir la position du dock en bas de l'écran
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'

# Définir le mode de transparence du dock sur 'FIXED' (fixe)
gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode 'FIXED'

# Définir l'opacité du fond du dock à 0 (complètement transparent)
gsettings set org.gnome.shell.extensions.dash-to-dock background-opacity 0

# Minimiser en un clic
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'

# Activer le coin actif
# (Toucher le coin supérieur gauche pour ouvrir la vue d'ensemble des activités)
gsettings set org.gnome.desktop.interface enable-hot-corners true

# Activer les bords de l'écran actif
# (Déplacer la fenêtre vers les bords haut, gauche ou droite pour redimensionner
#  la fenêtre)


#######################################################################################
# Energy saving
#######################################################################################

# Définir le mode d'énergie
# 'powerprofilesctl' sans paramètre liste les modes disponibles
powerprofilesctl set performance

# Affiche le % de batterie dans la System Tray
gsettings set org.gnome.desktop.interface show-battery-percentage true

# Eteind l'affichage de l'écran après x secondes. Ici 10 minutes.
gsettings set org.gnome.desktop.session idle-delay 600

#######################################################################################
# Night light & Time définition & color temperature
#######################################################################################
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
#gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-from 20.0
#gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-to 6.0
gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature 4000

#######################################################################################
# Auto hide du dock
#######################################################################################

# Désactiver l'option 'dock toujours visible' 
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false

# Activer le masquage automatique intelligent du dock
gsettings set org.gnome.shell.extensions.dash-to-dock intellihide false

# Activer le masquage automatique du dock en mode plein écran
gsettings set org.gnome.shell.extensions.dash-to-dock autohide-in-fullscreen false

# Activer le masquage automatique du dock
gsettings set org.gnome.shell.extensions.dash-to-dock autohide true

#######################################################################################
# Ne pas inclure dans le dock les volumes non montés
#######################################################################################
gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts false

#######################################################################################
# "Execute the 'gnome_terminal.py' script to configure GNOME Terminal to start in
# full-screen mode"
#######################################################################################
python3 gnome_terminal.py
