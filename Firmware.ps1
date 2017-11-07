Function Invoke-OPNsenseCoreCommand {
    [CmdletBinding()]
    Param (
      [Parameter(Mandatory=$true,position=1)][String]$Module,
      [parameter(Mandatory=$true,position=2)][String]$Controller,
      [parameter(Mandatory=$true,position=3)][String]$Command
    )
    $result = Invoke-OPNsenseCommand $Module $Controller $Command -Form $Command -Verbose:$VerbosePreference
    if ($result.status -eq "failure") {
        Write-Error "Failed to execute $Module/$Controller/$Command command"
        return $false
    }
    if ($result.status -eq "ok") {
        return $true
    }
    return $result
}

Function Stop-OPNsense {
    # .EXTERNALHELP PS_OPNsense.psd1-Help.xml
    [CmdletBinding(
       SupportsShouldProcess=$true,
       ConfirmImpact="High"
    )]
    Param()
    if ($pscmdlet.ShouldProcess($MyInvocation.MyCommand.Module.PrivateData['OPNsenseApi'])) {
        return Invoke-OPNsenseCoreCommand core firmware poweroff -Verbose:$VerbosePreference
    }
}

Function Restart-OPNsense {
    # .EXTERNALHELP PS_OPNsense.psd1-Help.xml
    [CmdletBinding(
       SupportsShouldProcess=$true,
       ConfirmImpact="High"
    )]
    Param()
    if ($pscmdlet.ShouldProcess($MyInvocation.MyCommand.Module.PrivateData['OPNsenseApi'])) {
        return Invoke-OPNsenseCoreCommand core firmware reboot -Verbose:$VerbosePreference
    }  else  {
        return $false
    }
}

Function Update-OPNsense {
    # .EXTERNALHELP PS_OPNsense.psd1-Help.xml
    [CmdletBinding(
       SupportsShouldProcess=$true,
       ConfirmImpact="High"
    )]
    Param()
    if ($pscmdlet.ShouldProcess($MyInvocation.MyCommand.Module.PrivateData['OPNsenseApi'])) {
        $result = Invoke-OPNsenseCommand core firmware upgrade -Form upgrade -Verbose:$VerbosePreference
        if ($result.status -eq 'ok') {
            $start = 0
            Do {
                Start-Sleep -s 1
                $result = Invoke-OPNsenseCommand core firmware upgradestatus -Verbose:$false

                # Write-Verbose buffer, starting where we left off the previous itteration
                $log = $result.log.substring($start)
                $lines = $log.Split("`n")

                # Write-Verbose buffer, except last line as it can be incomplete
                for ($i = 1; $i -lt $lines.length; $i++) {
                    Write-Verbose  $lines[$i-1]
                    $start += $lines[$i-1].length + 1
                }
            } Until ($result.status -ne 'running')

            # Write-Verbose remaining Buffer
            $log = $result.log.substring($start)
            $lines = $log.Split("`n")

            # Write-Verbose buffer, including last line as it is complete
            for ($i = 0; $i -lt $lines.length; $i++) {
                Write-Verbose  $lines[$i]
                $start += $lines[$i].length + 1
            }
        }
        return $result
    } else {
        return $false
    }
}

# pkg audit -F
# FreeBSD registers vulnerabilities for its packages and we though that made a
# nice addition to a security project to create visibility and awareness.
Function Invoke-OPNsenseAudit {
    # .EXTERNALHELP PS_OPNsense.psd1-Help.xml
    [CmdletBinding()]
    Param()
    return Invoke-OPNsenseCoreCommand core firmware audit -Verbose:$VerbosePreference
}

Function Get-OPNsense {
    # .EXTERNALHELP PS_OPNsense.psd1-Help.xml
    [CmdletBinding()]
    Param(
        [Alias("Mirrors")]
        [parameter(Mandatory=$false,ParameterSetName = "Packets")]
        [Switch]$Mirror=$false
    )

    if ([bool]::Parse($Mirror)) {
      $allMirrors = @()
      $result = Invoke-OPNsenseCoreCommand core firmware getfirmwareoptions -Verbose:$VerbosePreference
      $result.mirrors | get-member -type NoteProperty | foreach-object {
          $url=$_.Name ;
          $name=$result.mirrors."$($_.Name)";

          if ($name -match "(.*) \((.*)\)") {
              $hosting = $Matches[1]
              $location = $Matches[2]
          } else {
              $hosting = ''
              $location = ''
          }
          $commercial = $Url -in $result.has_subscription

          $thisMirror = New-Object PSObject -Property @{ Url = $url ; Description = $name ; Hosting = $hosting ; Location = $location ; Commercial = $commercial }
          $allMirrors += $thisMirror
      }
      return $allMirrors
    }

    # No Switches
    return Invoke-OPNsenseCoreCommand core firmware status -Verbose:$VerbosePreference
}
