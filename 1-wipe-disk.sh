#!/bin/bash

if [[ -z "$1" ]]; then
	echo -e "Uso: $0 DISCO\n\nEx.: $0 /dev/nvme0n1\n"
else
	DISK=$1
	if [ -b "$DISK" ]; then
		while true; do
			read -rp "### AVISO!! Qualquer dado no disco $DISK será apagado. Prosseguir (s/n)? " -n 1 response
				case "$response" in
					[sS]) parted -s --align optimal $DISK mklabel gpt;
					      parted -s --align optimal $DISK mkpart PRIMARY fat32 0% 4096M; # Não faz diferença o sistema de arquivo nesse comando
					      parted -s --align optimal $DISK mkpart PRIMARY ext4 4096M 100%;  # Não faz diferença o sistema de arquivo nesse comando
					      BOOT=$(fdisk -l $DISK | grep Microsoft | awk '{print $1}'); # Identifica a partição EFI/ESP
					      ROOT=$(fdisk -l $DISK | grep Linux | awk '{print $1}'); # Identifica a partição root
						  echo -e "\n\nFormatando a partição de boot como FAT32...\n";
						  mkfs.fat -v -F32 -n EFI $BOOT;
					      echo -e "\n\nFormatando a partição de root como BTRFS...\n";
					      mkfs.btrfs -f -v -L BTRFS_Root $ROOT;
						  mount -o clear_cache $ROOT /mnt;
						  btrfs subvolume create /mnt/{@,@home,@root,@cache,@log,@tmp,@Data,swap};
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
