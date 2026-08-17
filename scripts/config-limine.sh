#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Erro: Esse script precisa de privilégios do sudo" >&2
  exit 1
else
	## Instala o limine-mkinitcpio-hook
	LIMINET_MKINITCPIO_HOOK=$(curl -s "https://packages.cachyos.org/package/cachyos/x86_64/limine-mkinitcpio-hook" | lynx -stdin -dump | grep https | grep zst | awk '{print $2}')
	wget -P /tmp $LIMINET_MKINITCPIO_HOOK
	LIMINET_MKINITCPIO_HOOK_PACKAGE=$(ls /tmp/limine-mk*zst)
	pacman --noconfirm --needed -U $LIMINET_MKINITCPIO_HOOK_PACKAGE

	## Instala o limine-snapper-sync
	LIMINE_SNAPPER_SYNC=$(curl -s "https://packages.cachyos.org/package/cachyos/x86_64/limine-snapper-sync" | lynx -stdin -dump | grep https | grep zst | awk '{print $2}')
	wget -P /tmp $LIMINE_SNAPPER_SYNC
	LIMINE_SNAPPER_SYNC_PACKAGE=$(ls /tmp/limine-sna*zst)
	pacman --noconfirm --needed -U $LIMINE_SNAPPER_SYNC_PACKAGE
	
	#Configura um snapshot do BTRFS
	if [ ! -f "/etc/snapper/configs/root" ]; then
		snapper -c root create-config /
		snapper -c root create --description "Primeiro Snapshot"
	fi
	
	## Adciona o hook para boot via snapshots
	sed -i '/^HOOKS=/s/)[[:space:]]*$/ sd-btrfs-overlayfs&/' /etc/mkinitcpio.conf

	## Configura o tema para o limine 

	cat <<- 'EOF' > /boot/limine.conf
	# Limine parameters
	
	timeout: 3
	remember_last_entry: yes
	default_entry: 2

	# Theme
	term_palette: 1e1e2e;f38ba8;a6e3a1;f9e2af;89b4fa;f5c2e7;94e2d5;cdd6f4
	term_palette_bright: 585b70;f38ba8;a6e3a1;f9e2af;89b4fa;f5c2e7;94e2d5;cdd6f4
	term_background: ffffffff
	term_foreground: cdd6f4
	term_background_bright: ffffffff
	term_foreground_bright: cdd6f4
	wallpaper: boot():/limine-splash.png
	
	EOF

	## Cria os parametros de configuração para o limine-update
	LIMINE_CMDLINE=$(cat /proc/cmdline)

	cat <<- EOF > /etc/default/limine
	KERNEL_CMDLINE[default]+=$LIMINE_CMDLINE
	ENABLE_VERIFICATION=yes
	BOOT_ORDER="*, *fallback, Snapshots"
	ENABLE_SORT=no
	FIND_BOOTLOADERS=yes
	ENABLE_UKI=no
	LIMINE_BINARY_PATH=/usr/share/limine/BOOTX64.EFI
	EOF

	limine-update
fi

