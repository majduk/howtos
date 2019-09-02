#!/usr/bin/expect -f

set host [lindex $argv 0]
set pass [lindex $argv 1]

spawn ssh $host
expect "password: "
send "$pass\r"
expect "# "
send "scope bios\r"
expect "# "
send "set boot-order pxe,hdd\r"
expect "# "
send "commit\r"
expect "# "
