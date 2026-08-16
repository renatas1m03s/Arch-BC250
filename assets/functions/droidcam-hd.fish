function droidcam-hd
sudo rmmod v4l2loopback_dc
set KERNEL (uname -r)
sudo insmod /lib/modules/$KERNEL/kernel/drivers/media/video/v4l2loopback-dc.ko width=1280 height=720
end
