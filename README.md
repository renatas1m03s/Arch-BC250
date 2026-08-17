# Sobre
Este é um conjunto de scripts para facilitar a instalação do Arch Linux.
O resultado final é o Arch com as seguintes caracteristicas:

- Arch-Linux com kernel zen ou o específico para a BC-250
- Sistema de arquivos BTRFS
- Bootloader: limine
- Desktop Enviromento: KDE/Plasma
- Alguns utilitários e aplicativos: Firefox, VLC, btop e yt-dl dentre outros.

Os scripts estão numerado e devem ser executados em ordem:

- **1-wipe-disk.sh** - Modo de uso: ./1-wipe-disk.sh DISCO_DO_SISTEMA  
Ex.: ./1-wipe-disk.sh /dev/sda  
**Este script formata o disco e apaga todos os dados.**  
  
  **ou**  
    
- **1-root-btrfs.sh** - Modo de uso: ./1-wipe-disk.sh PARTIÇÃO_ESCOLHIDA.  
Ex.: ./1-wipe-disk.sh /dev/sda2  
Esse script vai formatar uma partição como BTRFS. Alternativa ao uso do disco inteiro.  
  
  **ou**  
    
- **1-root-btrfs-no-home.sh** - Modo de uso: ./1-wipe-disk.sh PARTIÇÃO_ESCOLHIDA  
Ex.: ./1-wipe-disk.sh /dev/sda2  
Esse script vai formatar uma partição como BTRFS, mas sem o home. Alternativa ao uso do disco inteiro.  
    
- **2-set-pacman.sh** - Modo de uso: ./2-set-pacman.sh  
Configura o pacman inserindo o repositório do kernel modificado para a BC-250  

- **3-base-system-bc250.sh** - Mode de uso: ./3-base-system-bc250.sh -k KEYMAP -t TIMEZONE -s HOSTNAME 
Ex. /3-base-system-bc250.sh -k br-abnt2 -t America/Sao_Paulo -s linuxtest
Se não for passado qualquer parâmetro o default é o teclado br-abnt2, timezone America/Sao_Paulo e hostname just4play
Esse script instala o sistema operacional, com o kernel personalizado para a BC-250, além da interface gráfica.  
  
  **ou**  
    
- **3-base-system.sh** - Mode de uso: ./3-base-system.sh -k KEYMAP -t TIMEZONE  
Ex. /3-base-system-bc250.sh -k br-abnt2 -t America/Sao_Paulo  
Se não for passado qualquer parâmetro o default é o teclado br-abnt2 e a timezone America/Sao_Paulo.  
Esse script instala o sistema operacional, com o kernel linuz-zen, além da interface gráfica.  

- **4-set-limine.sh** - Modo de uso: ./4-set-limine.sh DISCO_DO_SISTEMA  
Ex.: ./4-set-limine.sh /dev/sda  
Configura o limine com todos os parâmetros necessários.  

- **5-set-user.sh** - Modo de uso: ./5-set-user.sh -u username -c 'Nome Completo' -p 'PASSWORD'  
Ex.: ./5-set-user.sh -u palmeiras -c 'Palestra Itália' -p 'P@ssw0rd'  
Se o script for executado sem qualquer parâmetro será criado o usuário **arch** com a senha **archlinux**  

```
curl -s "https://raw.githubusercontent.com/renatas1m03s/Arch-BC250/refs/heads/main/prepare.sh" | sh && cd /root/Arch-BC250 && ls -la
```
