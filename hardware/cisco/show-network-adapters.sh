#!/usr/bin/expect -f

set host [lindex $argv 0]
set pass [lindex $argv 1]
set timeout 10
spawn ssh $host
expect "password: "
send "$pass\r"
expect "# "
send "scope chassis\r"
expect "# "
send "show network-adapter\r"
expect "# "
#puts "The output is $expect_out(1,buffer)"
for {set i 1} {$i < 10} { incr i 1} {
  send "scope network-adapter $i\r"
  expect {
    "network-adapter # " {
      send "show mac-list\r"
      expect "network-adapter # " {
        send "exit\r"    
      }
      }
  }
}

