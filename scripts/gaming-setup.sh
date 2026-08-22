#!/bin/bash

yay -Sy --noconfirm --needed kpat steam protonplus gamescope mangohud retroarch emulationstation-de

git clone https://github.com/CachyOS/gamescope-session /tmp/gamescope-session

sudo cp -rv /tmp/gamescope-session/usr/* /usr/
