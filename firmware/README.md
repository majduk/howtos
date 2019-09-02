# Firmware update procedures for various type of servers

## Cisco UCS

**Note:** This requires Cisco support account to download firmware image.

``` http_proxy= https_proxy= \
python update_firmware-4.0.2c.py --user admin --password <pass> --address <CMIC IP> --remoteshareip <CMIC IP> \
--sharedirectory /fw-upgrade / --imagefile ucs-c240m5-huu-4.0.4f.iso  --sharetype www --componentlist all
```

Vesrion:
```
C240-WZP21470035# show cimc/firmware   
Update Stage Update Progress Current FW Version 
------------ --------------- ------------------ 
NONE         100             3.1(2c)   
```

Expect script:
```
#!/usr/bin/expect -f
spawn ssh admin@100.100.191.15
expect "password: "
send "<password>\r"
expect "# "
send "show cimc/firmware\r"
expect "# "
send "exit\r"
```


**References:**
- https://www.cisco.com/c/en/us/td/docs/unified_computing/ucs/release/notes/b_UCS_C-Series_RN_4_0_2.html
- https://community.cisco.com/t5/unified-computing-system/cisco-standalone-c-series-huu-utilities/ta-p/3638543
