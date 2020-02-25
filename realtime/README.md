1. Download kernel and patch

- [kernel](https://www.kernel.org/pub/linux/kernel/)
- [rt patch](https://www.kernel.org/pub/linux/kernel/projects/rt/)

Note that the version of rt patch and kernel should be same. For example linux-5.4.19.tar.gz and patch-5.4.19-rt11.patch.gz.

2. Extract kernel sources and patch rt kernel
```
$ cd ~/kernel
$ tar xvzf linux-5.4.19.tar.gz
```
Patch rt kernel
```
$ cd linux-5.4.19
$ gzip -cd ../patch-5.4.19-rt11.patch.gz | patch -p1 --verbose {}
```
3. Install required packages

For using menuconfig GUI, libncurses-dev is required. flex and bison will be needed when you compile the kernel.

```
$ sudo apt install libncurses-dev libssl-dev
$ sudo apt install flex bison
```

4. Configure kernel for RT
```
$ make menuconfig
and enter the menuconfig GUI.

# Make preemptible kernel setup
General setup ---> [Enter]
Preemption Model (Voluntary Kernel Preemption (Desktop)) [Enter]
Fully Preemptible Kernel (RT) [Enter] #Select

# Select <SAVE> and <EXIT>
# Check .config file is made properly
```
Note that there’s no Check for stack overflows option on GUI configuration anymore. You can check it by searching “overflow”. Type / and overflow on Graphical Menu.

5. Compile the kernel
```
$ make -j20
$ sudo make modules_install -j20
$ sudo make install -j20
```
6. Make kernel images lighter

Big initrd image can occur kernel panic. So you can resolve this problem by:
Strip unneeded symbols of object files
```
$ cd /lib/modules/5.4.19-rt11
$ sudo find . -name *.ko -exec strip --strip-unneeded {} +
```
Change the compression format
```
$ sudo vi /etc/initramfs-tools/initramfs.conf
# Modify COMPRESS=lz4 to COMPRESS=xz 

COMPRESS=xz 
```

update initramfs:
```
$ sudo update-initramfs -u
```
7. Verify and update grub

Verify that directory and update the grub. Make sure that initrd.img-5.4.19-rt11, vmlinuz-5.4.19-rt11, and config-5.4.9-rt11 are generated in /boot
```
$ cd /boot
$ ls
```
Update grub
```
$ sudo update-grub
```

8. Reboot and verify


