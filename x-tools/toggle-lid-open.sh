#!/bin/bash

internalMonitor="DP-0"
primaryExternalMonitor="DP-2"
secondaryExternalMonitor="HDMI-0"

xrandr --output $internalMonitor --auto --pos 0x0
xrandr --output $primaryExternalMonitor --auto --right-of $internalMonitor
xrandr --output $secondaryExternalMonitor --auto --right-of $primaryExternalMonitor
