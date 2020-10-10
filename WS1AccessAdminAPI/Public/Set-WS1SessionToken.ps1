<#
.SYNOPSIS
Set global hash WS1SessionToken + Set the default -Token & -Tenant Parameters Value for other cmdlets.

.PARAMETER Token
Mandatory: Token[PSCustomObject] including all params (access_token, Tenant, access_token, expires_in, refresh_token).

.EXAMPLE
Set-WS1SessionToken -Token $Token
#>
function Set-WS1SessionToken {
    [cmdletbinding()]
    param(
       [Parameter(Mandatory=$true)][PSCustomObject]$Token
    )
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

    Return $Script:WS1SessionToken, $Global:PSDefaultParameterValues
}
