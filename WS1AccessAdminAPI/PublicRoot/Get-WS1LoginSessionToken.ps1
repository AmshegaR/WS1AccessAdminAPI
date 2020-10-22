<#
.SYNOPSIS
Request an SessionToken using Oauth2 client that supports user and password.
@Source: https://docs.hol.vmware.com/HOL-2019/hol-1957-02-uem_pdf_en.pdf

.PARAMETER Tenant
Mandatory: WS1Access Tenant.

.PARAMETER Credential
Mandatory: Local admin PS credential.

.EXAMPLE
Get-WS1LoginSessionToken -Tenant "example.vmware.com" -SetToken

.EXAMPLE
$Cred = Get-Credential
Get-WS1LoginSessionToken -Tenant "example.vmware.com" -Credential $Cred -SetToken

.EXAMPLE
$Password = ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential ("Admin", $Password)
Get-WS1LoginSessionToken -Tenant "example.vmware.com" -Credential $Cred -SetToken
#>
Function Get-WS1LoginSessionToken{
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true)][string]$Tenant,
        [switch]$SetToken,
        [Parameter()]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = (Get-Credential)
    )
    $URI = "https://$($Tenant)/SAAS/API/1.0/REST/auth/system/login"
    $LocalAdminUSR = $Credential.UserName    
    $LocalAdminPWD = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR(`
    ($Credential.Password | ConvertFrom-SecureString |  ConvertTo-SecureString ) ))
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
    try {
        $sessionToken = (Invoke-RestMethod @IRMParams).sessionToken
        $FormatToken = @{
            scope = "admin"
            "access_token" = "$sessionToken"
            "token_type" = "Bearer"
            "expires_in" = "$((ConvertFrom-JWT -Token $sessionToken).exp)"
            "refresh_token" = "None"
            "Tenant" = "$Tenant"
        }
        $Token = (New-Object -TypeName psobject -Property $FormatToken)
        If($SetToken.IsPresent){ Set-WS1SessionToken -Token $Token | Out-Null }
        $Result = @{ "Status" = $True; "Data" = $Token }
    }
    catch {
        Write-Verbose "$_.Exception.Message"
        $Result = @{ "Status" = $False; "Message" = $Error[0].Exception.Message }
    }
    Return New-Object psobject -Property $Result
}
