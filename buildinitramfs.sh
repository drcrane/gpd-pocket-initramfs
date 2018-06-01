#!/bin/bash
# set -x
set -e

. config.sh

INITRAMFS=initramfs-${KERNEL_VERSION}
INITRAMFSDIR=${BASEDIRECTORY}/${INITRAMFS}

if [[ ! -d ${INITRAMFSDIR} ]] ; then

	mkdir ${INITRAMFSDIR}
	cd ${INITRAMFSDIR}

	BUSYBOX=`which busybox`
	if [[ ! -f ${BUSYBOX} ]] ; then
		echo "No busybox found, cannot continue"
		exit 1
	fi
	mkdir initramfs-${KERNEL_VERSION}
	cd initramfs-${KERNEL_VERSION}
	for dir in "bin" "dev" "etc" "lib" "lib64" "mnt/root" "proc" "root" "sbin" "sys" ; do
		mkdir -p ${dir}
	done

	cp ${BUSYBOX} bin/
	cp "${SCRIPT_DIRECTORY}/ter-128b.psf.gz" root/
	cp "${SCRIPT_DIRECTORY}/ter-132n.psf.gz" root/

	mknod dev/console c 5 1
	mknod dev/null c 1 3
	mknod dev/sda b 8 0
	mknod dev/sda1 b 8 1
	mknod dev/sda2 b 8 2
	mknod dev/sda3 b 8 3
	mknod dev/tty c 5 0

fi

KERNELMODULESBASE=${BASEDIRECTORY}/modules-${KERNEL_VERSION}/lib/modules/
INITRAMFSMODULESBASE=${BASEDIRECTORY}/initramfs-${KERNEL_VERSION}/lib/modules/

declare -a modules=(
"kernel/drivers/usb/storage/usb-storage.ko"
"kernel/drivers/usb/host/xhci-pci.ko"
"kernel/drivers/usb/host/xhci-hcd.ko"
"kernel/drivers/usb/host/ohci-pci.ko"
"kernel/drivers/usb/host/ohci-hcd.ko"
"kernel/drivers/usb/host/ehci-pci.ko"
"kernel/drivers/usb/host/ehci-hcd.ko"
"kernel/drivers/mmc/core/mmc_block.ko"
"kernel/drivers/mmc/core/mmc_core.ko"
"kernel/drivers/mmc/host/sdhci.ko"
"kernel/drivers/mmc/host/sdhci-acpi.ko"
"kernel/drivers/mmc/host/sdhci-pci.ko"
"kernel/drivers/block/loop.ko"
)

for i in "${modules[@]}"
do
    if [[ ! -f ${INITRAMFSMODULESBASE}${KERNEL_VERSION}/$i ]] ; then
    	echo "Could not find ${INITRAMFSMODULESBASE}${KERNEL_VERSION}/$i"
        continue
    fi
    destdir=`dirname ${INITRAMFSMODULESBASE}${KERNEL_VERSION}/$i`
    if [[ ! -d $destdir ]] ; then
        mkdir -p $destdir
    fi
    cp "${KERNELMODULESBASE}${KERNEL_VERSION}/$i" "${INITRAMFSMODULESBASE}${KERNEL_VERSION}/$i"
done

cd "${INITRAMFSDIR}"
find . -print0 | cpio --null -ov --format=newc | gzip -9 > $BASEDIRECTORY/initramfs-${KERNEL_VERSION}.cpio.gz


