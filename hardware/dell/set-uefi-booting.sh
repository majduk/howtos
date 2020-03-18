#!/bin/bash

IP="$1"
USERNAME="$2"
SSHPASS="$3"

sshpass -p "$SSHPASS" ssh -o StrictHostKeyChecking=no "$USERNAME"@"$IP" <<EOF
racadm set BIOS.BiosBootSettings.BootMode Uefi
racadm jobqueue create BIOS.Setup.1-1 -r pwrcycle -s TIME_NOW
EOF
