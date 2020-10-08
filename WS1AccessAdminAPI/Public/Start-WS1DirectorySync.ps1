<#
.SYNOPSIS
Force a manual WS1Access directory sync
@Source: https://blog.eucse.com/workspace-one-access-manual-ad-sync-via-api

.PARAMETER Tenant
Mandatory: WS1Access Tenant.

.PARAMETER Token
Mandatory: oAuth2 AccessToken

.PARAMETER IgnoreSafeguards
Optional: Ignore Safeguards configuration

.EXAMPLE
Start-WS1DirectorySync -Tenant $Token.Tenant -Token $token.access_token -DirectoryID "xxxx-9b4b-xxxxx-a83a-xxxxx" -IgnoreSafeguards $false
#>
Function Start-WS1DirectorySync{
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true)][string]$Tenant,
        [Parameter(Mandatory=$true)][string]$Token,
        [Parameter(Mandatory=$true)][string]$DirectoryID,
        [bool]$IgnoreSafeguards = $true

    )
    $URI = "https://$($Tenant)/SAAS/jersey/manager/api/connectormanagement/directoryconfigs/$($DirectoryID)/syncprofile/sync"
    $Header = @{
        Authorization = "Bearer $($Token)"
        "Content-Type" = "application/vnd.vmware.horizon.manager.connector.management.directory.sync.profile.sync+json"
    }
    $IRMParams = @{
        Method = 'POST'
        Headers = $Header
        URI = $URI
    }
    If($IgnoreSafeguards){
        $IRMParams.Add("Body", '{ "ignoreSafeguards":"true" }')
    }
    Write-Debug $($IRMParams | out-string)
    Return Invoke-RestMethod @IRMParams
}

$WS1Directory = Get-WS1DirectoryConfigs -Tenant $Token.Tenant -Token $Token.access_token
$Directory = ($WS1Directory.items | Where-Object { $PSItem.type -eq 'ACTIVE_DIRECTORY_IWA' }).directoryId
Start-WS1DirectorySync -Tenant $Token.Tenant -Token $token.access_token -DirectoryID $Directory -Debug
