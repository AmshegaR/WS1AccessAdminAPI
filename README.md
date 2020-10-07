
# WS1AccessAdminAPI

PowerShell module to interact with VMware WorkSpace One Access API.

## WS1Access Configuration

App Registration: One time only
*create a service client on WS1Access*:

`Go to Catalog -> Settings.`
`Click on the "Remote App Access" -> Create Client.`
`Select Service Client Token as the Access Type.`
`Enter a client ID.`
`Click Add.`
`Create Service Client.`

![alt text](https://raw.githubusercontent.com/wiki/vmware/idm/images/OAuth2CredClient.png)
@*Source*: <https://github.com/vmware/idm/wiki/Integrating-Client-Credentials-app-with-OAuth2#app-registration-one-time-only>

## Usage

Place the *WS1AccessAdminAPI* module folder to:
`$home\Documents\WindowsPowerShell\Modules` OR `$pshome\Modules` (Win&Linux)
@*Doc*: <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_modules?view=powershell-7#how-to-install-a-module>

```Powershell
Import-Module -Name WS1AccessAdminAPI
Get-Module -Name WS1AccessAdminAPI
Get-Command -Module WS1AccessAdminAPI
```

*More usage examples could be found under 'Examples' folder.

# Suggestions and feedback

If you have any idea or suggestion - please add a github issue.
Contribution is welcome.
