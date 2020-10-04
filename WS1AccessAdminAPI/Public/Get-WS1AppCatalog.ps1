<#
.SYNOPSIS
Get a Catalog Application information using Hash as a sorting filter.

.PARAMETER Tenant
Mandatory: WS1 Access Tenant URL

.PARAMETER ClientID
Mandatory: Client Identifier

.PARAMETER ClientSecret
Mandatory: Client Shared secret

@{
    "nameFilter" = "Application Name"
    "categories" = @()
    "includeTypes" = @("Saml11", "Saml20", "WSFed12","WebAppLink")
    "includeAttributes" = @("labels", "uiCapabilities", "authInfo")
    "rootResource" = "false"
}

#>
function Get-WS1AppCatalog {
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true)][string]$Tenant,
        [Parameter(Mandatory=$true)][string]$Token,
        [Parameter(Mandatory=$True,ValueFromPipeline=$True)][Hashtable]$Filter
    )
    Begin{}
    Process{
        $URI = "https://$($Tenant)/SAAS/jersey/manager/api/catalogitems/search"
        $Header = @{
            Host = $Tenant
            Authorization = "HZN $($Token)"
            'Content-Type' = 'application/vnd.vmware.horizon.manager.catalog.search+json'
            Accept = 'application/vnd.vmware.horizon.manager.catalog.item.list+json'
        }
        $Body = $Filter | ConvertTo-Json
        Write-Debug "Body(Filter): $Body"
        $IRMParams = @{
            Method = 'POST'
            Headers = $Header
            Body = $Body
            URI = $URI
        }
        Write-Debug $($IRMParams | out-string)
        $AppCatalog =  Invoke-RestMethod @IRMParams
        If($AppCatalog.items){
            Return $AppCatalog
        }
        Write-Warning "Application not found"
        Return $false
    }
}