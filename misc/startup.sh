#!/bin/sh

mount -t proc proc /proc
mount -t sysfs sysfs /sys
mount -t devtmpfs devtmpfs /dev
busybox --install -s

sysctl -w kernel.printk="3 4 1 3"
ifconfig lo 127.0.0.1

echo Waiting to mount ROCKET
wait=0
while [ $wait -lt 15 ]
do
    bootpart=$(blkid | sort | grep -m1 'LABEL="ROCKET"' | grep -o ^[^:]*)
    if [ -n "$bootpart" ]
    then
        mkdir -p /disk/boot
        mount $bootpart /disk/boot -o ro
        echo "ROCKET ($bootpart) mounted read-only at /disk/boot"
        break
    fi
    wait=$((wait+1))
    sleep 1
done
if [ -f /disk/boot/rocket-startup.sh ]
then
    echo Running /disk/boot/rocket-startup.sh
    /disk/boot/rocket-startup.sh
fi

