#!/bin/bash
# connect wifi	   use  iwctl
# cdsisk /dev/nvme0n1  efi root swap
systemctl stop reflector
timedatectl set-ntp true
mkfs.ext4 /dev/nvme0n1p2
mkswap /dev/nvme0n1p3
mkfs.fat -F 32	/dev/nvme0n1p1
mount /dev/nvme0n1p2 /mnt
mkdir /mnt/efi
swapon /dev/nvme0n1p3
mount /dev/nvme0n1p1  /mnt/efi
echo "Server = https://mirrors.ustc.edu.cn/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist
pacman -Syy
pacstrap /mnt base linux-lts  linux-firmware  linux-lts-headers vim 
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt



ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "zh_CN.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "love_open_source" > /etc/hostname
echo "127.0.0.1" > /etc/hosts
echo "root password"
passwd
useradd -m open_source
passwd open_source
pacman -S amd-ucode
pacman -S sudo plasma-desktop networkmanager networkmanager-pptp network-manager-applet  base-devel xorg sddm  w3m bash-completion  wqy-zenhei
pacman -S xcompmgr git libxinerama libx11 libxft
echo "open_source ALL=(ALL:ALL) ALL" >> /etc/sudoers
echo "#!/bin/bash" > /home/open_source/enable.sh
echo "nm-applet" >> /home/open_source/enable.sh
echo "xcompmgr" >> /home/open_source/enable.sh
chown open_source:open_source /home/open_source/enable.sh
# settings > start up  enable script
systemctl enable NetworkManager
systemctl enable sddm
bootctl --path=/efi install
mkdir /efi/EFI/arch
mv /boot/*.img  /efi/EFI/arch/
mv /boot/vmlinuz* /efi/EFI/arch/
echo "default arch" > /efi/loader/loader.conf
echo "timeout 0" >> /efi/loader/loader.conf
echo "console-mode max" >> /efi/loader/loader.conf
echo "editor no" >>  /efi/loader/loader.conf
echo "title   Arch install Lts" > /efi/loader/entries/arch.conf
echo "linux   /EFI/arch/vmlinuz-linux-lts" >> /efi/loader/entries/arch.conf
echo "initrd  /EFI/arch/amd-ucode.img" >> /efi/loader/entries/arch.conf
echo "initrd  /EFI/arch/initramfs-linux-lts.img" >> /efi/loader/entries/arch.conf
echo "options root=PARTUUID=272c95d4-a62a-804c-b654-1cfbc332a3d6 rw" >> /efi/loader/entries/arch.conf
# vim   :r !blkid



