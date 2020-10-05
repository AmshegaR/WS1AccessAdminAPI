<#
.SYNOPSIS
Validating token at the WS1 Access token endpoint
@Source: https://github.com/vmware/idm/wiki/Validating-Access-or-ID-Token#validating-tokens-at-the-identity-manager-token-endpoint

.PARAMETER Tenant
Mandatory: Mandatory: WS1Access Tenant.

.PARAMETER Token
Mandatory: WS1Access Token.

.EXAMPLE
Test-WS1AccessToken -Tenant $Token.Tenant -Token $Token.access_token
#>
Function Test-WS1AccessToken{
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true)][string]$Tenant,
        [Parameter(Mandatory=$true)][string]$Token
    )
    $URI = "https://$($Tenant)/SAAS/API/1.0/REST/auth/token"
    
    $Header = @{
        Authorization = "Bearer $($Token)"
    }
    $Body = @{
        attribute = "isValid"
    }
    $IRMParams = @{
        Method = 'GET'
        Body = $Body
        URI = $URI
        Headers = $Header
    }
    Write-Debug $($IRMParams | out-string)
    Return  Invoke-RestMethod @IRMParams    
}