#!/usr/bin/env bash

trap ctrl_c INT

function ctrl_c() {
        echo "$(date) Interrupted"
        rm -f /tmp/ioload
}

function io_load_thread() {
  echo "$(date) Thread $$ start"
  while :
  do
    if [ -a /tmp/ioload ];then
      dd if=/dev/zero of=/var/lib/ceph/mon/largefile.$$ bs=1024 count=1000000 
      rm -f /var/lib/ceph/mon/largefile.$$ || true
    else
      rm -f /var/lib/ceph/mon/largefile.$$ || true
      echo "$(date) Thread $$ finished"
      exit 0
    fi
    echo "$(date) Thread $$ running..."
  done
}

touch /tmp/ioload
for th in {1..3};do
       io_load_thread &   
done

