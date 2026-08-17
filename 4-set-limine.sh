#!/bin/bash

if [[ -z "$1" ]]; then
	echo -e "Uso: $0 DISCO_DO_SISTEMA\n\nEx.: $0 /dev/nvme0n1\n"
else
	DISK=$1
	if [ -b "$DISK" ]; then
		INITRAMFS=$(ls /mnt/boot/init* | awk -F"/" '{print $4}')
		VMLINUZ=$(ls /mnt/boot/vmli* | awk -F"/" '{print $4}')
		ROOT_PARTITION=$(mount | grep "subvol=/@)" | awk '{print $1}')
		ROOT_PARTITION_UUID=$(lsblk -no UUID $ROOT_PARTITION)
		SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

		cp -v $SCRIPT_DIR/assets/limine-splash.png /mnt/boot/
		mkdir -p /mnt/boot/EFI/arch-limine
		cp -v /mnt/usr/share/limine/BOOTX64.EFI /mnt/boot/EFI/arch-limine

		arch-chroot /mnt efibootmgr --create --disk $DISK --part 1 --label "Arch Linux" --loader '\EFI\arch-limine\BOOTX64.EFI' --unicode

		cat <<- EOF > /mnt/boot/EFI/arch-limine/limine.conf
		timeout: 3
		remember_last_entry: yes

		# Catppuccin Mocha Palette
		term_palette: 1e1e2e;f38ba8;a6e3a1;f9e2af;89b4fa;f5c2e7;94e2d5;cdd6f4
		term_palette_bright: 585b70;f38ba8;a6e3a1;f9e2af;89b4fa;f5c2e7;94e2d5;cdd6f4
		term_background: ffffffff
		term_foreground: cdd6f4
		term_background_bright: ffffffff
		term_foreground_bright: cdd6f4
		wallpaper: boot():/limine-splash.png

		/Arch Linux
			protocol: linux
			path: boot():/$VMLINUZ
			cmdline: quiet loglevel=0 splash root=UUID=$ROOT_PARTITION_UUID rootflags=subvol=@ rootfstype=btrfs rw zswap.enabled=1 zswap.shrinker_enabled=1 zswap.compressor=lz4 zswap.max_pool_percent=25
			module_path: boot():/$INITRAMFS
		EOF

		cat <<- 'EOF' > /mnt/etc/pacman.d/hooks/99-limine.hook
		[Trigger]
		Operation = Install
		Operation = Upgrade
		Type = Package
		Target = limine              

		[Action]
		Description = Deploying Limine after upgrade...
		When = PostTransaction
		Exec = /usr/bin/cp /usr/share/limine/BOOTX64.EFI boot/EFI/arch-limine/
		EOF

		sed -i s/MODULES=\(\)/MODULES=\(lz4\)/g /mnt/etc/mkinitcpio.conf
		arch-chroot /mnt mkinitcpio -P

	else
		echo -e "\nDisco $DISK não encontrado.\n"
	fi
fi

