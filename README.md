<<<<<<< HEAD
# OPNsense

## About
This is a PowerShell module that leverages the OPNsense api to manage an [OPNsense](https://opnsense.org/) open source firewall appliances. The development of both OPNsense and this PowerShell module is still very much ongoing, so additional functionality will be added as these projects mature.

## Supported Modules
Currently there are api hooks for these OPNsense modules:
- **CaptivePortal**
- **Core (Firmware and Packages)**
- **Cron**
- **Diagnostics**
- **IDS**
- **Proxy**
=======
# PS_OPNsense

## About
This is a PowerShell module that leverages the OPNsense api to manage an [OPNsense](https://opnsense.org/) open source firewall appliance. The development of both OPNsense and this PowerShell module is still very much ongoing, so additional functionality will be added as these projects mature.

## Getting Started
Clone the repository to your PowerShell Modules folder:
```git
git clone https://github.com/fvanroie/PS_OPNsense.git .\PS_OPNsense
```

To load this module in PowerShell type:
```powershell
Import-Module -Name PS_OPNsense
```

## Supported Modules
Currently there are api hooks for these OPNsense modules:
- *CaptivePortal*
- *Core (Firmware and Packages)*
- *Cron*
- *Diagnostics*
- *IDS*
- *Proxy*
>>>>>>> master
- *Routes*
- *TrafficShaper*
- *Unbound*

<<<<<<< HEAD
Modules in **bold** have mostly been implemented in the current version of the PS_OPNsense module.

## Examples
```powershell
Connect-OPNsense -Uri 'https://fw01.local/api' -Key <my_api_key> -Secret <my_api_secret>
Get-OPNsense
Restart-OPNsense
=======
Modules in **bold** have been implemented in the current version of the PS_OPNsense module.
Currently only the raw API commands are available. See the examples below.

## Examples
Connecting to an OPNsense server:
```powershell
Connect-OPNsense -Uri 'https://fw01.local/api' -Key <api_key> -Secret <api_secret>
Connect-OPNsense -Uri 'https://fw01.local/api' -Key <api_key> -Secret <api_secret> -Verbose
Connect-OPNsense 'https://fw01.local/api' <api_key> <api_secret> -AcceptCertificate
```
Run some commands:
```powershell
Invoke-OPNsenseCommand core firmware status -Verbose
$(Invoke-OPNsenseCommand core firmware info).changelog
```
Disconnect from the server:
```powershell
>>>>>>> master
Disconnect-OPNsense
```
