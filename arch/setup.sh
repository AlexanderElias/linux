#!/bin/bash

NAME="Alexander Elias"
EMAIL="alex.steven.elias@gmail.com"

git config --global user.name $NAME
git config --global user.email $EMAIL

if [ ! -f ~/.ssh/id_rsa ]; then
	ssh-keygen -t rsa -b 4096 -C $EMAIL;
fi

# sudo wget "https://www.archlinux.org/mirrorlist/?country=US&protocol=http&protocol=https&ip_version=4&ip_version=6" -O /etc/pacman.d/mirrorlist
# sudo sed -i 's/#Server/Server/g' /etc/pacman.d/mirrorlist

sudo sed -i 's/#[multilib]/[multilib]' /etc/pacman.conf
sudo sed -i 's/#Include = \/etc\/pacman\.d\/mirrorlist/Include = \/etc\/pacman.d\/mirrorlist' /etc/pacman.conf

# always apps
sudo pacman -S chromium firefox atom nodejs npm vim aws-cli steam

# plasma apps
sudo pacman -S konsole kate dolphin

yay -S spotify enpass-bin brave-bin hyper-bin
