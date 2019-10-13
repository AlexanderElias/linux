#!/usr/bin/env bash

pacman -S gnome gnome-tweaks chrome-gnome-shell seahorse

systemctl enable gdm.service
systemctl start gdm.service
