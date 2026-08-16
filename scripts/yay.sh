#!/bin/bash
 
sudo pacman -Sy --noconfirm --needed base-devel git wget

cd /tmp && git clone https://aur.archlinux.org/yay.git && cd yay/ && makepkg -si --noconfirm 

echo -e '\n\n### Yay installed.\n'
