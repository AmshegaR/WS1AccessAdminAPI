#region Start manual sync directory

$WS1Directory = Get-WS1DirectoryConfigs -Tenant $Token.Tenant -Token $Token.access_token
$Directory = ($WS1Directory.items | Where-Object { $PSItem.type -eq 'ACTIVE_DIRECTORY_IWA' }).directoryId
Start-WS1DirectorySync -Tenant $Token.Tenant -Token $token.access_token -DirectoryID $Directory

#regionend