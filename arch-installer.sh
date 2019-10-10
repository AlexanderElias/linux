#!/usr/bin/env bash

# --------------------------------------------------------------------------------
# Instructions
# --------------------------------------------------------------------------------

# Boot Arch Linux installer. Get online.
#
#     wifi-menu
#
# In the Archiso, Download this file:
#
#     wget URL -O arch-installer.sh
#     bash arch-installer.sh
#

echo
echo "|------------------------------------------|"
echo "|        Vokeio Arch Installer             |"
echo "|------------------------------------------|"
echo

# --------------------------------------------------------------------------------
# Configuration
# --------------------------------------------------------------------------------

HOSTNAME=""
USERNAME=""
USER_PASSWORD=""
ROOT_PASSWORD=""

TIME_ZONE="America/Los_Angeles"
COUNTRY="US"

LOCALES="en_${COUNTRY}.UTF-8 UTF-8"
LANG="en_${COUNTRY}.UTF-8"

PACKAGES="base base-devel linux linux-headers linux-firmware"
PACKAGES+=" sudo openssh git vim"
PACKAGES+=" netctl wpa_supplicant dhcpcd dialog"

RAM_OUTPUT=$(cat /proc/meminfo | sed -En 's/MemTotal:\s+([0-9]+) kB/\1/p')
RAM=$(( RAM_OUTPUT / 1000000 ))
SWAP="${RAM}G"

DISK_OUTPUT="$(parted -l | sed -En 's/Disk (\/dev\/\w+):.*/\1/p')"
DISKS=('' $DISK_OUTPUT)
DISKS_LENGTH="${#DISKS[*]}"

# --------------------------------------------------------------------------------
# Setup
# --------------------------------------------------------------------------------

# hostname
answer=""
while true; do
    echo ""
    echo -ne "Hostname: "
    read answer
    [ "$answer" != "" ] && break
    echo "Hostname is required. Try again."
done
HOSTNAME="$answer"

# root password
answer=""
confirm=""
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
answer=""
while true; do
    echo
    echo -ne "Username: "
    read  answer
    [ "$answer" != "" ] && break
    echo "Username is required. Try again."
done
USERNAME="$answer"

# user password
answer=""
confirm=""
while true; do
    echo
    read -s -p "User Password: " answer
    echo
    read -s -p "User Password (confirm): " confirm
    echo
    [ "$answer" = "$confirm" ] && [ "$answer" != "" ] && break
    echo "User passwords are empty or do not match. Try again."
done
USER_PASSWORD="$answer"

# disk
answer=""
while true; do
    echo
    for (( i=0; i < $DISKS_LENGTH; i++ )) do
        [ ${i} != 0 ] && echo "${i}) ${DISKS[i]}"
    done
    echo -ne "Type the disk number you would like to partition: "
    read answer
    [ "${DISKS[answer]}" != "" ] && break
    echo
    echo "Disk is required. Try again."
done
DISK="${DISKS[answer]}"

# --------------------------------------------------------------------------------
# Partition
# --------------------------------------------------------------------------------

parted -s $DISK \
    mklabel gpt \
    mkpart primary fat32 1MiB 512MiB \
    set 1 boot on \
    set 1 esp on \
    mkpart primary ext4 512MiB 100%

if [[ $DISK == /dev/nvme* ]]; then
    PARTITION="${DISK}p"
else
    PARTITION="${DISK}"
fi

# format
mkfs.fat -F32 "${PARTITION}1"
mkfs.ext4 "${PARTITION}2"

# mount
mount "${PARTITION}2" /mnt
mkdir /mnt/efi
mount "${PARTITION}1" /mnt/efi

# --------------------------------------------------------------------------------
# Base System
# --------------------------------------------------------------------------------

# mirrorlist
wget -O /etc/pacman.d/mirrorlist -q "https://www.archlinux.org/mirrorlist/?country=${COUNTRY}&protocol=http&protocol=https&ip_version=4&ip_version=6"
echo '
## Worldwide
#Server = http://mirrors.evowise.com/archlinux/$repo/os/$arch
#Server = http://mirror.rackspace.com/archlinux/$repo/os/$arch
#Server = https://mirror.rackspace.com/archlinux/$repo/os/$arch
' >> /etc/pacman.d/mirrorlist

sed -i 's/^#Server/Server/g' /etc/pacman.d/mirrorlist

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
    grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
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
# Unmount
# --------------------------------------------------------------------------------

umount -R /mnt

# --------------------------------------------------------------------------------
# Done
# --------------------------------------------------------------------------------

echo ""
echo "Done :)"
