#!/bin/bash

if [[ -z "$1" ]]; then
	echo -e "Uso: $0 DISCO\n\nEx.: $0 /dev/nvme0n1\n"
else
	DISK=$1
	if [ -b "$DISK" ]; then
		BOOT=$(fdisk -l $DISK | grep Microsoft | awk '{print $1}'); # Identifica a partição EFI/ESP
		ROOT="/dev/mapper/root"; # Identifica a partição root
		mount -o defaults,noatime,compress=zstd,commit=120,subvol=@ $ROOT /mnt;
		mount -o defaults,noatime,compress=zstd,commit=120,subvol=@home $ROOT /mnt/home;
		mount -o defaults,noatime,compress=zstd,commit=120,subvol=@root $ROOT /mnt/root;
		mount -o defaults,noatime,compress=zstd,commit=120,subvol=@cache $ROOT /mnt/var/cache;
		mount -o defaults,noatime,compress=zstd,commit=120,subvol=@log $ROOT /mnt/var/log;
		mount -o defaults,noatime,compress=zstd,commit=120,subvol=@tmp $ROOT /mnt/var/tmp;
		mount $BOOT /mnt/boot;
		arch-chroot /mnt
	else
		echo -e "ERRO: Disco $DISK não encontrado\n"
	fi
fi
