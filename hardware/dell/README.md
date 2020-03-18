# How to use:
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

# Reference
racadm reference for DRAC 7:
http://downloads.dell.com/Manuals/all-products/esuprt_electronics/esuprt_software/esuprt_remote_ent_sys_mgmt/integrated-dell-remote-access-cntrllr-7-v1.30.30_Reference%20Guide_en-us.pdf?c=us&l=en&cs=555&s=biz
