<#
.SYNOPSIS
Create a new catalog application using JSON format.

.PARAMETER Tenant
Mandatory: WS1 Access Tenant URL

.PARAMETER Token
Mandatory: oAuth2 AccessToken

.PARAMETER JSON
Mandatory: Customized JSON file 

.EXAMPLE
$NewWebLink = @'
{
    "catalogItemType": "WebAppLink",
    "uuid": "85c040cf-b389-41a0-9efe-c7ca64f985c4",
    "packageVersion": "1.0",
    "name": "API Generated Weblink",
    "productVersion": null,
    "description": "Web Link Generated by API Lab",
    "authInfo": {
        "type": "WebAppLink",
        "targetUrl": "https://www.vmware.com"
    }
}
'@
New-WS1LocalUserFromJson -Tenant "Example.vmware.com" -Token $Token -JSON $NewWebLink -AppType "WebAppLink"
#>
function New-WS1LocalUserFromJson {
    [cmdletbinding()]
    param(
       [Parameter(Mandatory=$true)][string]$Tenant,
       [Parameter(Mandatory=$true)][string]$Token,
       [Parameter(Mandatory=$true)]$JSON,
       [Parameter(Mandatory=$true)][ValidateSet("WebAppLink","SAML20","OIDC")][string]$AppType
    )
    Write-Debug $JSON
    $URI = "https://$($Tenant)/SAAS/jersey/manager/api/catalogitems"
    If($AppType -eq "OIDC"){ $URI += "/oidc" }
    $Header = @{
        Authorization = "HZN $($Token)"
    }
    $Header.Add("Content-Type", "application/vnd.vmware.horizon.manager.catalog.$($AppType)+json")
    $Header.Add("Accept", "application/vnd.vmware.horizon.manager.catalog.$($AppType)+json")
        $IRMParams = @{
        Method = 'POST'
        Headers = $Header
        Body = $JSON
        URI = $URI
    }
    Write-Debug $($IRMParams | out-string)
    try {
        $NewAPP = Invoke-RestMethod @IRMParams
        Write-Verbose -Message "AppID: $($NewAPP.uuid)"
        Return $NewAPP
    }
    catch {
        Write-Debug "$_.Exception.Message"
        Return $false
    }
}