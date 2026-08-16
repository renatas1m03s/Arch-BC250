function all2mov
    if test (count $argv) = 2
        ffmpeg -i $argv[1] -vcodec mjpeg -q:v 2 -c:a pcm_s16be -f mov $argv[2]
    else
        printf "Use mode: all2mov inputmediafile.* output.mov"
    end
end
