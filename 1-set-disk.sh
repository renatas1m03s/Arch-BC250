#!/bin/bash

if [[ -z "$1" ]]; then
	echo -e "Uso: $0 DISCO\n\nEx.: $0 /dev/nvme0n1\n"
else
	DISK=$1
	if [ -b "$DISK" ]; then
		while true; do
			read -rp "### AVISO!! Qualquer dado no disco $DISK será apagado. Prosseguir (s/n)? " -n 1 response
				case "$response" in
					[sS]) BOOT=$(fdisk -l $DISK | grep EFI | awk '{print $1}'); # Identifica a partição EFI/ESP
					      ROOT=$(fdisk -l $DISK | grep Linux | awk '{print $1}'); # Identifica a partição root
   					      mount -o clear_cache $ROOT /mnt;
				              btrfs subvolume create /mnt/{@,@home,@root,@cache,@log,@tmp,swap};
					      umount /mnt;
					      mount -o defaults,noatime,compress=zstd,commit=120,subvol=@ $ROOT /mnt;
					      mkdir -vp /mnt/{home,root,var/cache,var/log,var/tmp,mnt/Data,swap,boot};
					      mount -o defaults,noatime,compress=zstd,commit=120,subvol=@home $ROOT /mnt/home;
					      mount -o defaults,noatime,compress=zstd,commit=120,subvol=@root $ROOT /mnt/root;
					      mount -o defaults,noatime,compress=zstd,commit=120,subvol=@Data $ROOT /mnt/mnt/Data;
					      mount -o defaults,noatime,compress=zstd,commit=120,subvol=@cache $ROOT /mnt/var/cache;
					      mount -o defaults,noatime,compress=zstd,commit=120,subvol=@log $ROOT /mnt/var/log;
					      mount -o defaults,noatime,compress=zstd,commit=120,subvol=@tmp $ROOT /mnt/var/tmp;
					      mount -o defaults,noatime,compress=zstd,commit=120,subvol=swap $ROOT /mnt/swap;
					      mount $BOOT /mnt/boot;
					      echo -e "\nTopologia de disco e swap:\n";
				              mount | grep $DISK;
					      btrfs filesystem mkswapfile --size 8G --uuid clear /mnt/swap/swapfile;
					      swapon /mnt/swap/swapfile;
					      break;;
					[nN]) echo -e "\nNada a fazer";
						  break;;
					*) break
				esac
		done
	else
		echo -e "ERRO: Disco $DISK não encontrado\n"
	fi
fi
