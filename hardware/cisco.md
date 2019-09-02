# Set boot order:

## SSH
```
ubuntu@infra2:~/test-deploy$ ssh admin@<ip>
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

## API
https://www.cisco.com/c/en/us/td/docs/unified_computing/ucs/c/sw/api/2-0/b_Cisco_IMC_api_2_0/b_Cisco_IMC_api_2_0_appendix_0110.html#reference_9DBE7486B7EE4F399398645FEC9333D9__section_7CA5342DFD88411F9FB4F7731DF79DDA

## IPMI

