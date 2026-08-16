#!/bin/bash

# Define os valores defaults para os parâmetros
KEYBOARD="br-abnt2"
TIMEZONE="America/Sao_Paulo"

# Function to display how to use the script
usage() {
    echo "Modo de uso: $0 [opções]"
    echo "Opções:"
    echo "  -k, --keyboard VALOR    # Keyboard - default br-abnt2"
    echo "  -t, --timezone VALOR    # Timezone - default America/Sao_Paulo"
    echo "  -h, --help              # Display this help message"
    exit 1
}

# Main parsing loop
while [[ $# -gt 0 ]]; do
    case "$1" in
        -k|--keyboard)
            KEYBOARD="$2"
            shift 2 # Move past the flag and its value
            ;;
        -t|--timezone)
            TIMEZONE="$2"
            shift 2 # Move past the flag and its value
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Opção inexistente '$1'"
            usage
            ;;
    esac
done

echo -e "\nUsando o teclado $KEYBOARD e a Timezone $TIMEZONE\n"

pacstrap -K /mnt base linux-firmware linux-cachyos-bc250 linux-cachyos-bc250-headers dkms base-devel amd-ucode reflector nano sudo vim fish

genfstab -U /mnt >> /mnt/etc/fstab

cp -v /etc/pacman.conf /mnt/etc/ && cp -Rv /etc/pacman.d/* /mnt/etc/pacman.d/

TIMEZONE=$TIMEZONE arch-chroot /mnt bash -c 'ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime'
arch-chroot /mnt hwclock --systohc 
sed -i s/#pt_BR.UTF-8/pt_BR.UTF-8/g /mnt/etc/locale.gen
sed -i s/#en_US.UTF-8/en_US.UTF-8/g /mnt/etc/locale.gen
arch-chroot /mnt locale-gen
echo LANG=en_US.UTF-8 >> /mnt/etc/locale.conf
echo just4play > /mnt/etc/hostname
localectl set-keymap $KEYBOARD
cp -v /etc/vconsole.conf /mnt/etc/vconsole.conf

arch-chroot /mnt pacman -S --noconfirm --needed  dosfstools mtools dialog rsync limine efibootmgr openssh exfat-utils plymouth cronie networkmanager modemmanager inetutils dnsutils git base-devel wget btrfs-progs snapper snap-pac btrfs-assistant inotify-tools
arch-chroot /mnt pacman -S --noconfirm --needed mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon mesa-utils
arch-chroot /mnt pacman -S --noconfirm --needed lib32-pipewire plasma-meta xorg-xlsclients bluez-utils blueman packagekit-qt6 gnome-disk-utility konsole okular dolphin ark spectacle gwenview kcalc openconnect networkmanager-openconnect kio kio-extras ffmpegthumbs kdegraphics-thumbnailers kimageformats qt6-imageformats kdesdk-thumbnailers tuned tuned-ppd alacritty dolphin-plugins kio-gdrive kio-fuse kwalletmanager dragon
arch-chroot /mnt pacman -S --noconfirm --needed firefox vlc vlc-plugin-ffmpeg geany geany-plugins fastfetch openvpn usb_modeswitch p7zip unzip btop adobe-source-han-sans-otc-fonts adobe-source-han-serif-otc-fonts noto-fonts noto-fonts-cjk noto-fonts-emoji yt-dlp lynx


# Inicia os daemons NetworkManager, sshd, plasmalogin, avahi-daemon, bluetooth e grub-btrfsd
arch-chroot /mnt systemctl enable {NetworkManager,sshd,plasmalogin,avahi-daemon,bluetooth}

