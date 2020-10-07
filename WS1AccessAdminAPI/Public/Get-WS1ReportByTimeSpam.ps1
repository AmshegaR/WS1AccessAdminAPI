<#
.SYNOPSIS
Get a report of the users that have logged in for a given time interval.

.PARAMETER Tenant
Mandatory: WS1 Access Tenant URL

.PARAMETER Token
Mandatory: oAuth2 AccessToken

.PARAMETER fromDays
Include logins no older than this many days ago, from today

Default value : 3

.PARAMETER toDays
Include login no newer than this many days from today, 0=today

Default value : 0

.PARAMETER startIndex
Use offset to page through the results

Default value : 0

.PARAMETER pageSize
Max page size of the results, max allowed value is 5000

Default value : 5000

.EXEMPLE
 Get-WS1ReportByTimeSpam -Token $Token.access_token -Tenant $Token.Tenant 
    

#>
function Get-WS1ReportByTimeSpam{
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true)][string]$Tenant,
        [Parameter(Mandatory=$true)][string]$Token,
        [Parameter(Mandatory=$false)][int]$fromDays=3,
        [Parameter(Mandatory=$false)][int]$toDays=0,
        [Parameter(Mandatory=$false)][int]$startIndex=0,
        [Parameter(Mandatory=$false)][int]$pageSize=5000
    )
    Begin{

        #param validation
        if($pageSize -gt 5000){
            Write-Error "Requested paged size exeeds maximum allowed size (5000)."
            return false
        }     

    }
    Process{
       

        $URI = "https://$($Tenant)/SAAS/jersey/manager/api/reporting/reports/recentusers"
        $Header = @{
            Host = $Tenant
            Authorization = "HZN $($Token)"
            Accept = '*/*'
        }
        $Body = @{
            fromDays=$fromDays
            toDays=$toDays
            startIndex=$startIndex
            ageSize=$pageSize
        }
        $IRMParams = @{
            Method = 'Get'
            Headers = $Header
            URI = $URI
            #Body = $Body
        }   
        $report =  Invoke-RestMethod @IRMParams -Body $Body
        If($report){
            Return $report
        }
        Return $false
    }
}
