#!/bin/bash
#
#	Author: Alexander Elias
#	Description: Check if sudo was providied
#

function sudoCheck () {
	if [[ $EUID -ne 0 ]]; then
		echo ""
		echo "Sudo Required"
		echo ""
		return 1
	else
		echo ""
		echo "Sudo Acquired"
		echo ""
		return 0
	fi
}
