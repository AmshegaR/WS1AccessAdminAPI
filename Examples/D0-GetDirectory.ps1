Get-Help Get-WS1DirectoryConfigs
Get-Help Get-WS1DirectoryConfigs -Examples

#Get directory list
$WS1Directory = Get-WS1DirectoryConfigs -Tenant $Token.Tenant -Token $Token.access_token
($WS1Directory.items | Format-List * | Out-String)

#Directory types
($WS1Directory.items.type | Format-List | Out-String)

#Sync configuration enabled
Write-Host ($WS1Directory.items.syncConfigurationEnabled | Format-List | Out-String)
