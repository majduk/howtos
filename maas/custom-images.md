# How to use custom images in MAAS

## Cloud image

1. Create disk based on cloud image
```
sudo qemu-img create -f qcow2 -b bionic-server-cloudimg-amd64.img custom.img
sudo qemu-img resize custom.img 2G
```

2. Boot a dummy machine based on this disk

First create metadata:
```
cat >meta-data <<EOF
local-hostname: instance-1
EOF
```
```
cat >user-data <<EOF
#cloud-config
users:
  - name: ubuntu
    ssh-authorized-keys:
      - $PUB_KEY
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    groups: sudo
    shell: /bin/bash
runcmd:
  - echo "AllowUsers ubuntu" >> /etc/ssh/sshd_config
  - restart ssh
EOF
```
Generate ISO image:
```
sudo genisoimage  -output cidata.iso -volid cidata -joliet -rock user-data meta-data
```

Create and start the VM:
```
virt-install --connect qemu:///system --virt-type kvm --name instance-1 --ram 1024 --vcpus=1 --os-type linux --os-variant ubuntu18.04 --disk path=custom.img,format=qcow2 --disk cidata.iso,device=cdrom --import --network network=default --boot hd --console pty,target_type=serial --nographics --noautoconsole 
```

Alternatively you can just mount the filesystem if the changes does not require runnign target:
```
sudo guestmount -a custom.img -m /dev/sda1 /mnt
```

3. Conntect to the machine and make changes.

4. Stop the machine and undefine the domain.

5. Mount image file
```
sudo mkdir -p /tmp/target
sudo mount -o loop custom.img /tmp/target 
```
Note that the image is not writable. This is why guestmount would be required. 

2. Create tarball:
```
sudo tar zcpf custom-image.tgz -C /tmp/target .
```
3. Import image into MAAS
```
maas ubuntu boot-resources create name=custom/custom-image architecture=amd64/generic content@=./custom-image.tgz
```

**NB:**
This works only with Curtin supported distros, consult [distro.py](https://git.launchpad.net/curtin/tree/curtin/distro.py?h=ubuntu/bionic#n25)



