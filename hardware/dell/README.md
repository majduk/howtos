# Configure server
```
export IPMI_USER=root
export IPMI_PASSWORD=calvin
dell_hosts=( 3 4 5 6 7 9 10 11 12 14 15 16 17 18 19 )
 
# All nodes will reboot after this step
for i in ${dell_hosts[*]}; do\
  ./scripts/setup/dell/configure-hardware.exp 192.168.209.$i \
$IPMI_USER $IPMI_PASSWORD;\
done
```

# Set boot order

Run above or to enable devices and then after server reboot re-run above or run set boot order:

```
export IPMI_USER=root
export IPMI_PASSWORD=calvin
dell_hosts=( 3 4 5 6 7 9 10 11 12 14 15 16 17 18 19 )
 
# All nodes will reboot after this step
for i in ${dell_hosts[*]}; do\
  ./scripts/setup/dell/enable-pxe.exp 192.168.209.$i \
$IPMI_USER $IPMI_PASSWORD;\
done
```
Wait for config applied, and run:
```
export IPMI_USER=root
export IPMI_PASSWORD=calvin
dell_hosts=( 3 4 5 6 7 9 10 11 12 14 15 16 17 18 19 )
 
# All nodes will reboot after this step
for i in ${dell_hosts[*]}; do\
  ./scripts/setup/dell/set-boot-order.exp 192.168.209.$i \
$IPMI_USER $IPMI_PASSWORD;\
done
```

# Config examples

## NIC config

Basic config:
```
racadm get nic.nicconfig 
NIC.nicconfig.1 [Key=NIC.Integrated.1-1-1#nicconfig]
NIC.nicconfig.2 [Key=NIC.Integrated.1-2-1#nicconfig]
NIC.nicconfig.3 [Key=NIC.Integrated.1-3-1#nicconfig]
NIC.nicconfig.4 [Key=NIC.Integrated.1-4-1#nicconfig]
NIC.nicconfig.5 [Key=NIC.Slot.1-1-1#nicconfig]
NIC.nicconfig.6 [Key=NIC.Slot.1-2-1#nicconfig]
NIC.nicconfig.7 [Key=NIC.Slot.1-3-1#nicconfig]
NIC.nicconfig.8 [Key=NIC.Slot.1-4-1#nicconfig]
NIC.nicconfig.9 [Key=NIC.Slot.2-1-1#nicconfig]
NIC.nicconfig.10 [Key=NIC.Slot.2-2-1#nicconfig]
```
VDR:
```
/admin1-> racadm get nic.VndrConfigPage
NIC.VndrConfigPage.1 [Key=NIC.Integrated.1-1-1#VndrConfigPage]
NIC.VndrConfigPage.2 [Key=NIC.Integrated.1-2-1#VndrConfigPage]
NIC.VndrConfigPage.3 [Key=NIC.Integrated.1-3-1#VndrConfigPage]
NIC.VndrConfigPage.4 [Key=NIC.Integrated.1-4-1#VndrConfigPage]
NIC.VndrConfigPage.5 [Key=NIC.Slot.1-1-1#VndrConfigPage]
NIC.VndrConfigPage.6 [Key=NIC.Slot.1-2-1#VndrConfigPage]
NIC.VndrConfigPage.7 [Key=NIC.Slot.1-3-1#VndrConfigPage]
NIC.VndrConfigPage.8 [Key=NIC.Slot.1-4-1#VndrConfigPage]
NIC.VndrConfigPage.9 [Key=NIC.Slot.2-1-1#VndrConfigPage]
NIC.VndrConfigPage.10 [Key=NIC.Slot.2-2-1#VndrConfigPage]

/admin1-> racadm get NIC.VndrConfigPage.5
[Key=NIC.Slot.1-1-1#VndrConfigPage]
BlnkLeds=0
#BusDeviceFunction=3B:00:00
#ChipMdl=Intel X710
#DCBXSupport=Available
#DeviceName=Intel(R) Ethernet Converged Network Adapter X710
#EnergyEfficientEthernet=Unavailable
#FCoEBootSupport=Unavailable
#FCoEOffloadSupport=Unavailable
#FlexAddressing=Available
#LinkStatus=Connected
#MacAddr=F8:F2:1E:5E:5F:00
#NWManagementPassThrough=Unavailable
#NicPartitioningSupport=Available
#OSBMCManagementPassThrough=Available
#PCIDeviceID=1572
#PXEBootSupport=Available
#RXFlowControl=Available
#TOESupport=Unavailable
#TXBandwidthControlMaximum=Available
#TXBandwidthControlMinimum=Available
#TXFlowControl=Available
VirtMacAddr=00:00:00:00:00:00
#iSCSIBootSupport=Available
#iSCSIDualIPVersionSupport=Unavailable
#iSCSIOffloadSupport=Unavailable
```

## BIOS settings
```
/admin1-> racadm get bIOS.BiosBootSettings
[Key=BIOS.Setup.1-1#BiosBootSettings]
BootMode=Uefi
BootSeq=
BootSeqRetry=Enabled
GenericUsbBoot=Disabled
#HddFailover=Disabled
HddPlaceholder=Disabled
HddSeq=
SetBootOrderDis=
SetBootOrderEn=RAID.Integrated.1-1,NIC.PxeDevice.1-1,NIC.PxeDevice.2-1,NIC.PxeDevice.3-1,NIC.PxeDevice.4-1
SetBootOrderFqdd1=
...
UefiBootSeq=RAID.Integrated.1-1,NIC.PxeDevice.1-1,NIC.PxeDevice.2-1,NIC.PxeDevice.3-1,NIC.PxeDevice.4-1
```

## One time boot order
```
racadm set BIOS.BiosBootSettings.UefiBootSeq NIC.PxeDevice.1-1,NIC.PxeDevice.2-1,NIC.PxeDevice.3-1,NIC.PxeDevice.4-1
```

# How to upgrade firmware on Dell:

https://www.dell.com/support/article/us/en/19/sln296648/using-the-virtual-media-function-on-idrac-6-7-8-and-9?lang=en

Wnen done, use fw-update.exp. This expects TFTP server running with fir,ware image.

# Reference
racadm reference for DRAC 7:
http://downloads.dell.com/Manuals/all-products/esuprt_electronics/esuprt_software/esuprt_remote_ent_sys_mgmt/integrated-dell-remote-access-cntrllr-7-v1.30.30_Reference%20Guide_en-us.pdf?c=us&l=en&cs=555&s=biz
