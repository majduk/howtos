# How to use custom images in MAAS

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

*NB:*
This works only with Curtin supported distros, consult [distro.py](https://git.launchpad.net/curtin/tree/curtin/distro.py?h=ubuntu/bionic#n25)
