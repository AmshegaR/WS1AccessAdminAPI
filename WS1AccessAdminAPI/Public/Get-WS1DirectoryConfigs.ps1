<#
.SYNOPSIS
Retrives WS1Access directory configurations. 

.PARAMETER Tenant
Mandatory: WS1Access Tenant.

.PARAMETER Token
Mandatory: oAuth2 AccessToken

.EXAMPLE
$WS1Directory = Get-WS1DirectoryConfigs -Tenant $Token.Tenant -Token $Token.access_token
Write-Host ($WS1Directory.items | Format-List | Out-String)
#>
Function Get-WS1DirectoryConfigs{
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true)][string]$Tenant,
        [Parameter(Mandatory=$true)][string]$Token
    )
    $URI = "https://$($Tenant)/SAAS/jersey/manager/api/connectormanagement/directoryconfigs"
    
    $Header = @{
        Authorization = "Bearer $($Token)"
        "Content-Type" = "application/vnd.vmware.horizon.manager.connector.management.directory.sync.profile.sync+json"
    }
    $IRMParams = @{
        Method = 'GET'
        Headers = $Header
        URI = $URI
    }
    Write-Debug $($IRMParams | out-string)
    Return Invoke-RestMethod @IRMParams
}