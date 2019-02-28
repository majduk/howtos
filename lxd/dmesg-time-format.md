# How to convert timestamp in dmesg in container

Container takes kernel time from the host. Normally `dmesg.log` contains time since boot in seconds. However in case of LXD time comes also in seconds since the host boot.

So example:
dmesg in LXD:
`21067645.435402`

Translate script:
```
ut=`cut -d' ' -f1 </proc/uptime` 
ts=`date +%s` 
date -d"70-1-1 + $ts sec - $ut sec + 21067645.435402 sec" +"%F %T"
```

output: `2019-02-22 06:34:31`
