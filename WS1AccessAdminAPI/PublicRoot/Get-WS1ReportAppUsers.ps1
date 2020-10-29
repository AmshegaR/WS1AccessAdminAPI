<#
.SYNOPSIS
Get all users and groups assigned to an catalog application.

.PARAMETER Tenant
Mandatory: WS1 Access Tenant URL

.PARAMETER AppName
Mandatory: Application Identifier

.PARAMETER Token
Mandatory: oAuth2 AccessToken

.EXEMPLE
 Get-WS1ReportAPPUsers -Token $accesstoken -Tenent "vmware.exemple.com" -appname "Application_Name"
#>
function Get-WS1ReportAppUsers{
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true)][string]$Tenant,
        [Parameter(Mandatory=$true)][string]$Token,
        [Parameter(Mandatory=$True,ValueFromPipeline=$True)]$AppUUID
    )
    Begin{
        $Header = @{
            Host = $Tenant
            Authorization = "HZN $($Token)"
            Accept = '*/*'
        }
    }
    Process{
        $URI = "https://$($Tenant)/SAAS/jersey/manager/api/reporting/reports/appentitlement?appId=$($AppUUID)"
        $IRMParams = @{
            Method = 'Get'
            Headers = $Header
            URI = $URI
        }
        $AppCatalog =  Invoke-RestMethod @IRMParams
        If($AppCatalog){
            Return $AppCatalog
        }
        Return $false
    }
}
