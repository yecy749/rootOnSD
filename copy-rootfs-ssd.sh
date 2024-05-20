#!/bin/bash
# Mount the SSD as /mnt
# My device here is /dev/sdb, so I have modified it. Check with your device id with $ fdisk -lu
sudo mount /dev/sdb /mnt
# Copy over the rootfs from the SD card to the SSD
sudo rsync -axHAWX --numeric-ids --info=progress2 --exclude={"/dev/","/proc/","/sys/","/tmp/","/run/","/mnt/","/media/*","/lost+found"} / /mnt
# We want to keep the SSD mounted for further operations
# So we do not unmount the SSD
