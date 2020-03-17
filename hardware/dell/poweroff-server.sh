#!/usr/bin/expect -f

set host [lindex $argv 0]
set pass [lindex $argv 1]
set source [lindex $argv 2]
set timeout 3600
spawn ssh $host
expect "password: "
send "$pass\r"
expect ">"
send "racadm serveraction powerdown\r"
expect ">"
