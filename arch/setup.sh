#!/bin/bash

NAME="Alexander Elias"
EMAIL="alex.steven.elias@gmail.com"

git config --global user.name $NAME
git config --global user.email $EMAIL

if [ ! -f ~/.ssh/id_rsa ]; then
	ssh-keygen -t rsa -b 4096 -C $EMAIL;
fi

# large console font
# might want to add consolefont to HOOKS
echo 'FONT=latarcyrheb-sun32' >> /etc/vconsole.conf

sed -i 's/#[multilib]/[multilib]' /etc/pacman.conf
sed -i 's/#Include = \/etc\/pacman\.d\/mirrorlist/Include = \/etc\/pacman.d\/mirrorlist' /etc/pacman.conf

# yay
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -r -f yay

# apps
pacman -S \
chromium firefox \
atom nodejs npm vim \
ttf-fira-code ttf-fira-mono ttf-fira-sans \
steam aws-cli

yay -S spotify enpass-bin brave-bin hyper-bin

# plasma apps
# sudo pacman -S konsole kate dolphin
