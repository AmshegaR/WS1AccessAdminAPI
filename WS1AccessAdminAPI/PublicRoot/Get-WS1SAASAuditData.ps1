<#
.SYNOPSIS
Get audit data from an SAAS envirollent of WS1.
Atention: This function doens't work in an on-prem envirollement.

.PARAMETER Tenant
Mandatory: WS1 Access Tenant URL

.PARAMETER Cookie
Mandatory: a valid Cookie that gives access to your WS1 envirollment

.EXAMPLE
Get-WS1SAASAuditDatag -Tenant $tenant -Cookie $Cookie

#>


#Requires -Version 7.0
function Get-WS1SAASAuditData{
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)][string]$Cookie,
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)][string]$Tenant,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true)][int]$toDays= 3 ,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true)][int]$fromDays = 0,
        [Parameter(Mandatory=$false, ValueFromPipeline=$true)][string]$objectName = "",
        [Parameter(Mandatory=$false, ValueFromPipeline=$true)][string]$objectAction="",
        [Parameter(Mandatory=$false, ValueFromPipeline=$true)][string]$selectedEvent =""

    )
    Begin{
        if ($toDays -gt 3 ){
            Write-Host "[-] Maximum value of toDays is 90 days"
        }
    }
    Process{

        $URI = "https://$($Tenant)/SAAS/admin/reporting/table/audit?export=csv"
        $Header = @{
            Host = $Tenant
            Cookie = $Cookie
        }
       
        $IRMParams = @{
            Method = 'GET'
            Headers = $Header
            URI = $URI
        }

        $auditData =  Invoke-RestMethod @IRMParams
        If($auditData){
            Return $auditData
        }
        Return $false
    }
}
