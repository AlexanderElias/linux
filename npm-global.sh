#!/bin/bash
#
#	Author: Alexander Elias
#	Description: fix npm global requiring sudo
#

mkdir ~/.npm/global

npm config set prefix '~/.npm/global'

printf '# npm global fix\nexport PATH=~/.npm/global/bin:$PATH' >> ~/.bashrc

source ~/.bashrc

echo 'node-global done'
echo 'restart terminal'
