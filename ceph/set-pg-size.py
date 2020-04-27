#!/usr/bin/env python3
from subprocess import check_output

# This is not a production grade setting.

cmd_format = "ceph osd pool set {pool} {size_type} {size}"
pools_raw  = check_output("ceph osd lspools", shell=True).decode("utf-8")
for p in pools_raw.split(','):
    if len(p) > 3:
        pa = p.split(" ")
        pool = pa[1]
        for type in ['min_size', 'size']:
            cmd = cmd_format.format(pool=pool, size_type = type, size = 1) 
            print( check_output(cmd, shell=True) )
