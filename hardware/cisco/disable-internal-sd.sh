#!/usr/bin/expect -f

set host [lindex $argv 0]
set pass [lindex $argv 1]

spawn ssh $host
expect "password: "
send "$pass\r"
expect "# "
send "scope bios/input-output\r"
expect "# "
send "set UsbPortSdCard Disabled \r"
expect "# "
send "commit\r"
expect "reboot "
send "y\r"
expect "# "
