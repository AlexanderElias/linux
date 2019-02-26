#!/bin/bash
#
#	Author: Alexander Elias
#	Description: Install Node LTS
#	Usage: setupNode "v4.4.7"
#

function setupNode () {
	nodeVersion=$1
	url="http://nodejs.org/dist"
	architecture=$(uname -m)

	if [ $architecture = arm64 ] || [ $architecture = aarch64 ]; then
		nodeTar="node-${nodeVersion}-linux-arm64.tar.gz"

	elif [ $architecture = armv6l ]; then
		nodeTar="node-${nodeVersion}-linux-armv6l.tar.gz"

	elif [ $architecture = armv7l ]; then
		nodeTar="node-${nodeVersion}-linux-armv7l.tar.gz"

	elif [ $architecture = x86_64 ]; then
		nodeTar="node-${nodeVersion}-linux-x64.tar.gz"

	else
		nodeTar="node-${nodeVersion}-linux-x86.tar.gz"
	fi

	echo "Downloading: ${nodeTar}..."
	url="${url}/${nodeVersion}/${nodeTar}"

	cd /tmp && curl -O $url

	echo "Installing: ${nodeTar}..."

	cd /usr/local && tar --strip-components 1 -xzf /tmp/${nodeTar}

	rm /tmp/${nodeTar}

	echo "Finished installing Node"
}
