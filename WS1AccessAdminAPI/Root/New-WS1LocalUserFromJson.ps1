<#
.SYNOPSIS
Create a local user using JSON format.
Local users can be created in the system directory (the default) or a defined local directory.
Source: https://github.com/vmware/idm/wiki/SCIM-guide#create-a-local-user

.PARAMETER Tenant
Mandatory: WS1 Access Tenant URL

.PARAMETER Token
Mandatory: oAuth2 AccessToken

.PARAMETER JSON
Mandatory: Customized JSON file 

.PARAMETER SendMail
Optional: Whether or not to send email to set the password.

.EXAMPLE
$NewUser = @'
{
    "emails": [
        {
            "value": "Agent007@mail.com"
        }
    ],
    "name": {
        "familyName": "Bond",
        "givenName": "James"
    },
    "password": "S@cr3tPass007",
    "schemas": [
        "urn:scim:schemas:core:1.0"
    ],
    "userName": "Agent007"
}
'@
New-WS1LocalUserFromJson -Tenant "Example.vmware.com" -Token $Token -JSON $NewUser
#>
function New-WS1LocalUserFromJson {
    [cmdletbinding()]
    param(
       [Parameter(Mandatory=$true)][string]$Tenant,
       [Parameter(Mandatory=$true)][string]$Token,
       [Parameter(Mandatory=$true)]$JSON,
       [bool]$SendMail = $true
    )
    Write-Debug $JSON
    $URI = "https://$($Tenant)/SAAS/jersey/manager/api/scim/Users?attributes=id&sendMail=$($SendMail)"
    $Header = @{
        'Content-Type' = 'application/json'
        Authorization = "HZN $($Token)"
    }
    $IRMParams = @{
        Method = 'POST'
        Headers = $Header
        Body = $JSON
        URI = $URI
    }
    Write-Debug $($IRMParams | out-string)
    try {
        $NewUser = Invoke-RestMethod @IRMParams
        Write-Verbose -Message "UserID: $($test.id)"
        Return $NewUser
    }
    catch {
        Write-Debug "$_.Exception.Message"
        Return $false
    }
}
