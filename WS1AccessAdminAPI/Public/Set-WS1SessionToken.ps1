<#
.SYNOPSIS
Set global hash WS1SessionToken + Set the default -Token & -Tenant Parameters Value for other cmdlets.
Mnipulate the $Global:PSDefaultParameterValues module attribute.

.PARAMETER Token
Mandatory: Token[PSCustomObject] including all params (access_token, Tenant, access_token, expires_in, refresh_token).

.EXAMPLE
Set-WS1SessionToken -Token $Token

.EXAMPLE
$Token = @{
    scope = "admin"
    access_token = "abcxxxxKXaIqc.eHaiOje2xzilmeHaiOje2xzilmeHaiOje2xzilmeHaiOje2xzilmeHaiOje2xzilm..."
    token_type = "Bearer"
    expires_in = 10799
    refresh_token = "xYzOjnUxxxKXaIqc.eHaiOje2xzilm..."
    Tenant = "example.vmware.com"
}
Set-WS1SessionToken -Token $Token

.EXAMPLE
$Params = @{
    Tenant = 'tenant01.example.com'
    ClientID = 'Example01'
    ClientSecret = 'qwerty'
}
$Token = Get-WS1AccessToken @Params
Set-WS1SessionToken -Token $Token

.EXAMPLE
$Params = @{
    Tenant = 'tenant01.example.com'
    LocalAdminUSR = 'Admin'
    LocalAdminPWD = 'qwerty'
}
$Token = Get-WS1LoginSessionToken @Params
Set-WS1SessionToken -Token $Token
#>
function Set-WS1SessionToken {
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true)][PSCustomObject]$Token
    )
    $TestAccToken = Test-WS1AccessToken -Tenant $Token.Tenant -Token $Token.access_token -ErrorAction SilentlyContinue
    If(-Not ($TestAccToken.Status)){
        Return New-Object psobject -Property @{ "Status" = $False; "Message" = $Error[0].Exception.Message }
    }
    $Script:WS1SessionToken.access_token = "$($Token.access_token)"
    $Script:WS1SessionToken.expires_in = $Token.expires_in
    $Script:WS1SessionToken.refresh_token = $Token.refresh_token
    $Script:WS1SessionToken.Tenant = $Token.Tenant
    Write-Verbose $Script:WS1SessionToken

    (Get-Command -Module WS1AccessAdminAPI -ParameterName Token).ForEach({
        $Global:PSDefaultParameterValues.Remove(
            "$($_.Name):Token"
        )
        $Global:PSDefaultParameterValues.Add(
            "$($_.Name):Token", "$($Script:WS1SessionToken.access_token)"
        )
    })

    (Get-Command -Module WS1AccessAdminAPI -ParameterName Tenant).ForEach({
        $Global:PSDefaultParameterValues.Remove(
            "$($_.Name):Tenant"
        )
        $Global:PSDefaultParameterValues.Add(
            "$($_.Name):Tenant", "$($Script:WS1SessionToken.Tenant)"
        )
    })
    Write-Verbose "$($Global:PSDefaultParameterValues)"
    Return New-Object psobject -Property @{ "Status" = $true; "Data" = "$($Global:PSDefaultParameterValues | Format-List | Out-String))" }
}
