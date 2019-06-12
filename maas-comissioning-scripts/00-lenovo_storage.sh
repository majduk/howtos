#!/bin/bash

# storcli User Guide: https://lenovopress.com/lp0579-lenovo-raid-management-tools-and-resources
main() {
if is_storcli_mod
then
log "found - proceed"
else
log "not found - exiting"
return 0
fi

if is_storcli_util
then
log "found - proceed"
else
log "not found"
install_storcli || ( elog "StorCLI installation failed - exiting"; return 1 )
fi

log "set jbod_mode for ALL controllers"
set_allctrls_jbod_mode

log "show info for ALL controllers"
show_allctrls_info

# NOTE: was not needed so far, commented out for one less reboot
# log "Set ALL controllers to factory default settings"
# set_allctrls_factory

log "Output final SCSI info"
show_kern_SCSIinfo

log "finished"
exit 0
} # main() end

# var
scriptname="$(basename $0)"

# functions
log(){
echo "[$scriptname] $@"
}

elog(){
log "ERROR: $@" >&2
}

is_storcli_mod(){
log "checking for LSI MegaRAID kernel module"
if lsmod | awk '{print $1}'|grep -qw megaraid_sas; then
return 0
else
return 1
fi
}

install_storcli(){
log "installing storcli"

apt-get install -y storcli
}

is_storcli_util(){
log "checking for storcli utility"
storcli version > /dev/null 2>&1 && return 0 || return 1
}

rebootme(){
log "rebooting in 3..."
sleep 3
reboot
}

set_allctrls_jbod_mode(){
storcli /call set jbod=on
}

show_allctrls_info () {
storcli /call show
}

set_allctrls_factory () {
storcli /call set factory defaults
log "All RAID controllers set to factory defaults, reboot necessary...(could loop)"
rebootme
}

show_kern_SCSIinfo() {
log "------------------ system scsi debug output start ---------------------"
dmesg | egrep '\[sd[a-z]\]'
log "------------------ system scsi debug output end -----------------------"
}

main "$@"

exit 0
