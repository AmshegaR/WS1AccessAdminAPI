<#
.SYNOPSIS
Obtain an OAuth 2.0 access token.

.PARAMETER Tenant
Mandatory: WS1 Access Tenant URL

.PARAMETER ClientID
Mandatory: Client Identifier

.PARAMETER ClientSecret
Mandatory: Client Shared secret

.EXAMPLE
Get-ws1aAccessToken -Tenant "VIDMTenant.Domain.com" -ClientID "API-Admin" -ClientSecret "QWrfdghGTgt4GGJj5Hh"
}
#>
function Get-WS1AccessToken {
    [cmdletbinding()]
    param(
       [Parameter(Mandatory=$true)][string]$Tenant,
       [Parameter(Mandatory=$true)][string]$ClientID,
       [Parameter(Mandatory=$true)][string]$ClientSecret
    )
    
    $URI = "https://$($Tenant)/SAAS/auth/oauthtoken"
    $SCclient =[Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("$($ClientID):$($ClientSecret)"))
    $Header = @{
        authorization = 'Basic ' + $SCclient
        'content-type' = 'application/x-www-form-urlencoded'
    }
    $Body = @{
        grant_type = 'client_credentials'
    }
    $IRMParams = @{
        Method = 'POST'
        Headers = $Header
        Body = $Body
        URI = $URI
    }
    Write-Debug $($IRMParams | out-string)
    $Token = Invoke-RestMethod @IRMParams
    $Token | Add-Member -NotePropertyMembers @{Tenant="$($Tenant)"}
    Return $Token
}

$Token = Get-WS1AccessToken -Tenant "td-innasitkilove-442e9.vidmpreview.com" -ClientID "API-Admin" -ClientSecret "oFnfNbLYA3wNwOQzeRxxgEMLiXgOI7ViWqZR1ejEUZh4i0kz"