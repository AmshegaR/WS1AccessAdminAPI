Install-Module WS1AccessAdminAPI
Import-Module WS1AccessAdminAPI -force
Get-WS1LoginSessionToken -Tenant "example.vmware.com" -SetToken

#--Or using App Registration--

$Params = @{
    Tenant = 'example.vmware.com'
    ClientID = 'Admin-API'
    ClientSecret = 'xxxxxxnfTn8kavPD14Cy7xxxxxx'
    SetToken = $true
}
Get-WS1AccessToken @Params