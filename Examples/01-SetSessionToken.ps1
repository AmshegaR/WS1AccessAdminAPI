#Set global hash WS1SessionToken + Set the default -Token & -Tenant Parameters Value for other cmdlets
Get-Help Set-WS1SessionToken
Get-Help Set-WS1SessionToken -Examples

#region Option 1

$Token = @{
    scope = "admin"
    access_token = "abcxxxxKXaIqc.eHaiOje2xzilmeHaiOje2xzilmeHaiOje2xzilmeHaiOje2xzilmeHaiOje2xzilm..."
    token_type = "Bearer"
    expires_in = 10799
    refresh_token = "xYzOjnUxxxKXaIqc.eHaiOje2xzilm..."
    Tenant = "example.vmware.com"
}
Set-WS1SessionToken -Token $Token
Write-Host ($WS1SessionToken | Format-List | Out-String)
Write-Host ($Global:PSDefaultParameterValues | Format-List | Out-String)

#endregion

#region Option 2

$Params = @{
    Tenant = 'tenant01.example.com'
    ClientID = 'Example01'
    ClientSecret = 'qwerty'
}
$Token = Get-WS1AccessToken @Params
Set-WS1SessionToken -Token $Token
Write-Host ($WS1SessionToken | Format-List | Out-String)
Write-Host ($Global:PSDefaultParameterValues | Format-List | Out-String)

#endregion

#region Option 3

$Params = @{
    Tenant = 'tenant01.example.com'
    LocalAdminUSR = 'Admin'
    LocalAdminPWD = 'qwerty'
}

$Token = Get-WS1LoginSessionToken @Params
Set-WS1SessionToken -Token $Token
Write-Host ($WS1SessionToken | Format-List | Out-String)
Write-Host ($Global:PSDefaultParameterValues | Format-List | Out-String)

#endregion