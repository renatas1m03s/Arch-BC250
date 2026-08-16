function mov2mp4
    if test (count $argv) = 1
        ffmpeg -i $argv[1].mov -c:a aac -b:a 256k -ar 44100 -c:v libx264 -pix_fmt yuv420p -preset medium -f mp4 $argv[1].mp4
    else
        printf "Use mode: mov2mp4 file"
    end
end
