function droidcam-fullhd
sudo rmmod v4l2loopback_dc
set KERNEL (uname -r)
sudo insmod /lib/modules/$KERNEL/kernel/drivers/media/video/v4l2loopback-dc.ko width=1980 height=1080
end
