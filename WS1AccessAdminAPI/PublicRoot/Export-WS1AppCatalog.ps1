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

.EXAMPLE
$TestAppUUID = Get-WS1AppCatalog -Filter @{ "nameFilter" = "board-mvc-saml" }
Export-WS1AppCatalog -AppUUID $TestAppUUID.uuid -SaveTo "C:\Backup\$($TestAppUUID.name).zip"

.EXAMPLE
Get-WS1AppCatalog -Filter @{ "nameFilter" = "OpenID TestApp" } | Select-Object -ExpandProperty UUID | Export-WS1AppCatalog -SaveTo "C:\Backup\OpenID TestApp.zip"

#>
Function Export-WS1AppCatalog{
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true)][string]$Tenant,
        [Parameter(Mandatory=$true)][string]$Token,
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)][Guid]$AppUUID,
        [Parameter(Mandatory=$true)][System.IO.FileInfo]$SaveTo
    )
    begin {
        $Header = @{
            Authorization = "HZN $($Token)"
            Accept = "application/zip"
            'Accept-Encoding' = "gzip, deflate, br"
        }
        $Body = @{
            useAbsoluteUrl = "true"
            '_t' = ""
            locale = "en"
        }
        $URL = "https://$($Tenant)/SAAS/jersey/manager/api/catalogitems/"
    }
    Process {
        $URI = $URL + "$($AppUUID)"
        $Now = [Math]::Floor([decimal](Get-Date(Get-Date).ToUniversalTime()-uformat "%s"))
        $Body.'_t' = $Now
        $IRMParams = @{
            Method = 'GET'
            Headers = $Header
            Body = $Body
            URI = $URI
            OutFile = $SaveTo
        }
        Write-Debug $($IRMParams | out-string)
        try {
            Invoke-WebRequest @IRMParams
            $Result = @{ "Status" = $True; "Message" = "Application successfully exported" }
        }
        catch {
            Write-Verbose "$_.Exception.Message"
            $Result = @{ "Status" = $False; "Message" = $Error[0].Exception.Message }
        }
        Return New-Object psobject -Property $Result
    }
}
