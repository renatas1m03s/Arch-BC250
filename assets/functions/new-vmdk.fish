function new-vmdk
if test (count $argv) = 2
qemu-img create -f vmdk $argv[1] $argv[2]
else
printf "\n\n   Modo de usar: new-vmdk nome_do_arquivo size(G)\n"
printf "\n   Ex.: new-vmdk linuxtest.vmdk 80G\n\n"
end
end
