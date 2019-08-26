#!/bin/bash
#
#	Author: Alexander Elias
#	Description: fix npm global requiring sudo
#

N=~/.npm
NG=~/.npm/global

if [ ! -d $N ]; then
	mkdir ~/.npm;
fi

if [ ! -d $NG ]; then
	mkdir ~/.npm/global;
fi

npm config set prefix '~/.npm/global'

echo '' >> ~/.bashrc
echo '# npm global fix' >> ~/.bashrc
echo 'export PATH=~/.npm/global/bin:$PATH' >> ~/.bashrc

source ~/.bashrc

echo 'node-global done'
echo 'restart terminal'
