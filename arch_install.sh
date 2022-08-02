#!/bin/bash
# connect wifi	   use  iwctl
# systemctl stop refle*
# update source and install git
# cdsisk /dev/nvme0n1  efi root swap
systemctl stop reflector
timedatectl set-ntp true
mkfs.ext4 /dev/nvme0n1p2
mkswap /dev/nvme0n1p3
mkfs.vfat -F 32	/dev/nvme0n1p1
mount /dev/nvme0n1p2 /mnt
mkdir /mnt/efi
swapon /dev/nvme0n1p3
mount /dev/nvme0n1p1  /mnt/efi

pacstrap /mnt base linux-lts  linux-firmware  linux-lts-headers vim 
genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt



ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "zh_CN.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "os_arch" > /etc/hostname
echo "127.0.0.1  localhost" > /etc/hosts
echo "root password"
passwd
useradd -m kan
passwd kan
pacman -S amd-ucode
pacman -S sudo wayland gnome networkmanager fcitx5-im fcitx5-rime networkmanager-pptp network-manager-applet  base-devel   gdm  links bash-completion  wqy-zenhei
pacman -S  git   
echo "kan ALL=(ALL:ALL) ALL" >> /etc/sudoers
# settings > start up  enable script
systemctl enable NetworkManager
systemctl enable gdm
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

echo "GTK_IM_MODULE=fcitx" >> /etc/environment

echo "QT_IM_MODULE=fcitx" >> /etc/environment

echo "XMODIFIERS=@im=fcitx" >> /etc/environment

echo "SDL_IM_MODULE=fcitx" >> /etc/environment

echo "GLFW_IM_MODULE=ibus" >> /etc/environment

# bootctl --path=/efi install
# mkdir /efi/EFI/arch
# mv /boot/*.img  /efi/EFI/arch/
# mv /boot/vmlinuz* /efi/EFI/arch/
# echo "default arch" > /efi/loader/loader.conf
# echo "timeout 0" >> /efi/loader/loader.conf
# echo "console-mode max" >> /efi/loader/loader.conf
# echo "editor no" >>  /efi/loader/loader.conf
# echo "title   Arch install Lts" > /efi/loader/entries/arch.conf
# echo "linux   /EFI/arch/vmlinuz-linux-lts" >> /efi/loader/entries/arch.conf
# echo "initrd  /EFI/arch/amd-ucode.img" >> /efi/loader/entries/arch.conf
# echo "initrd  /EFI/arch/initramfs-linux-lts.img" >> /efi/loader/entries/arch.conf
# echo "options root=PARTUUID=272c95d4-a62a-804c-b654-1cfbc332a3d6 rw" >> /efi/loader/entries/arch.conf
# vim   :r !blkid



