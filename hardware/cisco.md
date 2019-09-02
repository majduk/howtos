Set boot order:
```
ubuntu@infra2:~/test-deploy$ ssh admin@<ip>
C240-WZP21470035# show 
bios               certificate        chassis            cimc               configuration      dimm-blacklisting  fault              http               
power-or-performance  processor             security              server-management     

C240-WZP21470035 /bios # show boot-device 
C240-WZP21470035 /bios # show actual-boot-order 
Boot Order   Boot Device                         Device Type     Boot Policy          
------------ ----------------------------------- --------------- -------------------- 
1            "UEFI: PXE IP4 Intel(R) Ethernet...                 NonPolicyTarget      
2            "UEFI: PXE IP4 Intel(R) Ethernet...                 NonPolicyTarget      
3            "UEFI: PXE IP4 Cisco(R) Ethernet...                 NonPolicyTarget      
4            "UEFI: PXE IP4 Cisco(R) Ethernet...                 NonPolicyTarget      
5            "UEFI: PXE IP4 Cisco(R) Ethernet...                 NonPolicyTarget      
6            "UEFI: PXE IP4 Cisco(R) Ethernet...                 NonPolicyTarget      
7            "UEFI: Built-in EFI Shell"                          NonPolicyTarget      
8            "UEFI: PXE IP4 Cisco(R) Ethernet...                 NonPolicyTarget      
9            "UEFI: PXE IP4 Cisco(R) Ethernet...                 NonPolicyTarget      
10           "UEFI: PXE IP4 Cisco(R) Ethernet...                 NonPolicyTarget      
11           "UEFI: PXE IP4 Cisco(R) Ethernet...                 NonPolicyTarget      
C240-WZP21470035 /bios # set boot-order pxe,hdd    
To manage boot-order:
- Reboot server to have your boot-order settings take place
- Do not disable boot options via BIOS screens
- If a specified device type is not seen by the BIOS, it will be removed
  from the boot order configured on the BMC
- Your boot order sequence will be applied subject to the previous rule.
  The configured list will be appended by the additional device types
  seen by the BIOS
- Legacy Boot Order configuration will disable all the active Boot Devices which will
  hide them from BIOS
C240-WZP21470035 /bios *# commit          
Changes to BIOS set-up parameters will require a reboot.
Do you want to reboot the system?[y|N]y
A system reboot has been initiated.
  
```
