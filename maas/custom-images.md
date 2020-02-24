# How to use custom images in MAAS

## Cloud image

1. Mount image file
```
mkdir -p /tmp/target
sudo mount -o loop bionic-server-cloudimg-amd64.img /tmp/target 
```
Note that the image is not writable. To have it writable, you can use virt-install.

2. Create tarball:
```
sudo tar zcpf bionic-server-cloudimg-amd64.tgz -C /tmp/target .
```
3. Import image into MAAS
```
maas ubuntu boot-resources create name=custom/custom-bionic architecture=amd64/generic content@=./bionic-server-cloudimg-amd64.tgz
```

**NB:**
This works only with Curtin supported distros, consult [distro.py](https://git.launchpad.net/curtin/tree/curtin/distro.py?h=ubuntu/bionic#n25)

## virt-install

1. Create raw disk
```
qemu-img create -f raw /var/lib/libvirt/images/disk.img 2G
```

2. Install OS
```
sudo virt-install \
--disk path=/var/lib/libvirt/images/disk.img,format=raw \
--name tmp-builder \
--ram 1024 \
--arch x86_64 \
--vcpus 1 \
--os-type linux \
--network bridge=virbr0 \
--cdrom mini.iso
```

3. Undefine VM
virsh undefine tmp-builder

4. Mount the image, edit as necessary

5. Create tarball

6. Import into MAAS


