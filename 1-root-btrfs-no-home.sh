#!/bin/bash

if [[ -z "$1" ]]; then
	echo -e "Uso: $0 PARTIÇÃO_ROOT\n\nEx.: $0 /dev/nvme0n1p2\n"
else
	DISK=$1
	if [ -b "$DISK" ]; then
		while true; do
			read -p "### Qualquer dado em $DISK será apagado, prosseguir (s/n)? " -n 1 response
				case "$response" in
					[sS]) mkfs.btrfs -v -f -L BTRFS_Root $DISK;
						  mount -o clear_cache $DISK /mnt;
						  btrfs subvolume create /mnt/{@,@home,@root,@cache,@log,@tmp,swap};
						  umount /mnt;
						  mount -o defaults,noatime,compress=zstd,commit=120,subvol=@ $DISK /mnt;
						  mkdir -vp /mnt/{home,root,var/cache,var/log,var/tmp,swap,boot};
						  mount -o defaults,noatime,compress=zstd,commit=120,subvol=@root $DISK /mnt/root;
						  mount -o defaults,noatime,compress=zstd,commit=120,subvol=@cache $DISK /mnt/var/cache;
						  mount -o defaults,noatime,compress=zstd,commit=120,subvol=@log $DISK /mnt/var/log;
						  mount -o defaults,noatime,compress=zstd,commit=120,subvol=@tmp $DISK /mnt/var/tmp;
						  mount -o defaults,noatime,compress=zstd,commit=120,subvol=swap $DISK /mnt/swap;
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
