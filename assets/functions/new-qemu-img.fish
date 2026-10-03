function new-qemu-img
    if test (count $argv) = 2
        qemu-img create -f qcow2 $argv[1] $argv[2]
    else
        printf "\n   Modo de usar: new-qemu-img nome_do_arquivo size(G)\n"
        printf "\n   Ex.: new-qemu-img linuxtest.img 80G\n\n"
    end
end
