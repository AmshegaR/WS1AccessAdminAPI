Get-Help Export-WS1AppCatalog
Get-Help Export-WS1AppCatalog -Examples

#region Export single app

Export-WS1AppCatalog -Tenant "example.vmware.com" -Token $Token -AppUUID "xxxx-f6da-xxxx-b813-xxx2e31e" -SaveTo "C:\temp\example.zip"

#endregion

#region Export single application using name

$TestAppUUID = Get-WS1AppCatalog -Tenant $Token.Tenant -Token $Token.access_token -Filter @{ "nameFilter" = "board-mvc-saml" }
Export-WS1AppCatalog -Tenant $Token.Tenant -Token $Token.access_token -AppUUID $TestAppUUID.items.uuid -SaveTo "C:\Backup\$($TestAppUUID.items.name).zip"

#endregion
