# QEMU images hacks

Dummy convert to shrink image
```
qemu-img convert  -O qcow2 disk bionic-rt.img
```

Mount image RW (requires `libguestfs-tools`):
```
sudo apt install libguestfs-tools
sudo guestmount -a bionic-rt.img -m /dev/sda1 /mnt
```

Mount image RO as loop device:
```
sudo mount -o loop bionic-rt.img /tmp/target
```

Mount image as block device - eg to update grub:
```
sudo modprobe nbd max_part=16 
sudo qemu-nbd -c /dev/nbd0 bionic-rt.img 
```
