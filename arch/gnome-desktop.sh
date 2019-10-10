#!/usr/bin/env bash

pacman -S gnome gnome-tweaks chrome-gnome-shell

systemctl enable gdm.service
systemctl start gdm.service
