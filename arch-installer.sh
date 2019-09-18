#!/usr/bin/env bash

# Arch Installer
#
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
#     wget BLANK -O install.sh
#     bash install.sh
#

# --------------------------------------------------------------------------------
# Configuration 
# --------------------------------------------------------------------------------

# Edit these things
TIME_ZONE="America/Los_Angeles"
SYSTEM_HOSTNAME="aos"
EDITOR="nano"

# Your user
USERNAME="alex"
PASSWORD="123"
ROOT_PASSWORD="123"

# Locales
LOCALES="en_US.UTF-8 UTF-8"
LANG="en_US.UTF-8"

# Packages to install
PACKAGES="base"
PACKAGES+=" base-devel"
PACKAGES+=" vim git sudo openssh"
PACKAGES+=" xorg"

# Boot
DRIVE="/dev/null"

# Swap
SWAP_SIZE="16G"

# --------------------------------------------------------------------------------
# Base System
# --------------------------------------------------------------------------------

# Ensure that there's something in /mnt
if ! findmnt /mnt &>/dev/null; then
  echo "Can't continue:"
  echo "Mount a drive to /mnt before running this."
  exit 1
fi

# Edit mirrorlist
echo ""
echo "Press enter to edit /etc/pacman.d/mirrorlist."
echo -ne "[E]dit [s]kip: "
read answer
if [[ "$answer" != "s" ]]; then "$EDITOR" /etc/pacman.d/mirrorlist; fi

# Install packages
pacstrap /mnt $PACKAGES

# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Set timezone
arch-chroot /mnt sh -c "
  ln -sf '/usr/share/zoneinfo/$TIME_ZONE' /etc/localtime
  hwclock --systohc
"

# Locale
arch-chroot /mnt sh -c "
  echo '$LOCALES' >> /etc/locale.gen
  echo 'LANG=$LANG' > /etc/locale.conf
  locale-gen
"

# Hostname
arch-chroot /mnt sh -c "
  echo '$SYSTEM_HOSTNAME' > /etc/hostname
  echo '127.0.0.1 localhost' >> /etc/hosts
  echo '::1 localhost' >> /etc/hosts
  echo '127.0.1.1 $SYSTEM_HOSTNAME.localdomain $SYSTEM_HOSTNAME' >> /etc/hosts
"

# Root password
arch-chroot /mnt sh -c "
  (echo '$ROOT_PASSWORD'; echo '$ROOT_PASSWORD') | passwd
"

# Add user
arch-chroot /mnt sh -c "
  useradd -Nm -g users -G wheel,sys,audio,input,video,network,rfkill '$USERNAME'
  (echo '$ROOT_PASSWORD'; echo '$ROOT_PASSWORD') | passwd '$USERNAME'
"

# Sudo
arch-chroot /mnt sh -c "
  echo '%wheel ALL=(ALL) NOPASSWD: ALL' | sudo EDITOR='tee -a' visudo
"

# --------------------------------------------------------------------------------
# Bootloader 
# --------------------------------------------------------------------------------

# ===== GRUB (BIOS mode) =====
arch-chroot /mnt sh -c "
  pacman -S --needed --noconfirm grub
  grub-install '$DRIVE'
  grub-mkconfig -o /boot/grub/grub.cfg
"

# --------------------------------------------------------------------------------
# Optional
# --------------------------------------------------------------------------------

# ===== Swap file =====
arch-chroot /mnt sh -c "
 fallocate -l $SWAP_SIZE /swapfile
 chmod 600 /swapfile
 mkswap /swapfile
 echo '/swapfile none swap defaults 0 0' | tee -a /etc/fstab
"

# ===== DHCP for networking (recommended for VM's) =====
# # Enabling this will enable the dhcpcd@<interface> service. Use
# # `ip addr` to find this interface name.
#
#DHCP_INTERFACE=ens33
#arch-chroot /mnt sh -c "
#  sudo systemctl enable 'dhcpcd@$DHCP_INTERFACE'
#"

# ===== NetworkManager (recommended for laptops) =====
#
#arch-chroot /mnt sh -c "
#  pacman -S --needed --noconfirm networkmanager
#  systemctl enable NetworkManager.service
#  systemctl mask NetworkManager-wait-online.service
#"

# ===== Time synchronization =====
arch-chroot /mnt sh -c "
 systemctl enable --now systemd-timesyncd.service
"

# ===== Pacman customizations =====
arch-chroot /mnt sh -c "
 sed -i 's/^#Color/Color/' /etc/pacman.conf
 sed -i 's/^#VerbosePkgLists/VerbosePkgLists/' /etc/pacman.conf
"

# ===== Swap file via systemd-swap =====
#
#arch-chroot /mnt sh -c "
# pacman -S --noconfirm --needed systemd-swap
# sed -i 's/swapfc_enabled=0/swapfc_enabled=1/' /etc/systemd/swap.conf
# systemctl enable systemd-swap
#"

echo ''
echo 'Done :)'
