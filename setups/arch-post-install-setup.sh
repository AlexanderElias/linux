#!/bin/bash

# always apps
sudo pacman -S chromium firefox atom nodejs npm vim aws-cli

# plasma apps
sudo pacman -S konsole kate dolphin

yay -S spotify enpass-bin brave-bin hyper-bin

git config --global user.name "Alexander Elias"
git config --global user.email "alex.steven.elias@gmail.com"

sudo wget "https://www.archlinux.org/mirrorlist/?country=US&protocol=https&ip_version=4&ip_version=6" -O /etc/pacman.d/mirrorlist

sudo sed -i 's/#Server/Server/g' /etc/pacman.d/mirrorlist

