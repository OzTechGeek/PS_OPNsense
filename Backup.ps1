Function Backup-OPNsenseConfig {
    # .EXTERNALHELP PS_OPNsense.psd1-Help.xml
    [CmdletBinding()]
    Param (
        [switch]$RRDdata=$false,

        [ValidateNotNullOrEmpty()]
        [parameter(Mandatory=$false)]
        [String]$Password
    )

    $AcceptCertificate = $MyInvocation.MyCommand.Module.PrivateData['OPNsenseSkipCert']
    $Credential = $MyInvocation.MyCommand.Module.PrivateData['WebCredentials']
    $Uri = $MyInvocation.MyCommand.Module.PrivateData['OPNsenseUri']

    if ($PSBoundParameters.ContainsKey('Password')) {
        $encrypt = $true
    } else {
        $encrypt = $false
    }


    if ([bool]::Parse($AcceptCertificate)) {
        $CertPolicy = Get-CertificatePolicy -Verbose:$VerbosePreference
        Disable-CertificateValidation -Verbose:$VerbosePreference
    }

    Try {
        $webpage = Invoke-WebRequest -Uri $Uri -SessionVariable cookieJar
        $xssToken = $webpage.InputFields | Where-Object { $_.type -eq 'hidden'}
        $form = @{
            $xssToken.name = $xssToken.value;
            usernamefld = $Credential.Username;
            passwordfld = $Credential.GetNetworkCredential().Password;
            login = 1
        }
        $webpage = Invoke-WebRequest -Uri "$Uri/index.php" -WebSession $cookieJar -Method POST -Body $form
        # check logged in
        Write-Verbose $webpage.title

        $webpage = Invoke-WebRequest -Uri "$Uri/diag_backup.php" -WebSession $cookieJar -Method POST -Body $form
        $xssToken = $webpage.InputFields | Where-Object { $_.type -eq 'hidden'}

        $form = @{
            $xssToken[0].name = $xssToken[0].value ;
            donotbackuprrd = if ([bool]::Parse($RRDdata)) { '' } else { 'on' } ;
            encrypt = if ($encrypt) { 'on' } else { '' };
            encrypt_password = if ($encrypt) { $Password } else { '' };
            encrypt_passconf = if ($encrypt) { $Password } else { '' };
            download = "Download configuration"
        }
        $backupxml = Invoke-WebRequest "$Uri/diag_backup.php" -WebSession $cookieJar -Method POST -Body $form
        $Result = $backupxml.RawContent.Substring($backupxml.RawContent.Length-$backupxml.RawContentLength,$backupxml.RawContentLength)
    }
    Catch {
        $ErrorMessage = $_.Exception.Message
        Write-Error "An error Occured while connecting to the OPNsense server: $ErrorMessage"
    }
    # Always restore the built-in .NET certificate policy
    Finally {
        if ([bool]::Parse($AcceptCertificate)) {
            Set-CertificatePolicy $CertPolicy -Verbose:$VerbosePreference
        }
    }
    Return $Result
}

Function Restore-OPNsenseConfig {
    # .EXTERNALHELP PS_OPNsense.psd1-Help.xml
    [CmdletBinding(
       SupportsShouldProcess=$true,
       ConfirmImpact="High"
    )]
    Param (
        [ValidateNotNullOrEmpty()]
        [String]$xml,

        [ValidateNotNullOrEmpty()]
        [parameter(Mandatory=$false)]
        [String]$Password
    )

    $AcceptCertificate = $MyInvocation.MyCommand.Module.PrivateData['OPNsenseSkipCert']
    $Credential = $MyInvocation.MyCommand.Module.PrivateData['WebCredentials']
    $Uri = $MyInvocation.MyCommand.Module.PrivateData['OPNsenseUri']

  		$boundary = [guid]::NewGuid().ToString()
$bodyXML = @'
--{0}
Content-Disposition: form-data; name="{1}"; filename="{2}"
Content-Type: text/xml

{3}
--{0}--

'@
$bodytempl = @'
--{0}
Content-Disposition: form-data; name="{1}"

{2}

'@

    if ($PSBoundParameters.ContainsKey('Password')) {
        $decrypt = $true
    } else {
        $decrypt = $false
    }

    if ($pscmdlet.ShouldProcess($MyInvocation.MyCommand.Module.PrivateData['OPNsenseUri'])) {
    } else {
        Write-Warning 'Aborting Restore-OPNsenseConfig'
        Return
    }

    if ([bool]::Parse($AcceptCertificate)) {
        $CertPolicy = Get-CertificatePolicy -Verbose:$VerbosePreference
        Disable-CertificateValidation -Verbose:$VerbosePreference
    }

    Try {
        $webpage = Invoke-WebRequest -Uri $Uri -SessionVariable cookieJar
        $xssToken = $webpage.InputFields | Where-Object { $_.type -eq 'hidden'}
        $form = @{
            $xssToken.name = $xssToken.value;
            usernamefld = $Credential.Username;
            passwordfld = $Credential.GetNetworkCredential().Password;
            login = 1
        }
        $webpage = Invoke-WebRequest -Uri "$Uri/index.php" -WebSession $cookieJar -Method POST -Body $form
        # check logged in

        $webpage = Invoke-WebRequest -Uri "$Uri/diag_backup.php" -WebSession $cookieJar
        $xssToken = $webpage.InputFields | Where-Object { $_.type -eq 'hidden'}

        $form = @{
            $xssToken[0].name = $xssToken[0].value ;
            restorearea = '' ;
            rebootafterrestore = 'checked';
            decrypt = if ($decrypt) { 'on' } else { '' };
            decrypt_password = if ($decrypt) { $Password } else { '' };
            decrypt_passconf = if ($decrypt) { $Password } else { '' };
            restore = "Restore configuration"
        }

        $form.Keys | ForEach-Object {
            $body += $bodytempl -f $boundary, $_, $form.Item($_)
        }
        $body += $bodyXML -f $boundary, 'conffile', 'config.xml', $xml
        #Write-Verbose $body
        $restorexml = Invoke-WebRequest "$Uri/diag_backup.php" -WebSession $cookieJar -Method POST -Body $body -ContentType "multipart/form-data; boundary=$boundary"
    }
    Catch {
        $ErrorMessage = $_.Exception.Message
        Write-Error "An error Occured while connecting to the OPNsense server: $ErrorMessage"
    }
    # Always restore the built-in .NET certificate policy
    Finally {
        if ([bool]::Parse($AcceptCertificate)) {
            Set-CertificatePolicy $CertPolicy -Verbose:$VerbosePreference
        }
    }

    try {
        if ($restorexml.parsedhtml.body.getElementsbyclassname('alert-danger').length -gt 0) {
            $err = $restorexml.parsedhtml.body.getElementsbyclassname('alert-danger')[0].innerText
            $err = ($err.split("`n") | Select-Object -Skip 1) -join "`n+ "
            Write-Error $err
            Return
        }
        if ($restorexml.parsedhtml.body.getElementsbyclassname('alert-info').length -gt 0) {
            $result = $restorexml.parsedhtml.body.getElementsbyclassname('alert-info')[0].innerText
        } else {
            $Result = $restorexml.parsedhtml.body.getElementsbyclassname('alert')[0].innerText
        }
    }
    catch {
        $result = $restorexml
    }
    Return $Result
}

Function Reset-OPNsenseConfig {
    # .EXTERNALHELP PS_OPNsense.psd1-Help.xml
    [CmdletBinding(
       SupportsShouldProcess=$true,
       ConfirmImpact="High"
    )]
    Param (
        [parameter(Mandatory=$true)]
        [switch]$EraseAllSettings=$false,

        [ValidateNotNullOrEmpty()]
        [parameter(Mandatory=$true)]
        [String]$Hostname
    )

    $AcceptCertificate = $MyInvocation.MyCommand.Module.PrivateData['OPNsenseSkipCert']
    $Credential = $MyInvocation.MyCommand.Module.PrivateData['WebCredentials']
    $Uri = $MyInvocation.MyCommand.Module.PrivateData['OPNsenseUri']

    if ($PSBoundParameters.ContainsKey('Password')) {
        $encrypt = $true
    } else {
        $encrypt = $false
    }

      if ([bool]::Parse($EraseAllSettings)) {
      } else {
          Write-Warning 'You need to specify the Erase'
          Return
    }

    Write-Warning '!!! YOU ARE ABOUT TO COMPLETELY ERASE THE OPNSENSE CONFIGURATION !!!'
    if ($pscmdlet.ShouldProcess($MyInvocation.MyCommand.Module.PrivateData['OPNsenseUri'])) {
    } else {
        Write-Warning 'Aborting Reset-OPNsenseConfig'
        Return
    }

    Write-Warning '!!! YOU ARE ABOUT TO COMPLETELY ERASE THE OPNSENSE CONFIGURATION !!!'
    if ($pscmdlet.ShouldProcess($MyInvocation.MyCommand.Module.PrivateData['OPNsenseUri'] + "!!! Last warning !!!")) {
    } else {
        Write-Warning 'Aborting Reset-OPNsenseConfig'
        Return
    }

    if ([bool]::Parse($AcceptCertificate)) {
        $CertPolicy = Get-CertificatePolicy -Verbose:$VerbosePreference
        Disable-CertificateValidation -Verbose:$VerbosePreference
    }

    Try {
        $webpage = Invoke-WebRequest -Uri $Uri -SessionVariable cookieJar
        $xssToken = $webpage.InputFields | Where-Object { $_.type -eq 'hidden'}
        $form = @{
            $xssToken.name = $xssToken.value;
            usernamefld = $Credential.Username;
            passwordfld = $Credential.GetNetworkCredential().Password;
            login = 1
        }
        $webpage = Invoke-WebRequest -Uri "$Uri/index.php" -WebSession $cookieJar -Method POST -Body $form
        # check logged in
        $fqdn = $webpage.ParsedHtml.title.Split(' | ') | Select-Object -Last 1

        If ($fqdn -ne $Hostname) {
            Throw [System.Management.Automation.ItemNotFoundException] "'$Hostname' doesn't match the hostname of the server. You need to specify '$fqdn' to reset the configuration."
        }

        $webpage = Invoke-WebRequest -Uri "$Uri/diag_defaults.php" -WebSession $cookieJar -Method POST -Body $form
        $xssToken = $webpage.InputFields | Where-Object { $_.type -eq 'hidden'}

        $form = @{
            $xssToken[0].name = $xssToken[0].value ;
            'Submit' = 'Yes'
        }
        $webpage = Invoke-WebRequest "$Uri/diag_defaults.php" -WebSession $cookieJar -Method POST -Body $form
        $Result = $webpage
    }
    Catch [System.Management.Automation.ItemNotFoundException] {
      Write-Error $_.Exception.Message
    }
    Catch {
        $ErrorMessage = $_.Exception.Message
        Write-Error "An error Occured while connecting to the OPNsense server: $ErrorMessage"
    }
    # Always restore the built-in .NET certificate policy
    Finally {
        if ([bool]::Parse($AcceptCertificate)) {
            Set-CertificatePolicy $CertPolicy -Verbose:$VerbosePreference
        }
    }
    Return $Result
}
