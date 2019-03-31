#!/bin/bash
#
#	Author: Alexander Elias
#	Description: fix npm global requiring sudo
#

mkdir ~/.npm
mkdir ~/.npm/global

npm config set prefix '~/.npm/global'

echo '' >> ~/.bashrc
echo '# npm global fix' >> ~/.bashrc
echo 'export PATH=~/.npm/global/bin:$PATH' >> ~/.bashrc

source ~/.bashrc

echo 'node-global done'
echo 'restart terminal'
