<#
.SYNOPSIS
Report how many users groups apps and devices exiests in the tenant (in this order).

.PARAMETER Tenant
Mandatory: WS1 Access Tenant URL

.PARAMETER Token
Mandatory: oAuth2 AccessToken

.EXEMPLE
 Get-WS1ReportUserGroupAppDevicesCount -Token $accesstoken -Tenent "vmware.exemple.com"
    
#>
function Get-WS1ReportUserGroupAppDevicesCount{
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true)][string]$Tenant,
        [Parameter(Mandatory=$true)][string]$Token
    )
    Begin{}
    Process{

        $URI = "https://$($Tenant)/SAAS/jersey/manager/api/reporting/reports/usergroupappdevicescount"
        $Header = @{
            Host = $Tenant
            Authorization = "HZN $($Token)"
            Accept = '*/*'
        }
        $IRMParams = @{
            Method = 'Get'
            Headers = $Header
            URI = $URI
        }   
        $report =  Invoke-RestMethod @IRMParams
        If($report){
            Return $report
        }
        Return $false
    }
}
