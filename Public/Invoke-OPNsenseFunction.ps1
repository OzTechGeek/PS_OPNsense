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

# Public Function that abscracts the API calls
Function Invoke-OPNsenseFunction {
    # .EXTERNALHELP ../PS_OPNsense.psd1-Help.xml
    [OutputType([Object[]])]
    [CmdletBinding()]
    Param (
        [parameter(Mandatory = $true, position = 0)][String]$Module,
        [parameter(Mandatory = $true, position = 1)][String]$Command,
        [parameter(Mandatory = $true, position = 2)][String]$Object,
        [parameter(Mandatory = $false)][String]$Uuid,
        [parameter(Mandatory = $false)][Boolean]$Enable
    )

    # TODO : Check if the appropriate plugin is installed

    # Get the Invoke Arguments List
    $arglist = $OPNsenseItemMap.$Module.$Object.$Command.command
    $returntype = $OPNsenseItemMap.$Module.$Object.$Command.returntype

    # Build Invoke Arguments Splat
    $splat = @{};
    if ($arglist) {
        $arglist | Get-Member -MemberType NoteProperty | ForEach-Object { $splat.add($_.name, $arglist.($_.name))}
    } else {
        Throw "Undefined api call for $command $Module $Object"
    }

    # Replace parameters in splat
    $splat.command = $splat.command.Replace("<uuid>", $id)
            
    # Replace parameters in splat
    if ($Enable) {
        $splat.command = $splat.command.Replace("<enabled>", '1')
        $splat.command = $splat.command.Replace("<disabled>", '0')
    } else {
        $splat.command = $splat.command.Replace("<enabled>", '0')
        $splat.command = $splat.command.Replace("<disabled>", '1')     
    }

    # Add UUID, except for OPNsense.CaptivePortal.Template already as it already has a UUID
    if ($command -eq 'get' -and $returntype -ne 'OPNsense.CaptivePortal.Template') {
        $splat.Add("AddProperty", @{ 'uuid' = $Uuid} )
    }
  
    # Invoke splat
    $result = Invoke-OPNsenseCommand @splat

    # for OPNsense.CaptivePortal.Template all Templates are returned, select the one with the correct UUID
    if ($command -eq 'get' -and $returntype -eq 'OPNsense.CaptivePortal.Template') {
        $result = $result | Where-Object { $_.UUID -eq $Uuid }
    }

    if ($returntype) {
        Write-Verbose "Converting object to $returntype"
        return ConvertTo-OPNsenseObject -TypeName $returntype -InputObject $result
    }
    return $result
}