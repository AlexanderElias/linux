#!/bin/bash

# Output current swap value
cat /proc/sys/vm/swappiness

# Append the following text to the following file
nano /etc/sysctl.conf
vm.swappiness = 10

# Change swappiness while system running
sysctl vm.swappiness=10

# Swap off
swapoff -a

# Swap on
swapon -a
