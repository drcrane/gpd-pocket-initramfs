Building an EFI Bootable Drive with Gentoo Linux
================================================

These instructions were written for the GPD Pocket but should work with other 
devices.

Step 1
------

Get the kernel sources:

    emerge -pv gentoo-sources

Step 2
------

Configure your sources:

    cd /usr/src/linux-xx.xx.xx
    make menuconfig

Step 3
------

Build your kernel and all the modules.

    make -j4

Step 4
------

Copy all the modules into a specific directory (the built kernel is not for the 
host system so there is no need to install them locally).

    make INSTALL_MOD_STRIP=1 INSTALL_MOD_PATH=/usr/src/modules-4.20.0-gentoo modules_install

Alter the version, of course.

Step 5
------

Setup the `config.sh` file for the right kernel version and locations.

Step 6
------

Build the ramfs (do this from the directory this file is located):

    ./buildinitramfs.sh

Kernel Configurations
=====================

In `kernelconfig/` there are some known working configuration files.
I hope to create releases of the kernel, firmware and modules to make
anyone else's life a little easier who wishes to use Gentoo on the
GPD Pocket.

* `kernel-config-x86_64-4.19.4-gentoo`
* `kernel-config-x86_64-4.20.0-gentoo`

References
----------

* [Gentoo Wiki: GPD Pocket](https://wiki.gentoo.org/wiki/GPD_Pocket)
* [Gentoo Wiki: Custom Init RAM FS](https://wiki.gentoo.org/wiki/Custom_Initramfs)

