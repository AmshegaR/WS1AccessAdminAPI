<#
.SYNOPSIS
Create a local user.
Local users can be created in the system directory (the default) or a defined local directory.
Source: https://github.com/vmware/idm/wiki/SCIM-guide#create-a-local-user

.PARAMETER Tenant
Mandatory: WS1 Access Tenant URL

.PARAMETER Token
Mandatory: oAuth2 AccessToken

.PARAMETER DirectoryName
Optional: Create a local user in a custom local directory

.PARAMETER UserName
Mandatory: User name of the new user

.PARAMETER UserEmail
Mandatory: User name of the new user

.PARAMETER UserPass
Mandatory: Password of the new user

.PARAMETER givenName
Mandatory: First Name of the new user

.PARAMETER FamilyName
Mandatory: Last Name of the new user

.PARAMETER SendMail
Optional: Whether or not to send email to set the password.

Default value : True

.EXAMPLE
New-WS1LocalUser -Tenant $token.Tenant -Token $token.access_token -UserName "Agent007" -UserEmail "Agent007@Mail.com" `
-UserPass "S@cr3tPass007" -givenName "James" -FamilyName "Bond" -SendMail $false -DirectoryName "Test.dom"

.EXAMPLE
$NewUserParams = @{
    Tenant = $token.Tenant
    Token = $token.access_token
    UserName = "Agent007"
    UserEmail = "Agent007@Mail.com"
    UserPass = "S@cr3tPass007"
    givenName = "James"
    FamilyName = "Bond"
    SendMail = $false
    DirectoryName = "Test.dom"
    Debug = $true
}
New-WS1LocalUser @NewUserParams

#>
function New-WS1LocalUser {
    [cmdletbinding()]
    param(
       [Parameter(Mandatory=$true)][string]$Tenant,
       [Parameter(Mandatory=$true)][string]$Token,
       [Parameter(Mandatory=$true)][string]$UserName,
       [Parameter(Mandatory=$true)][mailaddress]$UserEmail,
       [Parameter(Mandatory=$true)][string]$UserPass,
       [Parameter(Mandatory=$true)][string]$givenName,
       [Parameter(Mandatory=$true)][string]$FamilyName,
       [string]$DirectoryName = $false,
       [bool]$SendMail = $true
    )

    $UserProps = @{
        emails   = $UserEmail
        name     = @{familyName=$FamilyName; givenName=$givenName}
        password = $UserPass
        schemas  = @("urn:scim:schemas:core:1.0")
        userName = $UserName
    }
    If($DirectoryName){
        $Schema = "urn:scim:schemas:extension:workspace:1.0"
        $UserProps.schemas = @("urn:scim:schemas:core:1.0", $Schema)
        $UserProps.Add($Schema, @{domain=$DirectoryName})
    }
    
    Return New-WS1LocalUserFromJson -Tenant $Tenant -Token $Token -JSON $($UserProps | ConvertTo-Json) -SendMail $SendMail
}
