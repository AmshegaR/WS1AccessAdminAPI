#Import WS1AccessAdminAPI Module
Import-Module WS1AccessAdminAPI\WS1AccessAdminAPI -Force
Get-Help Get-WS1AccessToken
Get-Help Get-WS1AccessToken -Examples

#Configure WS1Access environment: 
#region Option 1

$tenant = "tenant00.example.com"
$clientID = "Example00"
$secret = "abc"

$Token = Get-WS1AccessToken -Tenant $tenant -ClientID $clientID -ClientSecret $secret
Write-Host ($Token | Format-List | Out-String)

#endregion

#region Option 2

$Params = @{
    Tenant = 'tenant01.example.com'
    ClientID = 'Example01'
    ClientSecret = 'qwerty'
}

$Token = Get-WS1AccessToken @Params
Write-Host ($Token | Format-List | Out-String)

#endregion

#region Option 3

$WS1Aconfig = @'
{
    "tenant00":  {
				"tenant":"tenant00.example.com",
				"clientID":"Example00", 
				"secret":"abc"
             },
    "tenant01":  {
				"tenant":"tenant01.example.com",
				"clientID":"Example01", 
				"secret":"qwerty"
            }
}
'@

$WS1Aconfig  = $WS1Aconfig  | ConvertFrom-Json
$tenant00 = Get-WS1AccessToken -Tenant $WS1Aconfig.'tenant00'.tenant -ClientID $WS1Aconfig.'tenant00'.clientID -ClientSecret $WS1Aconfig.'tenant00'.secret
$tenant01 = Get-WS1AccessToken -Tenant $WS1Aconfig.'tenant01'.tenant -ClientID $WS1Aconfig.'tenant01'.clientID -ClientSecret $WS1Aconfig.'tenant01'.secret
Write-Host ($tenant00 | Format-List | Out-String)
Write-Host ($tenant01 | Format-List | Out-String)

#endregion