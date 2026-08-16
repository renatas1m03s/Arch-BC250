#!/bin/bash

## Bash script - basic archlinux install
## By Renata Maria - renata.s1m03s@gmail.com
## 
## This install basic components to achive a minimal functional Arch Linux System
##
## Version 0.1
##

echo -e "\n############ Installing dependencies ############\n"

pacman -Sy --noconfirm archlinux-keyring
pacman-key --init
pacman-key --populate archlinux
pacman -Sy --noconfirm --needed git p7zip

echo -e "\n############ Downloading setup scripts ############\n"

git clone https://github.com/renatas1m03s/Arch-BC250.git /root/Arch-BC250

cd /root/Arch-BC250
ls -la
