#!/usr/bin/bash

# Date
date=$(date "+%Y/%m/%d")

# Time
time=$(date "+%H:%M")

# Battery
#battery_charge=$(upower --show-info $(upower --enumerate | grep 'BAT') | egrep "percentage" | awk '{print $2}')
#battery_status=$(upower --show-info $(upower --enumerate | grep 'BAT') | egrep "state" | awk '{print $2}')
#
#if [ "${battery_status}" = "discharging" ]; then
#    battery_pluggedin='⚠'
#else
    battery_pluggedin='⚡'
#fi

# Network
network=$(ip route get 1.1.1.1 | grep -Po '(?<=dev\s)\w+' | cut -f1 -d ' ')
interface=$(dmesg | grep $network | grep renamed | awk 'NF>1{print $NF}')
ping=$(ping -c 1 www.google.com | tail -1| awk '{print $4}' | cut -d '/' -f 2 | cut -d '.' -f 1)

if ! [ $network ]; then
   network_status="⛔"
else
   network_status="⇆"
fi

echo "$network_status $interface ($ping ms) | $date 🕘 $time | "
