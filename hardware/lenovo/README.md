## BIOS performance settings  

# How to enable OS managed performance mode on ThinkSystem SR650

1. SSH to IMM and set up using ASU (`asu set ...`):
```
Processors.CPUPstateControl=Legacy
OperatingModes.ChooseOperatingMode="Custom Mode"
```

2. Configure OS:
- `systemctl disable ondemand`
- `apt update && apt install cpufrequtils -y`
- set performance mode for the CPUFreq Utility: 
`sed -i 's/^GOVERNOR=.*/GOVERNOR="performance"/' /etc/init.d/cpufrequtils `
-  `systemctl daemon-reload && systemctl reload cpufrequtils.service`
