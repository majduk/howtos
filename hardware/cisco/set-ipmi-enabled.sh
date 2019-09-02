#!/usr/bin/expect -f

set host [lindex $argv 0]
set pass [lindex $argv 1]

spawn ssh $host
expect "password: "
send "$pass\r"
expect "# "
send "scope ipmi\r"
expect "# "
send "set enabled yes\r"
expect "# "
send "set encryption-key 0000000000000000000000000000000000000000\r"
expect "# "
send "commit\r"
expect "# "
