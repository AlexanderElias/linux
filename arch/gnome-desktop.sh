#!/usr/bin/env bash

pacman -S gnome gnome-tweaks

systemctl enable gdm.service
systemctl start gdm.service
