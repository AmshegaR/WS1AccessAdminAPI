<#
.SYNOPSIS
Obtain an OAuth 2.0 access token.
Source: https://github.com/vmware/idm/wiki/Integrating-Client-Credentials-app-with-OAuth2#getting-your-client-credentials-access-token

.PARAMETER Tenant
Mandatory: WS1 Access Tenant URL

.PARAMETER ClientID
Mandatory: Client Identifier

.PARAMETER ClientSecret
Mandatory: Client Shared secret

.EXAMPLE
Get-WS1AccessToken -Tenant "VIDMTenant.Domain.com" -ClientID "API-Admin" -ClientSecret "QWrfdghGTgt4GGJj5Hh" -SetToken

.EXAMPLE
$Token = Get-WS1AccessToken -Tenant $tenant -ClientID $clientID -ClientSecret $secret
Write-Host ($Token.Data | Format-List | Out-String)

.EXAMPLE
$Params = @{
    Tenant = 'tenant01.example.com'
    ClientID = 'Example01'
    ClientSecret = 'qwerty'
    SetToken = $true
}
$Token = Get-WS1AccessToken @Params
Write-Host ($Token | Format-List | Out-String)
#>
function Get-WS1AccessToken {
    [cmdletbinding()]
    param(
       [Parameter(Mandatory=$true)][string]$Tenant,
       [Parameter(Mandatory=$true)][string]$ClientID,
       [Parameter(Mandatory=$true)][string]$ClientSecret,
       [switch]$SetToken
    )
    $URI = "https://$($Tenant)/SAAS/auth/oauthtoken"
    #Concatinate ClientID & ClientSecret and convert to Base64
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
    try {
        $Token = Invoke-RestMethod @IRMParams
        $Token | Add-Member -NotePropertyMembers @{Tenant="$($Tenant)"}
        If($SetToken.IsPresent){ Set-WS1SessionToken -Token $Token | Out-Null }
        $Result = @{ "Status" = $True; "Data" = $Token }
    }
    catch {
        Write-Verbose "$_.Exception.Message"
        $Result = @{ "Status" = $False; "Message" = $Error[0].Exception.Message }
    }
    Return New-Object psobject -Property $Result
}
