#!/bin/sh

if [ $(grep -q datadrive "/etc/fstab") ]
then
    echo "The datadrive is already added to /etc/fstab."
else
    if parted /dev/sdc --script mklabel gpt mkpart xfspart xfs 0% 100%
    then
        mkfs.xfs /dev/sdc1
        partprobe /dev/sdc1
        mkdir /datadrive
        mount /dev/sdc1 /datadrive
        DataDiskUUID=$(findmnt -fn -o UUID /dev/sdc1)
        echo "UUID=${DataDiskUUID}   /datadrive   xfs   defaults,nofail   1   2" >> /etc/fstab
        echo "Datadisk should now be added to /etc/fstab."
    else
        echo "Trouble attaching disk. Please make sure a disk is attatched to the VM."
    fi
fi
