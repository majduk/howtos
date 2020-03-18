#!/usr/bin/expect -f

set host [lindex $argv 0]
set pass [lindex $argv 1]

spawn ssh $host
expect "password: "
send "$pass\r"
expect ">"
send "racadm get NIC.VndrConfigPage.1\r"
expect ">"
send "racadm get NIC.VndrConfigPage.2\r"
expect ">"
send "racadm get NIC.VndrConfigPage.3\r"
expect ">"
send "racadm get NIC.VndrConfigPage.4\r"
expect ">"
send "racadm get NIC.VndrConfigPage.5\r"
expect ">"
send "racadm get NIC.VndrConfigPage.6\r"
expect ">"
send "racadm get NIC.VndrConfigPage.7\r"
expect ">"
send "racadm get NIC.VndrConfigPage.8\r"
expect ">"
send "racadm get NIC.VndrConfigPage.9\r"
expect ">"
send "racadm get NIC.VndrConfigPage.10\r"
expect ">"
