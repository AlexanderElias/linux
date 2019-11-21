#!/usr/bin/bash

gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'
gsettings set org.gnome.desktop.interface gtk-theme 'Materia-dark'
gsettings set org.gnome.desktop.interface font-name 'Fira Sans 12'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
gsettings set org.gnome.desktop.interface monospace-font-name 'Fira Code 12'

cat >.config/gtk-3.0/settings.ini <<EOL
[Settings]
gtk-font-name=Fira Sans 12
gtk-theme-name=Materia-dark
gtk-cursor-theme-name=Adwaita
gtk-icon-theme-name=Papirus-Dark
gtk-application-prefer-dark-theme=1
EOL

# Link
#ln -s ~/.config/gtk-3.0/settings.ini /etc/gtk-3.0/settings.ini

