Get-Help New-WS1LocalUser
Get-Help New-WS1LocalUser -Examples

#region Create a local user in the system directory (default directory)
New-WS1LocalUser -Tenant $token.Tenant -Token $token.access_token -UserName "Agent007" -UserEmail "Agent007@Mail.com" `
-UserPass "S@cr3tPass007" -givenName "James" -FamilyName "Bond" -SendMail $false
#endregion

#region Create a local user in a custom local directory named "Test.dom"
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
#endregion

#region Create a local user without a password
$NewUserParams = @{
    Tenant = $token.Tenant
    Token = $token.access_token
    UserName = "Agent007"
    UserEmail = "Agent007@Mail.com"
    #No password param
    givenName = "James"
    FamilyName = "Bond"
    #Send reset password email ($true)
    SendMail = $true
}
New-WS1LocalUser @NewUserParams
#endregion

#region Create a local user in the system directory (default directory) using JSON as user params descriptor
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
New-WS1LocalUserFromJson -Tenant $token.Tenant -Token $token.access_token -JSON $NewUser
#endregion

#region Bulk create local users in directory named "Test.dom"
<#
Example CSV file:
UserName,UserEmail,UserPass,givenName,FamilyName,SendMail,DirectoryName
Agent007,Agent007@Mail.com,S@cr3tPass007,James,Bond,FALSE,Test.dom
Agent008,Agent008@Mail.com,S@cr3tPass008,Harry,Palmer,FALSE,Test.dom
Agent009,Agent009@Mail.com,S@cr3tPass009,George,Smiley,FALSE,Test.dom
#>
$AgentList = Get-Content .\WS1AccessAdminAPI\Conf\LocalUsersList.csv | ConvertFrom-Csv
foreach($Agent in $AgentList){
    $NewUserParams = @{
        Tenant = $token.Tenant
        Token = $token.access_token
        UserName = $Agent.UserName
        UserEmail = $agent.UserEmail
        UserPass = $Agent.UserPass
        givenName = $Agent.givenName
        FamilyName = $Agent.FamilyName
        SendMail = [System.Convert]::ToBoolean($Agent.SendMail)
        DirectoryName = $Agent.DirectoryName
    }
    $NewAgent = New-WS1LocalUser @NewUserParams
    If($NewAgent){
        Write-Host "Secret agent: $($NewUserParams.UserName) was successfully created with ID: $($NewAgent.id)"
    } Else { Write-Host "Secret Agent: $($NewUserParams.UserName) is failed" }
}
#endregion
