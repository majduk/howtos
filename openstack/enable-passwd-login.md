# How to enable password login on ubuntu cloud images

Use Openstack customisation script and paste:
```
#cloud-config
hostname: dc-router-vm
password: ubuntu
ssh_pwauth: true
```
