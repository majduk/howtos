#!/bin/bash

# var
MYNAME="$(basename $0)"
TIMEOUT=30
YES="y"
TESTMODE="hpssacli_raid_magellan_testmode_EiPhaic5d"

# NOBOOTRAID1 is set to y if the scriptname contains "nobootraid1"
# otherwise it is always set to "n"
# sometimes it is desireable to have no hw-raid1 bootdisk but
# just a bunch of disk with the small ssds first
NOBOOTRAID1="n"

# CLAMPJOURNAL is set through the scriptname,
# if the name contains journal it is set to yes
# in all other cases "n" is the default
CLAMPJOURNAL="n"

log(){
echo "[$MYNAME] $@"
}

elog(){
log "ERROR: $@" >&2
}

# functions
is_hpsa(){
log "check for hpsa kernel module, proceed only if hpsa module is found"
if lsmod | awk '{print $1}'|grep -qw hpsa; then
return 0
else
return 1
fi
}

install_hpssacli(){
log "installing hpssacli"

apt-get -q update
apt-get -q install --force-yes -y hpssacli
}

is_hpssacli(){
hpssacli version > /dev/null 2>&1 && return 0 || return 1
}

rebootme(){
log "rebooting..."
sleep 3
reboot
}

for_all_slots(){
local slot=-1
hpssacli ctrl all show | grep -oP "Slot\s+\K\w+" | while read slot; do echo "$slot"; done
}

# set raid_mode
set_raid_mode(){
for_all_slots | while read slot; do
echo y | hpssacli ctrl slot=${slot} modify raidmode=on
done
return 0
}

# look for specific strings
is_raid_mode(){
KEY="Controller Mode:"
VALUE="RAID"
if hpssacli ctrl all show detail | grep "$KEY" | grep -qvw "$VALUE"; then
return 1
else
return 0
fi
}

# Controller Mode Reboot: Not Required
is_reboot_mode(){
KEY="Controller Mode Reboot:"
VALUE="Not Required"
if hpssacli ctrl all show detail | grep "$KEY" | grep -qvw "$VALUE"; then
return 0
else
return 1
fi
}

# 1: slot 2: firmware
is_firmware(){
SLOT=${1:-"0"}
FW=${2:-"4.02"}
if hpssacli ctrl slot=${SLOT} show | grep "Firmware Version" | grep -qw "$FW"; then
# found version FW
return 0
else
return 1
fi
}

string_contains(){
local SIGNAL=${1}
local SEARCHSTRING=${2}
if echo ${SEARCHSTRING} | grep -q "${SIGNAL}" > /dev/null 2>&1; then
return 0
else
return 1
fi
}

stringvar_equals(){
local SIGNAL=${1}
local SEARCHVAR=${2}
if test "${!SEARCHVAR}" = "${SIGNAL}" ; then
return 0
else
return 1
fi
}

# main
#
# program flow is:
#
# 1. check if every controller is set to raid mode
#	if not set to raid mode and reboot
#
# 2. if every controller is in raid mode:
#	2.1 delete all ld
#	2.2 configure according to trents logic

if test -x "$TESTMODE" > /dev/null 2>&1; then
. ${TESTMODE}
fi

# compatibility
if is_hpsa; then
log "found kernel hpsa driver - proceed"

#------------------------- hp sa controller present
# if hpssacli is not installed, install it
log "check for hpssacli -"
if ! is_hpssacli; then
log "... not installed"
install_hpssacli
else
log "... ok"
fi

# controller firmware 3.56 has some peculiar behaviour, it
# needs in some cases (possibly "hand" created ones) a
# capital y to destroy a ld
log "check for firmware version"
if is_firmware "0" "3.56"; then
log "found version 3.56, modified yes to capital Y"
YES="Y"
fi

# get nobootraid1
if string_contains "nobootraid1" "$MYNAME"; then
NOBOOTRAID1="y"
fi
log "nobootraid1: $NOBOOTRAID1"


# get clampjournalmode
if string_contains "journal" "$MYNAME"; then
CLAMPJOURNAL="y"
fi
log "clampjournal: $CLAMPJOURNAL"



# main loop
#
# if: raid mode -> delete old ld, configure new ld - for every controller found
# else: set raid mode and if necessary reboot

if is_raid_mode; then

# delete all ld
for_all_slots | while read slot; do
log "slot $slot: delete pre-existing logical disk arrays"
hpssacli ctrl slot=${slot} ld all delete forced
done

# This currently operates per controller.. if there are 200 - 299 GB drives on more than 1 controller this logic won't work
# Currently that is true, may not always be true, would need some more complicated logic

for_all_slots | while read slot; do

log "slot $slot: find appropiate 200-299 GB ssd disks and create boot array"
# Use the last 2x 2**ish GB drives for Boot RAID1
numdrives=2
BOOT_drives=($(hpssacli ctrl slot=${slot} pd allunassigned show|egrep "physicaldrive.*[^0-9]{1}2[0-9][0-9]([.][0-9]+){0,1} GB"|tail -n${numdrives}|awk '{print $2}'))
if [ ${#BOOT_drives[@]} -gt 0 ]; then
BOOT_list=$(printf "%s," "${BOOT_drives[@]}")
if stringvar_equals "n" "NOBOOTRAID1"; then
log "slot $slot: <$BOOT_list> into boot raid1"
hpssacli ctrl slot=${slot} create type=ld raid=1 drives=${BOOT_list} forced
else
log "slot $slot: <$BOOT_list> into single raid0 each for first 2 boot disks (sda and sdb)"
hpssacli ctrl slot=${slot} create type=arrayr0 drives=${BOOT_list} forced
fi
fi

# find remaining 2**ish GB SSDs
CEPH_drives=($(hpssacli ctrl slot=${slot} pd allunassigned show|egrep "physicaldrive.*[^0-9]{1}2[0-9][0-9]([.][0-9]+){0,1} GB"|awk '{print $2}'))
if [ ${#CEPH_drives[@]} -gt 0 ]; then
CEPH_list=$(printf "%s," "${CEPH_drives[@]}")
if stringvar_equals "y" "CLAMPJOURNAL" ; then
log "slot $slot: clamp is set ($CEPH_list -> one journal raid0)"
hpssacli ctrl slot=${slot} create type=ld raid=0 drives=${CEPH_list} forced
else
log "slot $slot: clamp is not set ($CEPH_list -> single raid0 each remaining ssd, so it appears before rotary disks)"
hpssacli ctrl slot=${slot} create type=arrayr0 drives=${CEPH_list} forced
fi
fi

done

for_all_slots | while read slot; do
log "slot $slot: debug output start"
log "slot $slot: remaining drives (if any) as single raid0 each"
# Create single-disk RAID0 for each remaining drive. Do this last to ensure the root drive is first.
hpssacli ctrl slot=${slot} create type=arrayr0 drives=allunassigned forced
log "slot $slot: ------------------ hp raid debug output start ---------------------"
hpssacli ctrl slot=${slot} pd all show
log "slot $slot: ------------------ hp raid debug output end -----------------------"
done

# not raid mode on every controller
else

if set_raid_mode; then
log "set controller to RAID mode - rebooting"
rebootme
else
echo "could not set controller to RAID mode - error (could loop, rebooting anyway)...."
log $TIMEOUT
rebootme
fi

fi

# gather system debug data
log "slot $slot: ------------------ system scsi debug output start ---------------------"
dmesg | egrep '\[sd[a-z]\]'
log "slot $slot: ------------------ system scsi debug output end -----------------------"

# check if the controller deems a reboot necessary - for whatever reason
# and reboot (this should not be the case)
if is_reboot_mode; then
log "reboot deemed necessary...(could loop)"
rebootme
else
echo "Ok"
fi


#------------------------- hp sa controller absent
# no hpsa found
else
log "no hpsa kernel module found - exiting"
fi


exit 0
