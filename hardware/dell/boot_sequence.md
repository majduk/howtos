
```
/admin1->

racadm set iDRAC.IPMILan.Enable 1
racadm set iDRAC.IPMILan.EncryptionKey 0000000000000000000000000000000000000000


racadm set LifecycleController.LCAttributes.LifecycleControllerState 0



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


racadm set LifecycleController.LCAttributes.LifecycleControllerState 1
racadm set nic.nicconfig.3.legacybootproto PXE
racadm set nic.nicconfig.5.legacybootproto PXE
racadm jobqueue create NIC.Integrated.1-1-1
racadm jobqueue create NIC.Slot.1-1-1

serveraction hardreset

racadm get nic.nicconfig.2.legacybootproto

---
racadm set racadm set  BIOS.NetworkSettings.PxeDev1EnDis Enabled
racadm set BIOS.PxeDev1Settings.PxeDev1Interface NIC.Slot.1-1-1
racadm jobqueue create BIOS.Setup.1-1
racadm serveraction hardreset
```

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

```
racadm get BIOS.BiosBootSettings.SetBootOrderEn
racadm set BIOS.BiosBootSettings.SetBootOrderEn NIC.PxeDevice.1-1,NIC.PxeDevice.2-1,NIC.PxeDevice.3-1,NIC.PxeDevice.4-1
racadm set BIOS.BiosBootSettings.UefiBootSeq NIC.PxeDevice.1-1,NIC.PxeDevice.2-1,NIC.PxeDevice.3-1,NIC.PxeDevice.4-1
```

Full script:
```
racadm set BIOS.NetworkSettings.PxeDev1EnDis Enabled
racadm set BIOS.PxeDev1Settings.PxeDev1Interface NIC.Integrated.1-1-1
racadm set BIOS.NetworkSettings.PxeDev2EnDis Enabled
racadm set BIOS.PxeDev1Settings.PxeDev2Interface NIC.Integrated.1-2-1
racadm set BIOS.NetworkSettings.PxeDev3EnDis Enabled
racadm set BIOS.PxeDev1Settings.PxeDev3Interface NIC.Slot.1-1-1
racadm set BIOS.NetworkSettings.PxeDev4EnDis Enabled
racadm set BIOS.PxeDev1Settings.PxeDev4Interface NIC.Slot.1-2-1
racadm set BIOS.BiosBootSettings.UefiBootSeq NIC.PxeDevice.1-1,NIC.PxeDevice.2-1,NIC.PxeDevice.3-1,NIC.PxeDevice.4-1
racadm set BIOS.BiosBootSettings.SetBootOrderEn NIC.PxeDevice.1-1,NIC.PxeDevice.2-1,NIC.PxeDevice.3-1,NIC.PxeDevice.4-1
racadm jobqueue create BIOS.Setup.1-1
racadm serveraction hardreset
```

