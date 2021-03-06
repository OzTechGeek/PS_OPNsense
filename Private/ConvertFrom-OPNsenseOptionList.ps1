<#	MIT License
	
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

Function ConvertFrom-OPNsenseOptionList {
    # .EXTERNALHELP ../PS_OPNsense.psd1-Help.xml
    [OutputType([Object[]])]
    [CmdletBinding()]
    Param(
        [parameter(Mandatory = $true, position = 0)][PSObject]$InputObject # Object
    )

    $OptionList = New-Object -TypeName System.Collections.Hashtable
    foreach ($prop in $InputObject.PSObject.properties) {
        # Property names with a signle space were a workaround to get the JSON parsed properly
        # Restore the original key by replacing the space with an empty string
        if ($prop.name -eq ' ') {
            $key = ''
        } else {
            $key = $prop.name
        }
        $OptionList.Add($key, $prop.value)
    }
    return $OptionList
}