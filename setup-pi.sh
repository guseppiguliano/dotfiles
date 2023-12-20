# http://pinout.xyz/
# increase GPU RAM to 256 MB for less lag in some programs, such as Kodi

sudo raspi-config
# enable ssh on boot with Interfacing options -> ssh -> Enable

# other ways to enable ssh:
sudo systemctl enable ssh
touch /boot/ssh

# do not wait forever for the network on boot
sudo vim /etc/systemd/system/network-online.targets.wants/networking.service
# lower TimeoutStartSec

# disable wifi power management (for more stable wifi)
sudo vim /etc/network/interfaces
iface wlan0 inet manual
    wireless-power off

# start kodi on startup (this just puts the line "@kodi" at the top of the file)
sudo sed -i "1i @kodi" /etc/xdg/lxsession/LXDE-pi/autostart

# hide the mouse cursor when idle
echo "@unclutter -root" | sudo tee -a /etc/xdg/lxsession/LXDE-pi/autostart

# remove prompt when double-clicking executable file (e.g. .desktop files)
# open a folder, then Edit -> Preferences -> [x] Don't ask options on launch executable file

# 7 inch display GPIO: https://www.modmypi.com/image/data/tutorials/raspberry-pi-7-touch-screen-assembly-guide/16.jpg
# Red    – 5V  - Pin 2
# Black  – GND - Pin 6
# Green  – SDA - Pin 3
# Yellow – SCL - Pin 5

# rotate display output
sudo vim /boot/config.txt
lcd_rotate=2

# change pi display brightness on boot
sudo vim /etc/rc.local
echo 90 > /sys/class/backlight/rpi_backlight/brightness

# RTC
sudo vim /boot/config.txt
dtoverlay=i2c-rtc,ds3231
sudo reboot
# optional:
echo i2c-dev | sudo tee -a /etc/modules
sudo modprobe i2c-dev
sudo apt install i2c-tools
sudo i2cdetect -y 1
# remove fake-hwclock
sudo apt-get -y remove fake-hwclock
sudo update-rc.d -f fake-hwclock remove
sudo vim /lib/udev/hwclock-set
# comment out the following:
#if [ -e /run/systemd/system ] ; then
# exit 0
#fi

# read from hwclock
sudo hwclock -r
# write system time to hwlock
sudo hwclock -w

# 24 hour clock with "date" command (requires log out and log in to take effect)
localectl set-locale LC_TIME="en_GB.UTF-8"

# put swap on exfat USB drive
sudo systemctl disable dphys-swapfile
sudo dd if=/dev/zero of=/media/usb/swap count=1024 bs=1MiB
sudo mkswap /media/usb/swap
sudo swapon /media/usb/swap
# add to /etc/fstab:
/media/usb/swap    none    swap    sw    0   0


# Ubuntu
# https://blog.ubuntu.com/2019/02/27/single-node-kubernetes-on-raspberry-pi-microk8s-ubuntu
# http://cdimage.ubuntu.com/releases/18.04.2/release/
# ubuntu-18.04.2-preinstalled-server-arm64+raspi3.img.xz
# initial user/pass: ubuntu/ubuntu

# fix systemd-modules-load error on startup
sudo apt remove open-iscsi

# get rid of cloud-init junk output during boot
sudo apt remove cloud-init
