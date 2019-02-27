# How to create LVM based storage pool for LXD

## Prerequisites

- This tutorial requires LXD > 2.11
- Installation in xenial: `sudo apt install -t xenial-backports lxd lxd-client`
- Install prerequirement for thin provisioning `apt-get install thin-provisioning-tools -y`

## Configuration
1. Create physical volumes

```
ubuntu@kearns-vm4:~# sudo pvcreate /dev/vdb
  Physical volume "/dev/vdb" successfully created
ubuntu@kearns-vm4:~# sudo pvcreate /dev/vdc
  Physical volume "/dev/vdc" successfully created
ubuntu@kearns-vm4:~# sudo pvcreate /dev/vdd
  Physical volume "/dev/vdd" successfully created
ubuntu@kearns-vm4:~# sudo pvcreate /dev/vde
  Physical volume "/dev/vde" successfully created

ubuntu@kearns-vm4:~# sudo pvs
  PV         VG   Fmt  Attr PSize  PFree 
  /dev/vdb        lvm2 ---  10.00g 10.00g
  /dev/vdc        lvm2 ---  10.00g 10.00g
  /dev/vdd        lvm2 ---  10.00g 10.00g
  /dev/vde        lvm2 ---  10.00g 10.00g
```

2. Create volume group

```
ubuntu@kearns-vm4:~# sudo vgcreate lxddata /dev/vdb /dev/vdc /dev/vdd /dev/vde
  Volume group "lxddata" successfully created
  
ubuntu@kearns-vm4:~# sudo vgs
  VG      #PV #LV #SN Attr   VSize  VFree 
  lxddata   4   0   0 wz--n- 39.98g 39.98g  
```

3. Configure LXD to use LVM storage pool

```
ubuntu@kearns-vm4:~⟫ lxc storage create lvmpool lvm source=lxddata lvm.thinpool_name=lxddata
Storage pool lvmpool created

ubuntu@kearns-vm4:~⟫ lxc storage list
+---------+-------------+--------+------------------------------------+---------+
|  NAME   | DESCRIPTION | DRIVER |               SOURCE               | USED BY |
+---------+-------------+--------+------------------------------------+---------+
| default |             | dir    | /var/lib/lxd/storage-pools/default | 3       |
+---------+-------------+--------+------------------------------------+---------+
| lvmpool |             | lvm    | lxddata                            | 0       |
+---------+-------------+--------+------------------------------------+---------+
```

**Optional**
4.  Set up new pool as the default

```
ubuntu@kearns-vm4:~⟫ lxc profile edit default
.
.
.
  root:
    path: /
    pool: lvmpool #--> pool name
    type: disk

```

## Test

Make sure your new containers use the pool:
```
ubuntu@kearns-vm4:~⟫ lxc storage show lvmpool
config:
  lvm.thinpool_name: lxddata
  lvm.vg_name: lxddata
  source: lxddata
  volatile.initial_source: lxddata
description: ""
name: lvmpool
driver: lvm
used_by:
- /1.0/containers/juju-51b612-0 #---> this is my container 
- /1.0/images/f43e709ea5b9908098d65e6db0ac1fc9e24349ec10898765a16206179534e3a7
- /1.0/profiles/default
status: Created
locations:
- none
```
List volumes:
```
ubuntu@kearns-vm4:~⟫ sudo lvs
  LV                                                                      VG      Attr       LSize  Pool    Origin                                                                  Data%  Meta%  Move Log Cpy%Sync Convert
  containers_juju--51b612--0                                              lxddata Vwi-aotz-- 10.00g lxddata images_f43e709ea5b9908098d65e6db0ac1fc9e24349ec10898765a16206179534e3a7 20.72                                  
  images_f43e709ea5b9908098d65e6db0ac1fc9e24349ec10898765a16206179534e3a7 lxddata Vwi-a-tz-- 10.00g lxddata                                                                         9.01                                   
  lxddata                                                                 lxddata twi---tz-- 37.98g                                                                                 5.98   1.71     
```



