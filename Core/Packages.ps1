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

Function Get-OPNsensePackage {
    # .EXTERNALHELP ../PS_OPNsense.psd1-Help.xml
    param (
        [SupportsWildcards()]    
        [Parameter(Mandatory = $false, position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [String[]]$Name,
        [Switch]$Installed = $false,
        [Switch]$Locked = $false
    )
    BEGIN {
        # Get all packages
        $packages = $(Invoke-OPNsenseCommand core firmware info).package
        foreach ($package in $packages) {
            $package.installed = $package.installed -eq 1
            $package.locked = $package.locked -eq 1
            $package.provided = $package.provided -eq 1
        }
        if ($PSBoundParameters.ContainsKey('Installed')) {
            $packages = $packages | where-Object { $_.Installed -eq $Installed }
        }

        if ($PSBoundParameters.ContainsKey('Locked')) {
            $packages = $packages | where-Object { $_.Locked -eq $Locked }
        }

        # No Name was passed
        if (-Not $PSBoundParameters.ContainsKey('Name')) { $Name = '*' }

        $allpackages = @()
    }
    PROCESS {
        # Multiple Names can be passed
        foreach ($pkgname in $Name) {
            # Filter packages based on possible wildcards
            $temppkgs = $packages | where-Object { $_.Name -like $pkgname }
            foreach ($temppkg in $temppkgs) {
                # Check if packege is already included
                if ($allpackages -notcontains $temppkg) {
                    $allpackages += $temppkg
                }
            }
        }
    }
    END {
        return $allpackages | Add-ObjectDetail -TypeName 'OPNsense.Package'
    }
}

Function Lock-OPNsensePackage {
    # .EXTERNALHELP ../PS_OPNsense.psd1-Help.xml
    param (
        [Parameter(Mandatory = $true, position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)][String[]]$Name
    )
    BEGIN {
        $pkg = Get-OPNsensePackage
        $packagenames = @()
    }
    PROCESS {
        $thispkg = $pkg | Where-Object { $_.Name -eq $Name }
        $packagenames += $Name.tolower()
        If ($thispkg.installed -eq 0) {
            Write-Warning ($thispkg.Name + " is not installed and cannot be locked.")
        } else {
            $result = Invoke-OPNsenseCommand core firmware "lock/$Name" -Form lock -addProperty @{ name = $Name.tolower()}
        }
    }
    END {
        return Get-OPNsensePackage -Name $packagenames
    }
}

Function Unlock-OPNsensePackage {
    # .EXTERNALHELP ../PS_OPNsense.psd1-Help.xml
    param (
        [Parameter(Mandatory = $true, position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)][String[]]$Name
    )
    BEGIN {
        $pkg = Get-OPNsensePackage
    }
    PROCESS {
        $thispkg = $pkg | Where-Object { $_.Name -eq $Name }
        If ($thispkg.locked -eq 0) {
            Write-Warning ($thispkg.Name + " is not locked and cannot be unlocked.")
        } else {
            Invoke-OPNsenseCommand core firmware "unlock/$Name" -Form unlock -addProperty @{ name = $Name.tolower()}
        }
    }
    END {
        #return $results
    }
}

Function Install-OPNsensePackage {
    # .EXTERNALHELP ../PS_OPNsense.psd1-Help.xml
    param (
        [Parameter(Mandatory = $true, position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)][String[]]$Name,
        [Parameter(Mandatory = $false)][Switch]$Force
    )
    BEGIN {
        $pkg = Get-OPNsensePackage
        $results = @()
    }
    PROCESS {
        $thispkg = $pkg | Where-Object { $_.Name -eq $Name }
        If ($thispkg.installed -eq 1) {
            If (-Not [bool]::Parse($Force)) {
                Write-Warning ($thispkg.Name + " is already installed. Use -Force to reinstall the package.")
                $status = $null
            } else {
                $status = Invoke-OPNsenseCommand core firmware "reinstall/$Name" -Form reinstall -addProperty @{ name = $Name.tolower()}              
            }
        } else {
            $status = Invoke-OPNsenseCommand core firmware "install/$Name" -Form install -addProperty @{ name = $Name.tolower()}
        }

        # Check installation progress
        if ($status) {
            if ($status.status -eq 'ok') {
                $result = Get-OPNsenseUpdateStatus
                $result | Add-Member -MemberType NoteProperty -Name 'Name' -Value $Name.tolower()
                $results += $result
            }
        }
    }
    END {
        return $results
    }
}

Function Uninstall-OPNsensePackage {
    # .EXTERNALHELP ../PS_OPNsense.psd1-Help.xml
    param (
        [Parameter(Mandatory = $true, position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)][String[]]$Name
    )
    BEGIN {
        $pkg = Get-OPNsensePackage
        $results = @()
    }
    PROCESS {
        $thispkg = $pkg | Where-Object { $_.Name -eq $Name }
        If ($thispkg.installed -eq 0) {
            Write-Warning ($thispkg.Name + " is not installed and cannot be removed.")
            $status = $null
        } else {
            $status = Invoke-OPNsenseCommand core firmware "remove/$Name" -Form remove -addProperty @{ name = $Name.tolower()}
            if ($status.status -eq 'ok') {
                $result = Get-OPNsenseUpdateStatus
                $result | Add-Member -MemberType NoteProperty -Name 'Name' -Value $Name.tolower()
                $results += $result
            }
        }
    }
    END {
        return $results
    }
}

Function Get-OPNsensePlugin {
    # .EXTERNALHELP ../PS_OPNsense.psd1-Help.xml

    $packages = Invoke-OPNsenseCommand core firmware info
    return $packages.plugin | Add-ObjectDetail -TypeName 'OPNsense.Package'
}
