<#  MIT License

    Copyright (c) 2018 fvanroie, NetwiZe.be

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
#>


# Module Variables
$IsPSCoreEdition = ($PSVersionTable.PSEdition -eq 'Core')
$minversion = [System.Version]'18.1.6'

# Load individual functions from scriptfiles
ForEach ($Folder in 'Core', 'Plugins', 'Private', 'Public') {
    $FullPath = ("{0}/{1}/" -f $PSScriptRoot, $Folder)
    $Scripts = Get-ChildItem -Recurse -Filter '*.ps1' -Path $FullPath | Where-Object { $_.Name -notlike '*.Tests.ps1' }
    ForEach ($Script in $Scripts) {
        Try {
            # Dot Source each function
            . $Script.fullname

            # Export Public Functions only
            if ($Folder -eq 'Public') {
                Export-ModuleMember $script.basename
            }

        } Catch {
            # Display error
            Write-Error -Message ("Failed to import function {0}: {1}" -f $Script.name, $_)
        }
    }
}

Export-ModuleMember -Function Connect-OPNsense, Disconnect-OPNsense, Invoke-OPNsenseCommand
$f = @(########## PLUGINS ##########
    # ArpScanner
    'Update-OPNsenseArp', #'Get-OPNsenseArpScanner', 'Start-OPNsenseArpScanner', 'Wait-OPNsenseArpScanner', 'Stop-OPNsenseArpScanner',
    # Lldpd
    'Get-OPNsenseLldp', 'Set-OPNsenseLldp',
    # HAProxy
    'New-OPNsenseHAProxyServer', 'New-OPNsenseHAProxyFrontend', 'New-OPNsenseHAProxyBackend', 'New-OPNsenseHAProxyErrorfile', 'New-OPNsenseHAProxyLuaScript', 'New-OPNsenseHAProxyAcl', 'New-OPNsenseHAProxyHealthCheck',
    'Set-OPNsenseHAProxyServer', 'Set-OPNsenseHAProxyLuaScript',
   

    ########## CORE ##########
    # PS_OPNsense
    #'Connect-OPNsense', 'Disconnect-OPNsense',
    # RestApi
    'Invoke-OPNsenseCommand',
    # Firmware
    'Get-OPNsense', 'Set-OPNsense', 'Update-OPNsense', 'Get-OPNsenseUpdate'
    # Packages
    'Get-OPNsensePackage', 'Lock-OPNsensePackage', 'Unlock-OPNsensePackage', 'Install-OPNsensePackage', 'Uninstall-OPNsensePackage',
    'Get-OPNsensePlugin',
    # Cron
    'Get-OPNsenseCronJob', 'Enable-OPNsenseCronJob', 'Disable-OPNsenseCronJob', 'Remove-OPNsenseCronJob',
    'New-OPNsenseCronJob', 'Set-OPNsenseCronJob',
    #IDS
    'Get-OPNsenseIdsUserRule', 'New-OPNsenseIdsUserRule', 'Remove-OPNsenseIdsUserRule',
    'Get-OPNsenseIdsAlert',
    # Proxy
    'New-OPNsenseProxyRemoteBlacklist', 'Get-OPNsenseProxyRemoteBlacklist', 'Remove-OPNsenseProxyRemoteBlacklist',
    'Sync-OPNsenseProxyRemoteBlacklist',
    # CaptivePortal
    'New-OPNsenseCaptivePortalZone', 'Remove-OPNsenseCaptivePortalZone',
    'New-OPNsenseCaptivePortalTemplate', 'Get-OPNsenseCaptivePortalTemplate', 'Set-OPNsenseCaptivePortalTemplate', 'Remove-OPNsenseCaptivePortalTemplate', 'Save-OPNsenseCaptivePortalTemplate',
    'Get-OPNsenseCaptivePortal',
    # Diagnostics
    'Get-OPNsenseSystemHealth', 'Get-OPNsenseResource', 'Get-OPNsenseInterface', 'Get-OPNsenseRoute', 'Get-OPNsenseARP', 'Clear-OPNsenseARP',
    # Services
    'Get-OPNsenseService', 'Start-OPNsenseService', 'Update-OPNsenseService', 'Test-OPNsenseService', 'Restart-OPNsenseService', 'Stop-OPNsenseService', 'Invoke-OPNsenseService',
    # TrafficShaper
    'Remove-OPNsenseTrafficShaperPipe', 'Remove-OPNsenseTrafficShaperQueue', 'Remove-OPNsenseTrafficShaperRule')
Export-ModuleMember -Function $f