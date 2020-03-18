# MegaCLI RAID tool

## Install

```
# Add GPG signatures
wget -O - https://hwraid.le-vert.net/debian/hwraid.le-vert.net.gpg.key | sudo apt-key add -
# Add Package Repo
echo "deb http://hwraid.le-vert.net/ubuntu xenial main" | sudo tee -a /etc/apt/sources.list.d/hwraid.list
# Upgrade and Install
sudo apt-get update
sudo apt-get install megacli
```

## Usage

List physical drives:
```
$ megacli -PDList -a0
Adapter #0

Enclosure Device ID: 32 --> used for PhysDrv location
Slot Number: 0 --> used for PhysDrv location
Drive's position: DiskGroup: 0, Span: 0, Arm: 0
Enclosure position: 1
Device Id: 0
WWN: 5000C500AEA08BDC
Sequence Number: 2
Media Error Count: 0
Other Error Count: 0
Predictive Failure Count: 0
Last Predictive Failure Event Seq Number: 0
PD Type: SAS
... 
```

Convert drive to JBOD:
```
megacli -PDMakeJBOD -PhysDrv[32:6] -a0
```
Where: 32 - enclosure ID, 6 - Enclosure Slot

## Reference:
- [Cheat Sheet](http://www.vmwareadmins.com/megacli-working-examples-cheat-sheet/)

