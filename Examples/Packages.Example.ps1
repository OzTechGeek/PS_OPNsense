#Requires -Modules PS_OPNsense

# # #   W A R N I N G   # # # # # # # # # # # # # # # # # # # # # # # #
#
#  This script makes changes on your OPNsense appliance,
#  do NOT run this script against a production machine !
#
# New objects to be created are defined in the script below
# They can also be imported from a file, database, other script, ...
#
# Note: Connect to OPNsense first
#       See Connect.Example.ps1 file for an example of how to connect

$beVerbose = $false

# Make sure HAproxy is installed
$haproxy = Get-OPNsensePackage 'os-haproxy'
If (-Not $haproxy.installed) {
    $haproxy | Install-OPNsensePackage -Verbose:$beVerbose
} else {
    Write-Host -ForegroundColor Cyan "HAProxy plugin-in is already installed!"
}

# Get ALL Plugins, except frr
$myplugins = Get-OPNsensePlugin  -Verbose:$beVerbose | Where-Object { $_.Name -notin 'os-frr' }

# Install the plugin packages
$myplugins | Install-OPNsensePackage -Verbose:$beVerbose


## Disconnect from OPNsense server
#Disconnect-OPNsense -Verbose:$beVerbose