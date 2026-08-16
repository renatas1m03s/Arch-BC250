#!/bin/bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

cp -v $SCRIPT_DIR/assets/pacman.conf /etc/
pacman -Syy
pacman -S --noconfirm --needed archlinux-keyring
pacman-key --init
pacman-key --populate archlinux

timedatectl set-ntp true

echo -e "\nAtualizando os repositórios e mirrors (pode demorar uns minutos)...\n"
reflector --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
