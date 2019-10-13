#!/bin/bash

NAME="Alexander Elias"
EMAIL="alex.steven.elias@gmail.com"

# install pacman apps
pacman -S \
steam aws-cli \
inkscape gimp \
chromium firefox \
atom nodejs npm vim \
ttf-fira-code ttf-fira-mono ttf-fira-sans ttf-dejavu

# need to downgrade from sudo

# setup git
git config --global user.name "$NAME"
git config --global user.email "$EMAIL"

# create ssh
mkdir ~/.ssh

if [ ! -f ~/.ssh/id_rsa ]; then
	ssh-keygen -t rsa -b 4096 -C "$EMAIL";
fi

# install yay
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -r -f yay

# install yay apps
yay -S \
spotify \
enpass-bin \
brave-bin \
hyper

# large console font
# might want to add consolefont to HOOKS
# echo 'FONT=latarcyrheb-sun32' >> /etc/vconsole.conf


