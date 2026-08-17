## Sobre
Este é um conjunto de scripts para facilitar a instalação do Arch Linux, inicialmente em uma placa AsRock BC-250, mas ele pode ser usado em qualquer plataforma **x64/EFI** sem qualquer efeito colateral.  
  
## Características da instalação
Como resultado final da instalação teremos um Arch Linux com as seguintes características:  
  
- Arch-Linux com kernel zen ou o específico para a BC-250.
- Desktop Enviromento: KDE/Plasma
- Alguns utilitários e aplicativos: Firefox, VLC, btop e yt-dl dentre outros.  
- Sistema de arquivos: BTRFS
- Bootloader: Limine
- Arquivo de SWAP com ZSWAP  
  
## Acesso rápido aos scripts

```
curl -s "https://raw.githubusercontent.com/renatas1m03s/Arch-BC250/refs/heads/main/prepare.sh | sh && cd /root/Arch-BC250 && ls -la"**
```
  
Descrição das ações do script acima:  
    
- Atualiza as chaves PGP de assinatura dos pacotes do Arch Linux.  
- Instalação das ferramentas **"git"** e **"p7zip"**  
- Baixa os scripts via git clone na pasta **"/root/Arch-BC250"**  
- Vai para a pasta /root/Arch-BC250 e lista seu conteúdo  

> [!TIP]  
> Alternativamente aos passos automatizados acima é possível fazer manualmente da seguinte forma:  
  
1. Instala o **"git"** 
```
pacman -Sy --noconfirm git
```  

2. Faz o download dos scripts  
```
git clone https://github.com/renatas1m03s/Arch-BC250 /root/Arch-BC250
```


## Etapas da instalação  
  
1. [Configuração de disco](#configuração-de-disco)
2. [Ajustes no pacman](#ajustes-no-pacman)
3. [Instalação do sistema](#instalação-do-sistema)
4. [Configuração do bootloader](#configuração-do-bootloader)
5. [Configuração do usuário](#configuração-do-usuário)
6. [Scripts adicionais](#scripts-adicionais)

> [!TIP]  
> Os scripts estão numerado e devem ser executados em ordem.  
  
## Configuração de disco  
Essa etapa pode ser feita automaticamente através da execução do script ou pode ser feita manualmente.

O resultado da execução do script é:  
  
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
  
1. Partição FAT32 como ESP e montada em /mnt/boot   
2. Estrutura do root "/" montada em /mnt  
3. Swap configurado como arquivo para tirar proveito do ZSWAP  
    
O script em questão é o **"1-wipe-disk.sh"** e ele recebe como parâmetro o disco onde o arch será instalado.  
  
Use o seguinte comando para identificar o disco onde se pretende realizar a instalação:

> **fdisk -l**

Supondo do que disco seja um NVME identificado como **"/dev/nvme0n1"** a execução do script seria:  
  
> **./1-wipe-disk.sh /dev/nvme0n1**  

> [!IMPORTANT]  
> Esse script formata/apaga todos os dados do disco escolhido  
    
## Ajustes no pacman
O script **"2-set-pacman.sh"** faz alguns ajustes no arquivo **"pacman.conf"**, são eles:  
- Habilitar a multilib do arch, que é a biblioteca 32bits (necessária para a steam).  
- Habilitar o respositório para o kernel customizado para a BC250. Isso não tem efeito colateral algum em PCs diferentes da BC250.  
- Habilitar algumas itens cosméticos, como por exemplo o download paralelo em 8 filas. 

Além desses ajustes o script executa o utilitário **"reflector"** que atualiza a lista de mirrors e classifica por taxa de download.   
  
> Modo de uso:

> **./2-set-pacman.sh**  
   
## Instalação do sistema
Existem dois scripts o **"3-base-system-bc250.sh"** e o **"3-base-system.sh"** que mudam entre si somente o kernel que eles entregam, ambos executam as seguintes atividades:  
  
1. Criam a estrutura de pastas de sistema do Arch Linux.  
2. Geram o arquivo **"fstab"**  
3. Definem as configurações regionais e o hostname (Defaults: br-abnt2, America/Sao_Paulo e just4play como hostname)  
4. Instalam os arquivos base do Arch Linux, bliblioteca mesa, plasma/kde e alguns utilitários.  
5. Habilitam alguns serviços básicos (NetworkManager, sshd, plasmalogin, avahi-daemon e bluetooth)  
  
Os kernels entregues são **"linux-cachyos-bc250"** e **"linux-zen"**, respectivamente.
    
> Modo de uso: ./3-base-system.sh \[opções\]  
> Opções:  
>   -k, --keyboard VALOR&nbsp;&nbsp;&nbsp;&nbsp;# Keyboard - default br-abnt2      
>   -t, --timezone VALOR&nbsp;&nbsp;&nbsp;&nbsp;# Timezone - default America/Sao_Paulo     
>   -s, --system&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;# Hostname - default just4play    
>   -h, --hel&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;# Display this help message  
  
> Ex.:  
> **./3-base-system-bc250.sh -k us-acentos -t America/Fortaleza -s linuxtest**  

> [!TIP]  
> Os parâmetros são opcionais e independentes, você pode alterar qualquer um deles individualmente.
  
Se não for passado qualquer parâmetro o default é teclado **"br-abnt2"**, timezone **"America/Sao_Paulo"** e hostname **"just4play"**
Esse script instala o sistema operacional, com o kernel personalizado para a BC-250, além da interface gráfica.  
  
## Configuração do bootloader
O bootloader usado nesse conjunto de scripts é o limine, essa escolha é para manter a aderência com alguns scripts feitos para o CachyOS, que são largamente utilizados na comunidade entusiasta da BC-250.  
  
A execução é simples e o único parâmetro é o disco do sistema (tal como o script de configuração de disco).  

Use o seguinte comando para identificar o disco onde se pretende realizar a instalação:

> **fdisk -l**

Supondo do que disco seja um NVME identificado como **"/dev/nvme0n1"** a execução do script seria:  
  
> **./4-set-limine.sh /dev/nvme0n1**  
  
## Configuração do usuário
O script **"5-set-user.sh"** se executado sem qualquer parâmetro entrega:  
  
  - Um usuário chamado **"arch"**, com a descrição **"Arch User"**;  
  - Usuário **"root"** e **"arch"** com a mesma senha **"archlinux"**;  
  
Para alterar qualquer um dessas opções, podemos passá-los como parâmetros:  

> Modo de uso: ./5-set-user.sh [opções]  
> Opções:  
> -u, --user VALOR&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;# Username - default arch  
> -c, --displayname VALOR # Nome completo - default Arch Linux  
> -p, --password VALOR&nbsp;&nbsp;&nbsp;&nbsp;# Password - default archlinux  
> -h, --help&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;# Display this help message  
  
> Ex.:  
> **./5-set-user.sh -u palmeiras -c 'Palestra Itália' -p 'P@ssw0rd'**  
  
Além da configuração dos usuários, esse script entrega:  
  
  - Usuário com privilégio de sudo  
  - Arquivo de configuração do Alacritty já na pasta do usuário  
  - KDE/Plasma configurado em inglês, mas com unidades, métricas e parâmetros regionais em **"pt-BR"**
  - Instala um pacote de ícones [Tela-icon-theme](https://github.com/vinceliuice/Tela-icon-theme)
  - Alguns wallpapers do Arch copiados para a pasta **"~/Pictures"**
  - Copia todos esses scripts para a pasta **"~/Arch-BC250"**  
  
## Scripts adicionais
Como dito logo acima, a pasta que foi feito o download do github **"Arch-BC250"** é copiada para o **"~/"** (home do usuário).  
Dentro dessa pasta temos uma outra **"~/Arch-BC250/scripts"** que contém três deles a serem executados após o login no KDE/Plasma, são eles:  
  
  - **"yay.sh"** que faz a instalação do gerenciador de pacotes do AUR.  
```
~/Arch-BC250/scripts/yay.sh  
```  
  
  - **"config-limine.sh"** que termina de fazer a configuração limine e integra aos snapshots do BTRFS.  
```  
sudo ~/Arch-BC250/scripts/config-limine.sh
```
  
  - **"gaming-setup.sh"** Instala a **"Steam"**, **"retroarch"** e o **"ES-DE"**, além do modo gaming no login.  
```
~/Arch-BC250/scripts/gaming-setup.sh
```
