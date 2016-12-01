#!/bin/bash

internalMonitor="DP-0"
primaryExternalMonitor="DP-2"
secondaryExternalMonitor="HDMI-0"

xrandr | grep -q "$primaryExternalMonitor disconnected"
state=$?

if [[ $state == "0" ]]; then
	xrandr --output $internalMonitor --auto --pos 0x0
	xrandr --output $primaryExternalMonitor --auto --right-of $internalMonitor
	xrandr --output $secondaryExternalMonitor --auto --right-of $primaryExternalMonitor
elif [[ $state == "1" ]]; then
	xrandr --output $internalMonitor --off
	xrandr --output $primaryExternalMonitor --auto --pos 0x0
	xrandr --output $secondaryExternalMonitor --auto --right-of $primaryExternalMonitor
fi
