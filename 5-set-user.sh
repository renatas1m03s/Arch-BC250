#!/bin/bash

# Define os valores defaults para os parâmetros
USER="arch"
USER_DISPLAYNAME="Arch User"
USER_PASSWORD="archlinux"

# Function to display how to use the script
usage() {
    echo "Modo de uso: $0 [opções]"
    echo "Opções:"
    echo "  -u, --user VALOR        # Username - default arch"
    echo "  -c, --displayname VALOR # Nome completo - default Arch Linux"
    echo "  -p, --password VALOR    # Password - default archlinux"
    echo "  -h, --help              # Display this help message"
    exit 1
}

# Main parsing loop
while [[ $# -gt 0 ]]; do
    case "$1" in
        -u|--user)
            USER="$2"
            shift 2 # Move past the flag and its value
            ;;
        -c|--displayname)
            USER_DISPLAYNAME="$2"
            shift 2 # Move past the flag and its value
            ;;
        -p|--password)
            USER_PASSWORD="$2"
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

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
TELAICONS_PATH="/mnt/home/$USER/.local/share/icons/"
TELAICONS_FILE="$SCRIPT_DIR/assets/telaicons.tar.xz"

# Seta a senha para usuário root
USER_PASSWORD=$USER_PASSWORD arch-chroot /mnt bash -c 'echo $USER_PASSWORD | passwd --stdin'

# Cria o usuário - default arch
arch-chroot /mnt useradd -m -g users -G wheel -c "${USER_DISPLAYNAME}" -s /usr/bin/fish $USER

# Seta a senha para usuário criado - Default user arch com a senha archlinux
USER_PASSWORD=$USER_PASSWORD USER=$USER arch-chroot /mnt bash -c 'echo $USER_PASSWORD | passwd --stdin $USER'

# Coloca o usuário criado no sudoers
USER=$USER arch-chroot /mnt bash -c 'echo "$USER ALL=(ALL) ALL" | EDITOR="tee -a" visudo'

# Elimina a necessidade de colocar senha no pacman para o usuário criado
USER=$USER arch-chroot /mnt bash -c 'echo "$USER ALL=(ALL) NOPASSWD: /usr/bin/pacman" | EDITOR="tee -a" visudo'

# Configurações personalizadas para o usuário - alacritty, fish functions e opções regionais
if [ ! -d "/mnt/home/$USER/.config" ]; then
	mkdir -pv /mnt/home/$USER/.config/{alacritty,fish/functions}
fi
cp -v $SCRIPT_DIR/assets/alacritty/alacritty.toml /mnt/home/$USER/.config/alacritty/alacritty.toml
cp -v $SCRIPT_DIR/assets/functions/* /mnt/home/$USER/.config/fish/functions/
cp -v $SCRIPT_DIR/assets/plasma-localerc /mnt/home/$USER/.config/

# Copia um conjunto de wallpapers do arch
if [ ! -d "/mnt/home/$USER/Pictures" ]; then
	mkdir -pv /mnt/home/$USER/Pictures
fi
cp -v $SCRIPT_DIR/assets/wallpapers/* /mnt/home/$USER/Pictures/

# Instala o conjunto de icones Tela
if [ ! -d "/mnt/home/$USER/.local/share/icons" ]; then
	mkdir -pv /mnt/home/$USER/.local/share/icons
fi
tar Jxvf $TELAICONS_FILE -C $TELAICONS_PATH

# Copia os scripts de instalação para a pasta do usuário
if [ ! -d "/mnt/home/$USER/Arch-BC250" ]; then
	mkdir -pv /mnt/home/$USER/Arch-BC250
fi
cp -Rv $SCRIPT_DIR/* /mnt/home/$USER/Arch-BC250

# Corrige as permissões ao final
USER=$USER arch-chroot /mnt bash -c 'chown -R $USER:users /home/$USER/'

