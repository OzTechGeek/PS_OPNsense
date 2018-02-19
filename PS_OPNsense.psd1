<#  MIT License

    Copyright (c) 2017 fvanroie

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

#
# Module manifest for module 'OPNsense'
#
# Generated by: fvanroie
#
# Generated on: 11/2/2017
#

@{

    # Script module or binary module file associated with this manifest.
    # RootModule = ''

    # Version number of this module.
    ModuleVersion          = '0.1.3'

    # Supported PSEditions
    CompatiblePSEditions   = @('Core', 'Desktop')

    # ID used to uniquely identify this module
    GUID                   = '49099aec-c819-43ee-8a03-aa605a0d80f8'

    # Author of this module
    Author                 = 'fvanroie'

    # Company or vendor of this module
    CompanyName            = 'netwiZe.be'

    # Copyright statement for this module
    Copyright              = '(c) 2018 fvanroie. All rights reserved.'

    # Description of the functionality provided by this module
    Description            = 'PowerShell Module for OPNsense REST api'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion      = '5.0'

    # Name of the Windows PowerShell host required by this module
    # PowerShellHostName = ''

    # Minimum version of the Windows PowerShell host required by this module
    # PowerShellHostVersion = ''

    # Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    DotNetFrameworkVersion = '4.5'

    # Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    CLRVersion             = '4.0'

    # Processor architecture (None, X86, Amd64) required by this module
    ProcessorArchitecture  = 'None'

    # Modules that must be imported into the global environment prior to importing this module
    # RequiredModules = @()

    # Assemblies that must be loaded prior to importing this module
    # RequiredAssemblies = @()

    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    # ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @()

    # Format files (.ps1xml) to be loaded when importing this module
    FormatsToProcess       = @(
        'Formats/ArpScanner.format.ps1xml',
        'Formats/Core.format.ps1xml',
        'Formats/Cron.format.ps1xml',
        'Formats/Firmware.format.ps1xml',
        'Formats/FirmwareUpdate.format.ps1xml',
        'Formats/HAProxy.format.ps1xml',
        'Formats/Packages.format.ps1xml',
        'Formats/Services.format.ps1xml',
        'Formats/ClamAV.format.ps1xml'
    )

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    NestedModules          = @(
        # Main Module
        'PS_OPNsense.ps1',

        # Core Functionality
        'Core/CaptivePortal.ps1',
        'Core/Cron.ps1',
        'Core/Diagnostics.ps1',
        'Core/Firmware.ps1',
        'Core/Ids.ps1',
        'Core/Packages.ps1',
        'Core/Proxy.ps1',
        'Core/Services.ps1',

        # Optional Installable Plugin Packages
        'Plugins/ArpScanner.ps1',
        'Plugins/ClamAV.ps1',
        'Plugins/Collectd.ps1',
        'Plugins/Freeradius.ps1',
        'Plugins/HAProxy.ps1',
        'Plugins/Lldpd.ps1',
        'Plugins/Postfix.ps1',
        'Plugins/Quagga.ps1',
        'Plugins/Siproxd.ps1',
        'Plugins/Tinc.ps1',
        'Plugins/Zerotier.ps1',

        # Legacy WebGUI Commands
        'Legacy/Backup.ps1',

        # Private Helper Function
        'Private/Add-ObjectDetail.ps1',
        'Private/CertificateValidation.ps1',
        'Private/New-ValidationDynamicParam.ps1',
        'Private/RestApi.ps1'
    )

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport      = @(
        ########## TEST ##########
        'Enable-OPNsense', 'Get-OPNsenseUpdateStatus',
        'New-OPNsenseHAProxyObject',

        #'New-OPNsenseHAProxyObject', 'Get-OPNsenseHAProxyObject', 'Set-OPNsenseHAProxyObject', #'Remove-OPNsenseHAProxyObject', 

        ########## LEGACY ##########
        # Backup
        'Backup-OPNsenseConfig', 'Restore-OPNsenseConfig', 'Reset-OPNsenseConfig',

        ########## PLUGINS ##########
        # ArpScanner
        'Update-OPNsenseArp', #'Get-OPNsenseArpScanner', 'Start-OPNsenseArpScanner', 'Wait-OPNsenseArpScanner', 'Stop-OPNsenseArpScanner',
        # ClamAV
        'Get-OPNsenseClamAV', 'Set-OPNsenseClamAV',
        # Collectd
        'Get-OPNsenseCollectd', 'Set-OPNsenseCollectd',
        # Freeraius
        'Remove-OPNsenseFreeradiusClient', 'Remove-OPNsenseFreeradiusUser',
        # Lldpd
        'Get-OPNsenseLldp', 'Set-OPNsenseLldp',
        # Postfix
        'Remove-OPNsensePostfixDomain', 'Remove-OPNsensePostfixRecipient', 'Remove-OPNsensePostfixSender',
        # Quagga
        'Remove-OPNsenseBgpNeighbor', 'Remove-OPNsenseBgpAspath', 'Remove-OPNsenseBgpPrefixlist', 'Remove-OPNsenseBgpRoutemap',
        'Remove-OPNsenseOspf6Interface', 'Remove-OPNsenseOspfNetwork', 'Remove-OPNsenseOspfInterface', 'Remove-OPNsenseOspfPrefixlist',
        # Siproxd
        'Remove-OPNsenseSiproxdDomain', 'Remove-OPNsenseSiproxdUser',
        # Tinc
        'Remove-OPNsenseTincNetwork', 'Remove-OPNsenseTincHost',
        # Zerotier
        'Remove-OPNsenseZerotierNetwork',

        ########## CORE ##########
        # PS_OPNsense
        'Connect-OPNsense', 'Disconnect-OPNsense',
        # RestApi
        'Invoke-OPNsenseCommand',
        # Firmware
        'Get-OPNsense', 'Stop-OPNsense', 'Restart-OPNsense', 
        'Set-OPNsense',
        'Update-OPNsense', 'Invoke-OPNsenseAudit', 'Get-OPNsenseUpdate'
        # HAProxy
        'New-OPNsenseHAProxyServer', 'New-OPNsenseHAProxyFrontend', 'New-OPNsenseHAProxyBackend', 'New-OPNsenseHAProxyErrorfile', 'New-OPNsenseHAProxyLuaScript', 'New-OPNsenseHAProxyAcl', 'New-OPNsenseHAProxyHealthCheck',
        'Get-OPNsenseHAProxyServer', 'Get-OPNsenseHAProxyFrontend', 'Get-OPNsenseHAProxyBackend', 'Get-OPNsenseHAProxyErrorfile', 'Get-OPNsenseHAProxyLuaScript', 'Get-OPNsenseHAProxyAcl', 'Get-OPNsenseHAProxyHealthCheck', 'Get-OPNsenseHAProxyAction', 
        'Set-OPNsenseHAProxyServer', 'Set-OPNsenseHAProxyLuaScript',
        'Remove-OPNsenseHAProxyServer', 'Remove-OPNsenseHAProxyFrontend', 'Remove-OPNsenseHAProxyBackend', 'Remove-OPNsenseHAProxyErrorfile', 'Remove-OPNsenseHAProxyLuaScript', 'Remove-OPNsenseHAProxyAcl', 'Remove-OPNsenseHAProxyHealthCheck', 'Remove-OPNsenseHAProxyAction', 
        # Packages
        'Get-OPNsensePackage', 'Lock-OPNsensePackage', 'Unlock-OPNsensePackage', 'Install-OPNsensePackage', 'Remove-OPNsensePackage',
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
        'Get-OPNsenseService', 'Start-OPNsenseService', 'Update-OPNsenseService', 'Test-OPNsenseService', 'Restart-OPNsenseService', 'Stop-OPNsenseService', 'Invoke-OPNsenseService'
    )

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport        = @()

    # Variables to export from this module
    VariablesToExport      = ''

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport        = @()

    # DSC resources to export from this module
    # DscResourcesToExport = @()

    # List of all modules packaged with this module
    ModuleList             = @()

    # List of all files packaged with this module
    # FileList = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData            = @{

        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags         = @('OPNsense', 'REST', 'api')

            # A URL to the license for this module.
            LicenseUri   = 'https://github.com/fvanroie/PS_OPNsense'

            # A URL to the main website for this project.
            ProjectUri   = 'https://github.com/fvanroie/PS_OPNsense'

            # A URL to an icon representing this module.
            # IconUri = ''

            # ReleaseNotes of this module
            ReleaseNotes = 'Early development alpha release'

        } # End of PSData hashtable

    } # End of PrivateData hashtable

    # HelpInfo URI of this module
    # HelpInfoURI = 'PS_OPNsense.psd1-help.xml'

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''

}
