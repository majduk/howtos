#!/usr/bin/expect -f

set host [lindex $argv 0]
set pass [lindex $argv 1]

spawn ssh $host
expect "password: "
send "$pass\r"
expect "> "
send "racadm set iDRAC.IPMILan.Enable 1\r"
expect "> "
send "racadm set iDRAC.IPMILan.EncryptionKey 0000000000000000000000000000000000000000\r"
expect "> "
