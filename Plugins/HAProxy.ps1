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

function Select-InputObject {
    [CmdletBinding()]
    Param(
        [String]$paramset,
        [HashTable]$psbounds,
        [PSObject]$InputObject
    )
    Write-Verbose $paramset
    Write-Verbose (ConvertTo-Json $psbounds)
    if ($InputObject) { Write-Verbose (ConvertTo-Json $InputObject) }
    if ($paramSet -eq "AsParam") {
        $obj = New-Object PsObject;
        foreach ($key in $PSBounds.keys) {
            if ($key -notin [System.Management.Automation.PSCmdlet]::CommonParameters -and
                $key -notin [System.Management.Automation.PSCmdlet]::OptionalCommonParameters) {
                $obj | Add-Member -MemberType NoteProperty -Name $key.tolower() -Value $PSBounds[$key] -Force
            }
        }        
    } else {
        $obj = $InputObject
    }
    Write-Debug ("Parameters : {0}" -f (ConvertTo-Json -InputObject $obj))
    return $obj
}

function Test-Result {
    [CmdletBinding()]
    param (
        $result
    )
    switch ($result.result) {
        'saved' { return $True; Break }
        'deleted' { return $True; Break }
        'failed' { 
            if ($result.validations) {
                $fields = $result | Select-Object -ExpandProperty validations | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name
                foreach ($field in $fields) {
                    $host.UI.WriteErrorLine($("{0} : {1}" -f $field, $result.validations.($field)))
                }
            } else {
                $host.UI.WriteErrorLine("failed")
            }            
            return $false
            Break
        }
        'not found' {
            $host.UI.WriteErrorLine("not found")
            return $False
            Break
        }
        Default {

        }
    }
}

function Get-NoteProperty {
    [CmdletBinding()]
    param (
        $obj
    )
    return Get-Member -InputObject $obj -MemberType NoteProperty | Select-Object -ExpandProperty Name
}

function Format-OPNsenseProperty {
    [CmdletBinding()]
    param (
        $obj
    )
    $props = Get-NoteProperty $obj
    foreach ($prop in $props) {
        switch ($obj.($prop).GetType().Name) {
            'PSCustomObject' {
                $obj.($prop) = Get-MultiOption $obj.($prop)
            }
            default {}
        }
    }
    return $obj
}

function Get-MultiOption {
    [CmdletBinding()]
    param (
        $obj
    )
    $props = Get-NoteProperty $obj
    $result = @()
    foreach ($prop in $props) {
        if ($obj.($prop).selected -gt 0) {
            $result += $obj.($prop).value -replace ' \[default\]', ''
            #$result += $prop

            #$val = $obj.($prop).value -replace ' \[default\]', ''
            #$result += @{ $val = $prop}
        }
    }
    return $result
}



##### GET Functions #####
function Get-OPNsenseHAProxyDetail {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, position = 0)]
        [ValidateSet('Server', 'Backend', 'Frontend', 'Healthcheck', 'Errorfile', 'Lua', 'Acl', 'Action', 'Healthcheck')]
        [String]$ObjectType,
        [parameter(Mandatory = $true)][string]$Uuid
    )
    BEGIN {
        $results = @()
    }
    PROCESS {
        $result = Invoke-OPNsenseCommand haproxy settings ("get{0}/{1}" -f $ObjectType.ToLower(), $Uuid) | Select-Object -ExpandProperty $ObjectType
        $result | Add-Member -MemberType NoteProperty -Name 'uuid' -Value $Uuid
        #Write-Host (ConvertTo-Json $result)
        $result = Format-OPNsenseProperty $result
        $results += $result
    }
    END {
        return $results | Add-ObjectDetail -TypeName ('OPNsense.HAProxy.{0}.Detail' -f $ObjectType)
    }
}
function Get-OPNsenseHAProxyObject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, position = 0)]
        [ValidateSet('Server', 'Backend', 'Frontend', 'Healthcheck', 'Errorfile', 'Lua', 'Acl', 'Action', 'Healthcheck')]
        [String]$ObjectType,
        [parameter(Mandatory = $false)][string[]]$Name,
        [parameter(Mandatory = $false)][Switch]$Enabled        
    )
    #    return Invoke-OPNsenseCommand haproxy settings get | Select-Object -ExpandProperty haproxy | Select-Object -ExpandProperty $("{0}s" -f $ObjectType) | Select-Object -ExpandProperty $("{0}s" -f $ObjectType)
    $items = Invoke-OPNsenseCommand haproxy settings $("search{0}s" -f $ObjectType.ToLower()) | Select-Object -ExpandProperty rows

    # Get Object details based on the UUID
    $results = @()
    foreach ($item in $items) {
        $result = Get-OPNsenseHAProxyDetail -ObjectType $ObjectType -Uuid $item.Uuid
        $results += $result
    }

    return $results
}
Function Get-OPNsenseHAProxyServer {
    # .EXTERNALHELP ../PS_OPNsense.psd1-Help.xml
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $false)][string[]]$Name,
        [parameter(Mandatory = $false)][Switch]$Enabled        
    )
    return Get-OPNsenseHAProxyObject -ObjectType "Server" @PSBoundParameters
}
Function Get-OPNsenseHAProxyBackend {
    # .EXTERNALHELP ../PS_OPNsense.psd1-Help.xml
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $false)][string[]]$Name,
        [parameter(Mandatory = $false)][Switch]$Enabled        
    )
    return Get-OPNsenseHAProxyObject "Backend" @PSBoundParameters
}
Function Get-OPNsenseHAProxyFrontend {
    # .EXTERNALHELP ../PS_OPNsense.psd1-Help.xml
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $false)][string[]]$Name,
        [parameter(Mandatory = $false)][Switch]$Enabled        
    )
    return Get-OPNsenseHAProxyObject "Frontend" @PSBoundParameters
}
Function Get-OPNsenseHAProxyErrorfile {
    # .EXTERNALHELP ../PS_OPNsense.psd1-Help.xml
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $false)][string[]]$Name,
        [parameter(Mandatory = $false)][Switch]$Enabled        
    )
    return Get-OPNsenseHAProxyObject "Errorfile" @PSBoundParameters
}
Function Get-OPNsenseHAProxyHealthCheck {
    # .EXTERNALHELP ../PS_OPNsense.psd1-Help.xml
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $false)][string[]]$Name,
        [parameter(Mandatory = $false)][Switch]$Enabled        
    )
    return Get-OPNsenseHAProxyObject "HealthCheck" @PSBoundParameters
}
Function Get-OPNsenseHAProxyAcl {
    # .EXTERNALHELP ../PS_OPNsense.psd1-Help.xml
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $false)][string[]]$Name,
        [parameter(Mandatory = $false)][Switch]$Enabled        
    )
    return Get-OPNsenseHAProxyObject "Acl" @PSBoundParameters
}
Function Get-OPNsenseHAProxyAction {
    # .EXTERNALHELP ../PS_OPNsense.psd1-Help.xml
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $false)][string[]]$Name,
        [parameter(Mandatory = $false)][Switch]$Enabled        
    )
    return Get-OPNsenseHAProxyObject "Action" @PSBoundParameters
}
Function Get-OPNsenseHAProxyLuaScript {
    # .EXTERNALHELP ../PS_OPNsense.psd1-Help.xml
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $false)][string[]]$Name,
        [parameter(Mandatory = $false)][Switch]$Enabled        
    )
    return Get-OPNsenseHAProxyObject "Lua" @PSBoundParameters
}



##### NEW Functions #####
<#
function New-OPNsenseHAProxyObject {
    # .EXTERNALHELP ../PS_OPNsense.psd1-Help.xml
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, position = 0)]
        [ValidateSet('Server', 'Backend', 'Frontend', 'Healthcheck', 'Errorfile', 'Lua', 'Acl', 'Action', 'Healthcheck')]
        [String]$ObjectType,
        [PsObject[]]$InputObject
    )
    PROCESS {
        foreach ($Item in $InputObject) {
            #    return Invoke-OPNsenseCommand haproxy settings get | Select-Object -ExpandProperty haproxy | Select-Object -ExpandProperty $("{0}s" -f $ObjectType) | Select-Object -ExpandProperty $("{0}s" -f $ObjectType)
            $result = Invoke-OPNsenseCommand haproxy settings $("add{0}" -f $ObjectType.ToLower()) -Json @{ $ObjectType.ToLower() = $Item }
            if (Test-Result $result) {
                return $result
            }
        }
    }    
}
#>
function New-OPNsenseHAProxyObject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, position = 0)]
        [ValidateSet('Server', 'Backend', 'Frontend', 'Healthcheck', 'Errorfile', 'Lua', 'Acl', 'Action', 'Healthcheck')]
        [String]$ObjectType,
        [PsObject[]]$InputObject,
        [Switch]$PassThru
    )
    BEGIN {
        $results = @()
    }
    PROCESS {
        $PassThru = $true
        foreach ($Item in $InputObject) {
            #$Uuid = $Item.Uuid
            #if ($Uuid) {
            # Mode needs lowercase
            if ($Item.Mode) { $Item.Mode = $Item.Mode.tolower() }
            if ($Item.Code) { $Item.Code = ( 'x{0}' -f $Item.Code) }

            $snapBefore = $(Invoke-OPNsenseCommand haproxy settings $("search{0}s" -f $ObjectType.ToLower()) -Form @{ searchPhrase = $Item.Name} ).rows
            #    return Invoke-OPNsenseCommand haproxy settings get | Select-Object -ExpandProperty haproxy | Select-Object -ExpandProperty $("{0}s" -f $ObjectType) | Select-Object -ExpandProperty $("{0}s" -f $ObjectType)
            $result = Invoke-OPNsenseCommand haproxy settings $("add{0}" -f $ObjectType.ToLower()) -Json @{ $ObjectType.ToLower() = $Item }
            $snapAfter = $(Invoke-OPNsenseCommand haproxy settings $("search{0}s" -f $ObjectType.ToLower()) -Form @{ searchPhrase = $Item.Name} ).rows

            $uuid = Compare-Object -ReferenceObject $snapBefore -DifferenceObject $snapAfter -Property Uuid | Select-Object -ExpandProperty Uuid
            
            if (Test-Result $result) {
                $result = Get-OPNsenseHAProxyDetail -ObjectType $ObjectType -Uuid $Uuid
                #if ($PassThru) {
                $results += $result
                #}
            }
            #} else {
            #    Write-Error $("Invalid UUID for {0} object!" -f $ObjectType)
            #}
        }
    }
    END {
        return $results | Add-ObjectDetail -TypeName ('OPNsense.HAProxy.{0}.Detail' -f $ObjectType)
    }
}
Function New-OPNsenseHAProxyServer {
    # .EXTERNALHELP ../PS_OPNsense.psd1-Help.xml
    [CmdletBinding(DefaultParameterSetName = "AsParam")]  
    Param(
        [parameter(Position = 0, Mandatory = $true, ValueFromPipelineByPropertyname = $true, ParameterSetName = "AsObject")]
        [PSObject[]]$InputObject,

        [parameter(ValueFromPipelineByPropertyname = $true)][String]$Address,
        [parameter(ValueFromPipelineByPropertyname = $true)][String]$Advanced,
        [parameter(ValueFromPipelineByPropertyname = $true)][int]$CheckDownInterval,
        [parameter(ValueFromPipelineByPropertyname = $true)][int]$CheckInterval,
        [parameter(ValueFromPipelineByPropertyname = $true)]
        [ValidateRange(0, 65535)][int]$CheckPort,
        [parameter(ValueFromPipelineByPropertyname = $true)][String]$Description,
        [parameter(ValueFromPipelineByPropertyname = $true)]
        [ValidateSet("Active", "Backup", "Disabled")][String]$Mode,
        [parameter(ValueFromPipelineByPropertyname = $true)][String]$Name,
        [parameter(ValueFromPipelineByPropertyname = $true)]
        [ValidateRange(0, 65535)][int]$Port,
        [parameter(ValueFromPipelineByPropertyname = $true)][String]$Source,
        [parameter(ValueFromPipelineByPropertyname = $true)][String]$Ssl,
        [parameter(ValueFromPipelineByPropertyname = $true)][String]$sslCA,
        [parameter(ValueFromPipelineByPropertyname = $true)][String]$sslClientCertificate,
        [parameter(ValueFromPipelineByPropertyname = $true)][String]$sslCRL,
        [parameter(ValueFromPipelineByPropertyname = $true)][String]$SslVerify,
        [parameter(ValueFromPipelineByPropertyname = $true)]
        [ValidateRange(0, 256)][int]$Weight
    )
    BEGIN {
        $results = @()
    }
    PROCESS {
        # Convert parameters to InputObject
        $obj = Select-InputObject -paramset $PSCmdlet.ParameterSetName -psbounds $PSBoundParameters -InputObject $InputObject
        # Create new Object
        $result = New-OPNsenseHAProxyObject -ObjectType Server -InputObject $obj
        $results += $result
    }   
    END {
        return $results
    } 
}

Function New-OPNsenseHAProxyBackend {
    # .EXTERNALHELP ../PS_OPNsense.psd1-Help.xml
    [CmdletBinding()]
    param (
        [PsObject]$Parameters
    )
    return New-OPNsenseHAProxyObject Backend -InputObject $Parameters
}
Function New-OPNsenseHAProxyFrontend {
    # .EXTERNALHELP ../PS_OPNsense.psd1-Help.xml
    [CmdletBinding()]
    param (
        [PsObject]$Parameters
    )
    return New-OPNsenseHAProxyObject Frontend -InputObject $Parameters
}
Function New-OPNsenseHAProxyErrorfile {
    # .EXTERNALHELP ../PS_OPNsense.psd1-Help.xml
    [CmdletBinding(DefaultParameterSetName = "AsParam")]  
    Param(
        [parameter(Position = 0, Mandatory = $true, ValueFromPipelineByPropertyname = $true, ParameterSetName = "AsObject")]
        [PSObject[]]$InputObject,

        [parameter(Position = 0, Mandatory = $true, ValueFromPipelineByPropertyname = $true, ParameterSetName = "AsParam")][String]$Name,
        [parameter(Position = 1, ValueFromPipelineByPropertyname = $true)][String]$Description,
        [parameter(Position = 2, Mandatory = $true, ValueFromPipelineByPropertyname = $true)]
        [ValidateSet(200, 400, 403, 405, 408, 429, 500, 502, 503, 504)][int]$Code,
        [parameter(Position = 3, Mandatory = $true, ValueFromPipelineByPropertyname = $true)][String]$Content
    )
    BEGIN {
        $results = @()
    }
    PROCESS {
        # Convert parameters to InputObject
        $obj = Select-InputObject -paramset $PSCmdlet.ParameterSetName -psbounds $PSBoundParameters -InputObject $InputObject
        # Create new Object
        $result = New-OPNsenseHAProxyObject -ObjectType Errorfile -InputObject $obj
        $results += $result
    }   
    END {
        return $results
    } 
}
Function New-OPNsenseHAProxyLuaScript {
    # .EXTERNALHELP ../PS_OPNsense.psd1-Help.xml
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, position = 0, ParameterSetName = "Object")]
        [PsObject]$InputObject,

        [Parameter(Mandatory = $true, position = 0, ParameterSetName = "Normal")]
        [String]$Name,
        [Parameter(ParameterSetName = "Normal")]
        [String]$Description,
        [Parameter(Mandatory = $true, position = 1, ParameterSetName = "Normal")]
        [String]$Content
    )

    if ($InputObject) {
        return New-OPNsenseHAProxyObject -ObjectType "Lua" -InputObject $InputObject
    } else {
        $Params = @{
            'name' = $Name;
            'description' = "{0}" -f $Description;
            'content' = $Content;
        }
        return New-OPNsenseHAProxyObject -ObjectType "Lua" -InputObject $Params
    }
}



##### SET Functions #####
function Set-OPNsenseHAProxyObject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, position = 0)]
        [ValidateSet('Server', 'Backend', 'Frontend', 'Healthcheck', 'Errorfile', 'Lua', 'Acl', 'Action', 'Healthcheck')]
        [String]$ObjectType,
        [PsObject[]]$InputObject,
        [Switch]$PassThru
    )
    BEGIN {
        $results = @()
    }
    PROCESS {
        $PassThru = $true
        foreach ($Item in $InputObject) {
            $Uuid = $Item.Uuid
            if ($Uuid) {
                # Mode needs lowercase
                if ($Item.Mode) { $Item.Mode = $Item.Mode.tolower() }

                #    return Invoke-OPNsenseCommand haproxy settings get | Select-Object -ExpandProperty haproxy | Select-Object -ExpandProperty $("{0}s" -f $ObjectType) | Select-Object -ExpandProperty $("{0}s" -f $ObjectType)
                $result = Invoke-OPNsenseCommand haproxy settings $("set{0}/{1}" -f $ObjectType.ToLower(), $Uuid) -Json @{ $ObjectType.ToLower() = $Item }
                if (Test-Result $result) {
                    $result = Get-OPNsenseHAProxyDetail -ObjectType $ObjectType -Uuid $Uuid
                    if ($PassThru) {
                        $results += $result
                    }
                }
            } else {
                Write-Error $("Invalid UUID for {0} object!" -f $ObjectType)
            }
        }
    }
    END {
        return $results | Add-ObjectDetail -TypeName ('OPNsense.HAProxy.{0}.Detail' -f $ObjectType)
    }
}
Function Set-OPNsenseHAProxyServer {
    # .EXTERNALHELP ../PS_OPNsense.psd1-Help.xml
    [CmdletBinding(DefaultParameterSetName = "AsParam")]  
    Param(
        [parameter(Position = 0, Mandatory = $true, ValueFromPipelineByPropertyname = $true, ParameterSetName = "AsParam")]
        [String]$Uuid,

        [parameter(Position = 0, Mandatory = $true, ValueFromPipelineByPropertyname = $true, ParameterSetName = "AsObject")]
        [PSObject[]]$InputObject,

        [parameter(ValueFromPipelineByPropertyname = $true)][String]$Address,
        [parameter(ValueFromPipelineByPropertyname = $true)][String]$Advanced,
        [parameter(ValueFromPipelineByPropertyname = $true)][int]$CheckDownInterval,
        [parameter(ValueFromPipelineByPropertyname = $true)][int]$CheckInterval,
        [parameter(ValueFromPipelineByPropertyname = $true)]
        [ValidateRange(0, 65535)][int]$CheckPort,
        [parameter(ValueFromPipelineByPropertyname = $true)][String]$Description,
        [parameter(ValueFromPipelineByPropertyname = $true)]
        [ValidateSet("Active", "Backup", "Disabled")][String]$Mode,
        [parameter(ValueFromPipelineByPropertyname = $true)][String]$Name,
        [parameter(ValueFromPipelineByPropertyname = $true)]
        [ValidateRange(0, 65535)][int]$Port,
        [parameter(ValueFromPipelineByPropertyname = $true)][String]$Source,
        [parameter(ValueFromPipelineByPropertyname = $true)][String]$Ssl,
        [parameter(ValueFromPipelineByPropertyname = $true)][String]$sslCA,
        [parameter(ValueFromPipelineByPropertyname = $true)][String]$sslClientCertificate,
        [parameter(ValueFromPipelineByPropertyname = $true)][String]$sslCRL,
        [parameter(ValueFromPipelineByPropertyname = $true)][String]$SslVerify,
        [parameter(ValueFromPipelineByPropertyname = $true)]
        [ValidateRange(0, 256)][int]$Weight
    )
    BEGIN {
        $results = @()
    }
    PROCESS {
        # Convert parameters to InputObject
        $paramset = $PSCmdlet.ParameterSetName
        Write-Verbose $paramSet
        if ($paramSet -eq "AsParam") {
            $InputObject = New-Object PsObject;
            foreach ($key in $PSBoundParameters.keys) {
                if ($key -notin [System.Management.Automation.PSCmdlet]::CommonParameters -and
                    $key -notin [System.Management.Automation.PSCmdlet]::OptionalCommonParameters) {
                    $InputObject | Add-Member -MemberType NoteProperty -Name $key.tolower() -Value $PSBoundParameters[$key] -Force
                }
            }        
        }

        Write-Debug ("Parameters : {0}" -f (ConvertTo-Json -InputObject $InputObject))
        $result = Set-OPNsenseHAProxyObject -ObjectType Server -InputObject $InputObject
        $results += $result
    }   
    END {
        return $results
    } 
}



##### REMOVE Functions #####
Function Remove-OPNsenseHAProxyObject {
    # .EXTERNALHELP ../PS_OPNsense.psd1-Help.xml
    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = "Medium"
    )]
    Param(
        [Parameter(Mandatory = $true, position = 0)]
        [ValidateSet('Server', 'Backend', 'Frontend', 'Healthcheck', 'Errorfile', 'Lua', 'Acl', 'Action', 'Healthcheck')]
        [String]$ObjectType,
        [parameter(Mandatory = $true, ValueFromPipelineByPropertyname = $true, ParameterSetName = "AsParam")]
        [String[]]$Uuid
    )
    BEGIN {
        $results = @()
        $metadata = $(Invoke-OPNsenseCommand haproxy settings $("search{0}s" -f $ObjectType.ToLower())).rows
    }
    PROCESS {
        foreach ($id in $Uuid) {
            $item = $metadata | Where-Object { $_.Uuid -eq $id }
            if ($PSCmdlet.ShouldProcess(("{0} => {1}:{2} {{{3}}}" -f $item.name, $item.address, $item.port, $id), "Remove $ObjectType")) {
                $result = Invoke-OPNsenseCommand haproxy settings $("del{0}/{1}" -f $ObjectType.ToLower(), $id) -Json $ObjectType.ToLower() -AddProperty @{ 'Uuid' = $id }
                #Test-Result $result | Out-Null
                $results += $result
            }    
        }
    }    
    END {
        return $results
    }
}
Function Remove-OPNsenseHAProxyServer {
    # .EXTERNALHELP ../PS_OPNsense.psd1-Help.xml
    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = "Medium"
    )]
    Param(
        [parameter(Mandatory = $true, ValueFromPipelineByPropertyname = $true, ParameterSetName = "AsParam")]
        [String[]]$Uuid
    )
    PROCESS {
        return Remove-OPNsenseHAProxyObject -ObjectType Server -Uuid $Uuid
    }
}
Function Remove-OPNsenseHAProxyBackend {
    # .EXTERNALHELP ../PS_OPNsense.psd1-Help.xml
    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = "Medium"
    )]
    Param(
        [parameter(Mandatory = $true, ValueFromPipelineByPropertyname = $true, ParameterSetName = "AsParam")]
        [String[]]$Uuid
    )
    PROCESS {
        return Remove-OPNsenseHAProxyObject -ObjectType Backend -Uuid $Uuid
    }
}
Function Remove-OPNsenseHAProxyFrontend {
    # .EXTERNALHELP ../PS_OPNsense.psd1-Help.xml
    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = "Medium"
    )]
    Param(
        [parameter(Mandatory = $true, ValueFromPipelineByPropertyname = $true, ParameterSetName = "AsParam")]
        [String[]]$Uuid
    )
    PROCESS {
        return Remove-OPNsenseHAProxyObject -ObjectType Frontend -Uuid $Uuid
    }
}
Function Remove-OPNsenseHAProxyHealthCheck {
    # .EXTERNALHELP ../PS_OPNsense.psd1-Help.xml
    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = "Medium"
    )]
    Param(
        [parameter(Mandatory = $true, ValueFromPipelineByPropertyname = $true, ParameterSetName = "AsParam")]
        [String[]]$Uuid
    )
    PROCESS {
        return Remove-OPNsenseHAProxyObject -ObjectType HealthCheck -Uuid $Uuid
    }
}
Function Remove-OPNsenseHAProxyAcl {
    # .EXTERNALHELP ../PS_OPNsense.psd1-Help.xml
    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = "Medium"
    )]
    Param(
        [parameter(Mandatory = $true, ValueFromPipelineByPropertyname = $true, ParameterSetName = "AsParam")]
        [String[]]$Uuid
    )
    PROCESS {
        return Remove-OPNsenseHAProxyObject -ObjectType Acl -Uuid $Uuid
    }
}
Function Remove-OPNsenseHAProxyAction {
    # .EXTERNALHELP ../PS_OPNsense.psd1-Help.xml
    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = "Medium"
    )]
    Param(
        [parameter(Mandatory = $true, ValueFromPipelineByPropertyname = $true, ParameterSetName = "AsParam")]
        [String[]]$Uuid
    )
    PROCESS {
        return Remove-OPNsenseHAProxyObject -ObjectType Action -Uuid $Uuid
    }
}
Function Remove-OPNsenseHAProxyErrorfile {
    # .EXTERNALHELP ../PS_OPNsense.psd1-Help.xml
    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = "Medium"
    )]
    Param(
        [parameter(Mandatory = $true, ValueFromPipelineByPropertyname = $true, ParameterSetName = "AsParam")]
        [String[]]$Uuid
    )
    PROCESS {
        return Remove-OPNsenseHAProxyObject -ObjectType Errorfile -Uuid $Uuid
    }
}
Function Remove-OPNsenseHAProxyLuaScript {
    # .EXTERNALHELP ../PS_OPNsense.psd1-Help.xml
    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = "Medium"
    )]
    Param(
        [parameter(Mandatory = $true, ValueFromPipelineByPropertyname = $true, ParameterSetName = "AsParam")]
        [String[]]$Uuid
    )
    PROCESS {
        return Remove-OPNsenseHAProxyObject -ObjectType Lua -Uuid $Uuid
    }
}