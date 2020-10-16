<#
.SYNOPSIS
Get user information using its ID.

.PARAMETER Tenant
Mandatory: WS1Access Tenant.

.PARAMETER Token
Mandatory: oAuth2 AccessToken.

.PARAMETER ID
Mandatory: User UUID.

.PARAMETER Attributes
Optional: Comma comma separated user attributes to retrieve.
Default value : "userName,id,active,emails"

.PARAMETER AirectoryUUID
Optional: Only specified directory.

.PARAMETER Schemas
Optional: Schema extension types for which user schema attributes needs to be included.
Default value : "urn:scim:schemas:core:1.0"

.EXAMPLE
Get-WS1UserByID -Tenant $Token.Tenant -Token $Token.access_token -ID "8b4adcb1-eb81-4456-ad23-d72e00c695d8" -Attributes *
#>
Function Get-WS1UserByID{
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true)][string]$Tenant,
        [Parameter(Mandatory=$true)][string]$Token,
        [Parameter(Mandatory=$true)][string]$ID,
        [string]$Attributes = "userName,id,active,emails",
        [string]$DirectoryUUID,
        [string]$schemas = "urn:scim:schemas:core:1.0"
    )
    $URI = "https://$($Tenant)/SAAS/jersey/manager/api/scim/Users/$($ID)?schemas"
    $Header = @{
        Authorization = "HZN $($Token)"
    }
    If($Attributes -ne "*"){ $URI += "&attributes=$($Attributes)" }
    If($DirectoryUUID){ $URI += "&directoryUuid=$($DirectoryUUID)" }
    $IRMParams = @{
        Method = 'GET'
        URI = $URI
        Header = $Header
    }
    Write-Debug $($IRMParams | out-string)
    Return  Invoke-RestMethod @IRMParams    
}
