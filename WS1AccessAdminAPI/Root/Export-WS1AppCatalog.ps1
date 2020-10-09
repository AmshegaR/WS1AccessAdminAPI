<#
.SYNOPSIS
Export catalog application to a ZIP file.
Similar to the "More->Export" funcution in Admin UI.

.PARAMETER Tenant
Mandatory: WS1Access Tenant.

.PARAMETER Token
Mandatory: oAuth2 AccessToken

.PARAMETER SaveTo
Mandatory: Path to save the downloaded file.

.EXAMPLE
Export-WS1AppCatalog -Tenant "example.vmware.com" -Token $Token -AppUUID "xxxx-f6da-xxxx-b813-xxx2e31e" -SaveTo "C:\temp\example.zip"
#>
Function Export-WS1AppCatalog{
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true)][string]$Tenant,
        [Parameter(Mandatory=$true)][string]$Token,
        [Parameter(Mandatory=$true)][string]$AppUUID,
        [Parameter(Mandatory=$true)][string]$SaveTo
    )
    $URI = "https://$($Tenant)/SAAS/jersey/manager/api/catalogitems/$($AppUUID)"

    $Now = [Math]::Floor([decimal](Get-Date(Get-Date).ToUniversalTime()-uformat "%s"))
    $Header = @{
        Authorization = "HZN $($Token)"
        Accept = "application/zip"
        'Accept-Encoding' = "gzip, deflate, br"
    }
    $Body = @{
        useAbsoluteUrl = "true"
        '_t' = $Now
        locale = "en"
    }

    $IRMParams = @{
        Method = 'GET'
        Headers = $Header
        Body = $Body
        URI = $URI
        OutFile = $SaveTo
    }
    Write-Debug $($IRMParams | out-string)
    Return Invoke-WebRequest @IRMParams
}
