#!/bin/sh

set -e

busybox mkdir -p /tmp
busybox mkdir -p /proc
busybox mkdir -p /sys
busybox mkdir -p /dev
busybox mkdir -p /etc/ssl

busybox mount -t proc proc /proc
busybox mount -t sysfs sysfs /sys
busybox mount -t tmpfs none /dev

busybox mdev -s

busybox sysctl -w kernel.printk="3 4 1 3"

busybox ifconfig lo 127.0.0.1

