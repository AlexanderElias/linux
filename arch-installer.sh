#!/usr/bin/env bash

# TODO partition options

# --------------------------------------------------------------------------------
# Instructions
# --------------------------------------------------------------------------------

# Boot the Arch Linux installer. Get online. Partition Disks.
#
#     wifi-menu
#     ping 8.8.8.8
#
# Set up your partitions and mount things to /mnt.
#
#     # create a 'gpt' partition map with
#     # - 1M partition (BIOS boot)
#     # - big partition (Linux filesystem)
#     lsblk
#     cfdisk /dev/sda
#
#     mkfs.ext4 ...
#     mount ...
#
# In the Archiso, Download this file:
#
#     wget URL -O arch-installer.sh
#     bash arch-installer.sh
#

# --------------------------------------------------------------------------------
# Configuration
# --------------------------------------------------------------------------------

TIME_ZONE="America/Los_Angeles"
EDITOR="nano"

HOSTNAME=""
USERNAME=""
USER_PASSWORD=""
ROOT_PASSWORD=""

LOCALES="en_US.UTF-8 UTF-8"
LANG="en_US.UTF-8"

PACKAGES="base"
PACKAGES+=" base-devel"
PACKAGES+=" vim git sudo openssh"
PACKAGES+=" networkmanager"
PACKAGES+=" xorg"

DRIVE="/dev/null"
SWAP="16G"

DISK_OUTPUT="$(sudo sfdisk -l | sed -En 's/Disk (\/dev\/\w+):.*/\1/p')"
DISKS=($DISK_OUTPUT)
DISKS_LENGTH="${#DISKS[*]}"

# --------------------------------------------------------------------------------
# Setup
# --------------------------------------------------------------------------------

# hostname
while true; do
  echo ""
  echo -ne "Hostname: "
  read answer
  [ "$answer" != "" ] && break
  echo "Hostname is required. Try again."
done
HOSTNAME="$answer"

# root password
while true; do
  echo ""
  read -s -p "Root Password: " answer
  echo
  read -s -p "Root Password (confirm): " confirm
  echo
  [ "$answer" = "$confirm" ] && [ "$answer" != "" ] && break
  echo "Root passwords are empty or do not match. Try again."
done
ROOT_PASSWORD="$answer"

# username
while true; do
  echo ""
  echo -ne "Username: "
  read  answer
  [ "$answer" != "" ] && break
  echo "Username is required. Try again."
done
USERNAME="$answer"

# user password
while true; do
  echo ""
  read -s -p "User Password: " answer
  echo
  read -s -p "User Password (confirm): " confirm
  echo
  [ "$answer" = "$confirm" ] && [ "$answer" != "" ] && break
  echo "User passwords are empty or do not match. Try again."
done
USER_PASSWORD="$answer"

# disk
while true; do
  echo
  for (( i=0; i < $(( $DISKS_LENGTH )); i++ )) do
    echo "${i}: ${DISKS[i]}"
  done
  echo -ne "Type the disk number you would like to partition: "
  read answer
  [ "$answer" != "" ] && break
  echo
  echo "Disk is required. Try again."
done
DISK="$answer"

# --------------------------------------------------------------------------------
# Partition 
# --------------------------------------------------------------------------------

# might need dosfstools

# format
# mkfs.fat -F32 /dev/sdX1
# mkfs.ext4 /dev/sdX2

# mount
# mount /dev/sdX2 /mnt
# mkdir /mnt/efi
# mount /dev/sdX1 /mnt/efi

# --------------------------------------------------------------------------------
# Base System
# --------------------------------------------------------------------------------

# ensure that there's something in /mnt
if ! findmnt /mnt &>/dev/null; then
  echo "Can't continue:"
  echo "Mount a drive to /mnt before running this."
  exit 1
fi

# mirrorlist
echo ""
echo "Press enter to edit /etc/pacman.d/mirrorlist."
echo -ne "[e]dit [s]kip: "
read answer
if [[ "$answer" != "s" ]]; then 
  "$EDITOR" /etc/pacman.d/mirrorlist;
fi

# packages
pacstrap /mnt $PACKAGES

# fstab
genfstab -U /mnt >> /mnt/etc/fstab

# timezone
arch-chroot /mnt sh -c "
  ln -sf '/usr/share/zoneinfo/$TIME_ZONE' /etc/localtime
  hwclock --systohc
"

# locale
arch-chroot /mnt sh -c "
  echo '$LOCALES' >> /etc/locale.gen
  echo 'LANG=$LANG' > /etc/locale.conf
  locale-gen
"

# hostname
arch-chroot /mnt sh -c "
  echo '$HOSTNAME' > /etc/hostname
  echo '127.0.0.1 localhost' >> /etc/hosts
  echo '::1 localhost' >> /etc/hosts
  echo '127.0.1.1 $HOSTNAME.localdomain $HOSTNAME' >> /etc/hosts
"

# root password
arch-chroot /mnt sh -c "
  (echo '$ROOT_PASSWORD'; echo '$ROOT_PASSWORD') | passwd
"

# user
arch-chroot /mnt sh -c "
  useradd -Nm -g users -G wheel,sys,audio,input,video,network,rfkill '$USERNAME'
  (echo '$USER_PASSWORD'; echo '$USER_PASSWORD') | passwd '$USERNAME'
"

# sudo
arch-chroot /mnt sh -c "
  echo '%wheel ALL=(ALL) NOPASSWD: ALL' | sudo EDITOR='tee -a' visudo
"

# --------------------------------------------------------------------------------
# Bootloader 
# --------------------------------------------------------------------------------

# grub
arch-chroot /mnt sh -c "
  pacman -S --needed --noconfirm grub
  grub-install '$DRIVE'
  grub-mkconfig -o /boot/grub/grub.cfg
"

# --------------------------------------------------------------------------------
# Optional
# --------------------------------------------------------------------------------

# swap file
arch-chroot /mnt sh -c "
 fallocate -l $SWAP /swapfile
 chmod 600 /swapfile
 mkswap /swapfile
 echo '/swapfile none swap defaults 0 0' | tee -a /etc/fstab
"

# systemd-swap
#arch-chroot /mnt sh -c "
# pacman -S --noconfirm --needed systemd-swap
# sed -i 's/swapfc_enabled=0/swapfc_enabled=1/' /etc/systemd/swap.conf
# systemctl enable systemd-swap
#"

# ===== DHCP for networking (recommended for VM's) =====
# # Enabling this will enable the dhcpcd@<interface> service. Use
# # `ip addr` to find this interface name.
#
#DHCP_INTERFACE=ens33
#arch-chroot /mnt sh -c "
#  sudo systemctl enable 'dhcpcd@$DHCP_INTERFACE'
#"

# networkmanager
arch-chroot /mnt sh -c "
 pacman -S --needed --noconfirm networkmanager
 systemctl enable NetworkManager.service
 systemctl mask NetworkManager-wait-online.service
"

# time synchronization
arch-chroot /mnt sh -c "
 systemctl enable --now systemd-timesyncd.service
"

# pacman customizations
arch-chroot /mnt sh -c "
 sed -i 's/^#Color/Color/' /etc/pacman.conf
 sed -i 's/^#VerbosePkgLists/VerbosePkgLists/' /etc/pacman.conf
"

# --------------------------------------------------------------------------------
# Done
# --------------------------------------------------------------------------------

echo ""
echo "Done :)"
