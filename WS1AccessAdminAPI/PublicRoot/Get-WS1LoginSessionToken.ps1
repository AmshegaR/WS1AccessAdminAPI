<#
.SYNOPSIS
Request an SessionToken using Oauth2 client that supports user and password.
@Source: https://docs.hol.vmware.com/HOL-2019/hol-1957-02-uem_pdf_en.pdf

.PARAMETER Tenant
Mandatory: WS1Access Tenant.

.PARAMETER LocalAdminUSR
Mandatory: Local user.

.PARAMETER LocalAdminPWD
Optional: local user password.

.EXAMPLE
$Token = Get-WS1LoginSessionToken -Tenant "example.vmware.com" -LocalAdminUSR "Admin" -LocalAdminPWD "P@ssw0rd"
#>
Function Get-WS1LoginSessionToken{
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true)][string]$Tenant,
        [Parameter(Mandatory=$true)][string]$LocalAdminUSR,
        [Parameter(Mandatory=$true)][string]$LocalAdminPWD

    )

    $URI = "https://$($Tenant)/SAAS/API/1.0/REST/auth/system/login"
    $Header = @{
        Authorization = "Bearer $($Token)"
        "Content-Type" = "application/json"
        Accept = "application/json"
    }
    $Body = @{
        "username" = "$LocalAdminUSR"
        "password" = "$LocalAdminPWD"
        "issueToken" = "true"
    } | ConvertTo-Json

    $IRMParams = @{
        Method = 'POST'
        Headers = $Header
        Body = $Body
        URI = $URI
    }
    Write-Debug $($IRMParams | out-string)
    $sessionToken = (Invoke-RestMethod @IRMParams).sessionToken
    #$sessionTokenDEC = ConvertFrom-JWT -Token $sessionToken 
    $Token = @{
        scope = "admin"
        "access_token" = "$sessionToken"
        "token_type" = "Bearer"
        "expires_in" = "$((ConvertFrom-JWT -Token $sessionToken).exp)"
        "refresh_token" = "None"
        "Tenant" = "$Tenant"
    }
    
    Return (New-Object -TypeName psobject -Property $Token)
}
