#Import WS1AccessAdminAPI Module
Import-Module WS1AccessAdminAPI -Force
Get-Command -Module WS1AccessAdminAPI

Get-Help Get-WS1LoginSessionToken
Get-Help Get-WS1LoginSessionToken -Examples

#region Option 1

$Tenant = 'tenant01.example.com'
$LocalAdminUSR = 'Admin'
$LocalAdminPWD = 'qwerty'

$Token = Get-WS1LoginSessionToken -Tenant $Tenant -LocalAdminUSR $LocalAdminUSR -LocalAdminPWD $LocalAdminPWD
Write-Host ($Token | Format-List | Out-String)

#endregion

#region Option 2

$Params = @{
    Tenant = 'tenant01.example.com'
    LocalAdminUSR = 'Admin'
    LocalAdminPWD = 'qwerty'
}

$Token = Get-WS1LoginSessionToken @Params
Write-Host ($Token | Format-List | Out-String)

#endregion
