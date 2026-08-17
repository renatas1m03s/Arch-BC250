## Sobre
Este é um conjunto de scripts para facilitar a instalação do Arch Linux.
O resultado final é o Arch com as seguintes caracteristicas:

## Características da instalação
- Arch-Linux com kernel zen ou o específico para a BC-250.
- Desktop Enviromento: KDE/Plasma
- Alguns utilitários e aplicativos: Firefox, VLC, btop e yt-dl dentre outros.  
- Sistema de arquivos: BTRFS
- Bootloader: Limine
- Arquivo de SWAP com ZSWAP  
  
## Acesso rápido aos scripts
```
curl -s "https://bit.ly/arch-bc250" | sh && cd /root/Arch-BC250 && ls -la
```
**O link real é "https://raw.githubusercontent.com/renatas1m03s/Arch-BC250/refs/heads/main/prepare.sh | sh && cd /root/Arch-BC250 && ls -la"**

Descrição das ações do script acima:  
- Atualiza as chaves PGP de assinatura dos pacotes do Arch Linux.  
- Instalação das ferramentas **git** e **p7zip**  
- Baixa os scripts via git clone na pasta **/root/Arch-BC250**  
- Vai para a pasta /root/Arch-BC250 e lista seu conteúdo  

## Etapas da instalação
1. [Configuração de disco](#configuração-de-disco)
2. [Ajustes no pacman](#ajustes-no-pacman)
3. [Instalação do sistema](instalação-do-sistema)
4. Configuração do bootloader
5. Configuração do usuário

Os scripts estão numerado e devem ser executados em ordem:

## Configuração de disco  
Essa etapa pode ser feita automaticamente através da execução do script ou pode ser feita manualmente.

O resultado da execução do script é que o disco escolhido ficará dividido em duas partições:  
  
- Uma partição de **4096MiB/4GiB**, formatada com **FAT32** e montada em /mnt/boot.
- Uma partição com o restante da área do disco, formatada como **BTRFS**.
- Os seguintes subvolumes do BTRFS:  
  - @      - Montado como /mnt (root)  
  - @home  - Montado como /mnt/home  
  - @root  - Montado como /mnt/root  
  - @cache - Montado como /mnt/var/cache  
  - @log   - Montado como /mnt/var/log  
  - @tmp   - Montado como /mnt/var/tmp  
  - @Data  - Montado como /mnt/mnt/Data  
  - swap   - Montado como /mnt/swap  
- Um arquivo de swap em /mnt/swap/swapfile de **8GB**  
  
Caso se deseje usar uma configuração diferente, basta respeitar três condições:  
1. Partição FAT32 como /boot  
2. Estrutura do root "/" montada em /mnt  
3. Swap configurado como arquivo para tirar proveito do ZSWAP  
    
O script em questão é o **1-wipe-disk.sh** e ele recebe como parâmetro o disco onde o arch será instalado.  
Para listar os discos existentes no ambiente o melhor comando é o:
```
fdisk -l
```
Supondo do que disco seja um NVME identificado como **/dev/nvme0n1** a execução do script seria:  
  
   **./1-wipe-disk.sh /dev/nvme0n1**  
  
**IMPORTANTE: Esse script formata/apaga todos os dados do disco escolhido** 
    
## Ajustes no pacman
O script **2-set-pacman.sh** faz alguns ajustes no arquivo **pacman.conf**, são eles:  
- Habilitar a multilib do arch, que é a biblioteca 32bits.  
- Habilitar o respositório para o kernel customizado para a BC250. Isso não tem efeito colateral algum em PCs diferentes da BC250.  
- Habilitar algumas itens cosméticos, como por exemplo o download paralelo em 8 filas. 

Além desses ajustes o script executa o utilitário **reflector** que atualiza a lista de mirrors e classifica por taxa de download.   
  
Modo de uso:

   **./2-set-pacman.sh**  
   
## Instalação do sistema

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


