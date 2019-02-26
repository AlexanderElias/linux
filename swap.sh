#!/bin/bash
#
#	Author: Alexander Elias
#	Description: change swappiness
#

# Output current swap value
cat /proc/sys/vm/swappiness

# Append the following text to the following file
echo 'vm.swappiness = 10' >> /etc/sysctl.conf

# Change swappiness while system running
sysctl vm.swappiness=10

# Swap off
swapoff -a

# Swap on
swapon -a
