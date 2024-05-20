# Guide: Flashing Jetson Motherboard Xavier NX to run YOLOv8
## Summary
This Repo provides a solution to transfer the whole file system of Xavier NX from emmc memory (onboard), to external devices.

## 
This repo is forked, with some modification added.
I have successfully used this method to alter my boot device from emmc mem to a thumb drive(actually SD card with adapter).

It is on a industrial-distribution Xavier-NX board, no nvme slot available, and TF slot is not functionin somehow.
## Prerequisites
1. We use NVIDIA SDK manager to flash Xavier-NX, the user guide is provided by Nvidia, which is sort of easy to use.
2. My board does not support NVmE device

## Bullet points
### 1. Jetpack 4 is not able to run yolov8 since its python version does not meet the requirements (>=3.8)
Although some other alternatives such as a certain .whl is provided by some developer to install ultralytics on python3.6, the Jetpack 4 faces errors on the version of torch and torchvision, though it's checked right.

### 2. Flashing Jetpack 6 to Xavier NX is tricky:
a. The on board memory is not sufficient for all the required packages. The SDK componenets need to be installed after we alter the boot driver to some larger devices.

b. Transferring the whole filesystem to ext devices is what we mostly do here.

# Notice
## Flashing Xavier to new Jetpack
1. Nvidia provides detailed manual, check the website.
2. Do not flash the SDK components before altering the boot device
## Altering boot device
1. Make sure, the external storage device is formatted into ext4 filesystem, GPT is created. 
2. Make sure the device is partitioned. Use the gparted as described as in other blogs, (I usually partition into 1 partition). 
3. When mounting the external device, we need to use the /dev/sdb1 instead of /dev/sdb. (example) We use the partition. 
4. Make sure the connection of external device is very ok.
# **Very important**: change the target device to your own: 

1. line 4 in copy-rootfs-ssd.sh
2. line 4 in data/setssdroot.sh

 

You need to make sure that drive (SD card, thumb drive, or SSD) is formatted into ext4, and you have patitioned it. 
The table should be in GPT format.
Normally the disk you specify need to the partition of one disk, where you put your alt system on.


# Original Readme: rootOnNVMe
Switch the rootfs to a NVMe SSD on the Jetson Xavier NX and Jetson AGX Xavier

These scripts install a service which runs at startup to point the rootfs to a SSD installed on /dev/nvme0 (the M.2 Key M slot).

This is taken from the NVIDIA Jetson AGX Xavier forum https://forums.developer.nvidia.com/t/how-to-boot-from-nvme-ssd/65147/22, written by user crazy_yorik (https://forums.developer.nvidia.com/u/crazy_yorick). Thank you crazy_yorik!

This procedure should be done on a fresh install of the SD card using JetPack 4.3+. Install the SSD into the M.2 Key M slot of the Jetson, and format it gpt, ext4, and setup a partition (p1). The AGX Xavier uses eMMC, the Xavier NX uses a SD card in the boot sequence.



Next, copy the rootfs of the eMMC/SD card to the SSD
```
$ ./copy-rootfs-ssd.sh
```

Then, setup the service. This will copy the .service file to the correct location, and install a startup script to set the rootfs to the SSD.
```
$ ./setup-service.sh
```

After setting up the service, reboot for the changes to take effect.

### Boot Notes
These script changes the rootfs to the SSD after the kernel image is loaded from the eMMC/SD card. For the Xavier NX, you will still need to have the SD card installed for booting. As of this writing, the default configuration of the Jetson NX does not allow direct booting from the NVMe.

### Upgrading
Once this service is installed, the rootfs will be on the SSD. If you upgrade to a newer version of L4T using OTA updates (using the NVIDIA .deb repository), you will need to also apply those changes to the SD card that you are booting from.

Typically this involves copying the /boot* directory and /lib/modules/\<kernel name\>/ from the SSD to the SD card. If they are different, then modules load will be 'tainted', that is, the modules version will not match the kernel version.


## Notes
* Initial Release, May 2020
* JetPack 4.4 DP
* Tested on Jetson Xavier NX

