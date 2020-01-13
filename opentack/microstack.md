# Microstack howto

## Configure hypervisor

1. install uvtool
```
sudo apt install uvtool
sudo apt install uvtool-libvirt
uvt-simplestreams-libvirt --verbose sync release=bionic arch=amd64
```
2. Create bridges to be used be attached to br-ex in your microstack instance. You will need 2 interfaces in your instance, hence 2 bridges are required:
- virbr0 - the default bridge created by libvirt networking
- msbr0 - bridge to handle microstack networking. Both microstack and any VMs consuming Microstack services will be connected to that bridge. It will carry addressation of microstack: 10.20.20.0/24 

Optionally in order to allow access from the hypervisor to Microstack, add address to msbr0, eg: 
```
ubuntu@physical:~$ ip a s msbr0
24: msbr0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
    link/ether 06:3c:89:82:29:65 brd ff:ff:ff:ff:ff:ff
    inet 10.20.20.254/24 brd 10.20.20.255 scope global msbr0
       valid_lft forever preferred_lft forever
    inet6 fe80::43c:89ff:fe82:2965/64 scope link 
       valid_lft forever preferred_lft forever
```

## Create Microstack instance

1. Launch microstack instance
```
uvt-kvm create microstack \
--memory 8192 \
--cpu 2 \
--disk 40 \
--bridge virbr0
```
2. Wait for instance to boot up
```
uvt-kvm wait microstack
```

3. Attach msbr0 interface to the microstack VM:
```
virsh attach-interface --domain microstack --type bridge --source msbr0 --target mseth0 --model virtio --config
```
4. Reboot microstack VM

## Configure Microstack

1. Connect to the microstack VM:
```
uvt-kvm ssh microstack
```
Futher steps are done on the microstack VM.

2. Install microstack with the default settings:
```
sudo snap install microstack --classic --beta
sudo microstack.init --auto
```
Note that after the installation `br-ex` is created:
```
ubuntu@microstack:~$ ip a s br-ex
10: br-ex: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
    link/ether c6:6a:a1:4a:9c:43 brd ff:ff:ff:ff:ff:ff
    inet 10.20.20.1/24 scope global br-ex
       valid_lft forever preferred_lft forever
    inet6 fe80::c46a:a1ff:fe4a:9c43/64 scope link 
       valid_lft forever preferred_lft forever
```

Note that the VM has second, unattached interface `ens7`:
```
3: ens7: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 52:54:00:b6:d7:80 brd ff:ff:ff:ff:ff:ff
```
3. Add port to the external OVS bridge
```
sudo microstack.ovs-vsctl add-port br-ex ens7
sudo ifconfig ens7 up
```

## Test access:
Launch microstack instance:
```
root@microstack:~# microstack.launch cirros
Launching server ...
Allocating floating ip ...
Server mint-egret launched! (status is BUILD)

Access it with `ssh -i $HOME/.ssh/id_microstack cirros@10.20.20.132`
You can also visit the OpenStack dashboard at http://10.20.20.1:80
```
On the physical hypervisor you will be able to ping it and SSH to it:
```
ubuntu@physical:~$ ping 10.20.20.132
PING 10.20.20.132 (10.20.20.132) 56(84) bytes of data.
64 bytes from 10.20.20.132: icmp_seq=1 ttl=63 time=1.90 ms
^C
--- 10.20.20.132 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 1.909/1.909/1.909/0.000 ms
```
```
ubuntu@physical:~$ ssh cirros@10.20.20.132
cirros@10.20.20.132's password: 
$ ip a s
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc pfifo_fast qlen 1000
    link/ether fa:16:3e:a1:e9:aa brd ff:ff:ff:ff:ff:ff
    inet 192.168.222.210/24 brd 192.168.222.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::f816:3eff:fea1:e9aa/64 scope link 
       valid_lft forever preferred_lft forever
$ 
```

