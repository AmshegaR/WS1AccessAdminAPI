<#
.SYNOPSIS
Get a Catalog Application information using Hash as a sorting filter.

.PARAMETER Tenant
Mandatory: WS1 Access Tenant URL

.PARAMETER Token
Mandatory: oAuth2 AccessToken

.PARAMETER Filter
Mandatory: HashTable format filter

.PARAMETER Property
Select a single property to be retrived

.EXAMPLE
Get-WS1AppCatalog "TestApp"

.EXAMPLE
Get-WS1AppCatalog TestApp -property UUID | Select-Object -ExpandProperty Data

.EXAMPLE
"TestApp" | Get-WS1AppCatalog

.EXAMPLE
Get-WS1AppCatalog -Filter @{"nameFilter" = "TestApp"; "includeAttributes" = @("labels","uiCapabilities","authInfo")}

.EXAMPLE
Get-WS1AppCatalog -Filter @{"nameFilter" = "TestApp"} | Select-Object @{Label = "UUID"; Expression = {$PSItem.Data.UUID}} | Select-Object -ExpandProperty UUID

.EXAMPLE
(Get-WS1AppCatalog "TestApp").Data.UUID
#>
function Get-WS1AppCatalog {
    [CmdletBinding(DefaultParameterSetName='AppName')]
    param(
        [Parameter(Mandatory=$true)][string]$Tenant,
        [Parameter(Mandatory=$true)][string]$Token,
        [Parameter(Mandatory=$true,ValueFromPipeline=$True,ParameterSetName='AppName',Position=0)][string]$AppName,
        [Parameter(Mandatory=$true,ParameterSetName='Filter')][Hashtable]$Filter,
        [string]$Property
    )
    Begin{
        $URI = "https://$($Tenant)/SAAS/jersey/manager/api/catalogitems/search"
        $Header = @{
            Host = $Tenant
            Authorization = "HZN $($Token)"
            'Content-Type' = 'application/vnd.vmware.horizon.manager.catalog.search+json'
            Accept = 'application/vnd.vmware.horizon.manager.catalog.item.list+json'
        }
        $IRMParams = @{
            Method = "POST"
            Headers = $Header
            Body = $false
            URI = $URI
        }
    }
    Process{
        Write-Debug "Body(Filter): $Body"
        Switch ($PSBoundParameters.Keys) {
            "AppName" {
                $Filter = @{"nameFilter" = $AppName}
                $IRMParams.Body = $Filter | ConvertTo-Json
                break;
             }
             "Filter" {
                $IRMParams.Body = $Filter | ConvertTo-Json
                break;
             }
        }
        Write-Debug $($IRMParams | out-string)
        try {
            $AppCatalog =  Invoke-RestMethod @IRMParams
            If($AppCatalog.items){
                $Result = @{ "Status" = $True; "Data" = $AppCatalog.items }
            }else {
                Write-Warning "Application not found - $($Filter.Values)"
                $Result = @{ "Status" = $false; "Data" = "N/A" }
            }
        }
        catch {
            Write-Verbose "$_.Exception.Message"
            $Result = @{ "Status" = $False; "Message" = $Error[0].Exception.Message }
        }
        If($property){
            Return $Result.Data."$($property)"
        }
        Return New-Object psobject -Property $Result
    }
}
