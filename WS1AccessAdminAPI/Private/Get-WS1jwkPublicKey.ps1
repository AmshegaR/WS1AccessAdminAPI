<#
.SYNOPSIS
Getting Ws1Access public key 
@Source: https://github.com/vmware/idm/wiki/Validating-Access-or-ID-Token#validating-tokens-locally

.PARAMETER Tenant
Mandatory: WS1 Access Token.

.PARAMETER PemFormat
Optional: PEM format rather than the default JWK format.

.EXAMPLE
Get-WS1jwkPublicKey -Tenant $Token.Tenant -PemFormat
#>
Function Get-WS1jwkPublicKey{
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true)][string]$Tenant,
        [switch]$PemFormat
    )
    $URI = "https://$($Tenant)/SAAS/API/1.0/REST/auth/token"
    
    $Body = @{
        attribute = "publicKey"
    }
    If($PemFormat){ $Body.Add("format", "pem") }
    $IRMParams = @{
        Method = 'GET'
        Body = $Body
        URI = $URI
    }
    Write-Debug $($IRMParams | out-string)
    Return  Invoke-RestMethod @IRMParams    
}