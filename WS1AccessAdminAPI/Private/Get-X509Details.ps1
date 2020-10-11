<#
@Source: https://raw.githubusercontent.com/darrenjrobinson/X509Details/master/X509Details.psm1 ©Darren Robinson

.SYNOPSIS

Decode an X509 Certificate and present it as a PowerShell Object.
Certificate PowerShell Object details updated to include the X509 Certificate time to expiry (timeToExpiry).

.DESCRIPTION

Decode an X509 Certificate and present it as a PowerShell Object.
Certificate PowerShell Object details updated to include the X509 Certificate time to expiry (timeToExpiry).

.PARAMETER cert

The X509 Certificate to decode and udpate with time to expiry

.INPUTS

Certificate from Pipeline 

.OUTPUTS

PowerShell Object

.SYNTAX

Get-X509Details(cert)

.EXAMPLE

PS> Get-X509Details('MIIDtzCCAp+gAwIBAgIQZpJpy9zmR........URpc0T9DzsUUfoHfbQ==')
or
PS> 'MIIDtzCCAp+gAwIBAgIQZpJpy9zmR........URpc0T9DzsUUfoHfbQ==' | Get-X509Details
or 
PS> Get-X509Details('@
                    -----BEGIN CERTIFICATE-----
                    MIIDtzCCAp
                    ........URpc0T9DzsUUfoHfbQ==
                    -----END CERTIFICATE-----
                    '@)
#>
function Get-X509Details {
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
        [string]$cert
    )
    # Test textual encoding as per https://tools.ietf.org/html/rfc7468
    $verCertStart = "-----BEGIN CERTIFICATE-----`r`nM"
    $verCertEnd = "=`r`n-----END CERTIFICATE-----"
    if ($cert.StartsWith($verCertStart) -and $cert.EndsWith($verCertEnd)) { 
        $check = $true 
        $cert = $cert.Replace("-----BEGIN CERTIFICATE-----", "")
        $cert = $cert.Replace("-----END CERTIFICATE-----", "")
        $cert = $cert.trim()
    } 
    if (!$check) {
        if (!$cert.StartsWith("M") -and !$cert.EndsWith('=')) { 
            Write-Error "Invalid certificate or not in PEM / CER Format $($_)" -ErrorAction Stop 
        }
    }

    try {
        # Windows PowerShell
        $certData = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2    
        $certData.Import([Convert]::FromBase64String($cert))
    }
    catch {
        # PowerShell Core/6/7+
        $certData = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2(, [Convert]::FromBase64String($cert))
    }
    try {
        Write-Verbose "Certificate:$($certData.Subject)"        

        # Time to Expiry
        $timeToExpiry = ($certData.NotAfter - (get-date))
        Write-Verbose "Days until certificatioin expiry: $($timeToExpiry)"        
        $certData | Add-Member -Type NoteProperty -Name "timeToExpiry" -Value $timeToExpiry
        return $certData
    }
    catch {
        Write-Error "Invalid certificate or not in PEM / CER Format $($_)" -ErrorAction Stop 
    }
}
