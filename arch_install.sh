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
echo "Server = https://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch
" > /etc/pacman.d/mirrorlist
pacman -Syy
pacstrap /mnt base linux-lts  linux-firmware  linux-lts-headers
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
echo "not break run"
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
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
pacman -S sudo plasma-desktop networkmanager networkmanager-pptp network-manager-applet  base-devel xorg sddm  w3m bash-completion
pacman -S xcompmgr git libxinerama libx11 libxft
echo "open_source ALL=(ALL:ALL) ALL" >> /etc/sudoers
echo "#!/bin/bash" > /home/open_source/enable.sh
echo "nm-applet" >> /home/open_source/enable.sh
echo "xcompmgr" >> /home/open_source/enable.sh
chown open_source:open_source /home/open_source/enable.sh

systemctl enable sddm
pacman -S  grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
