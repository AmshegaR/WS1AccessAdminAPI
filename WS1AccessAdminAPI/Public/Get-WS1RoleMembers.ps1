<#
.SYNOPSIS
Get all users and groups assigned to na application.

.PARAMETER Tenant
Mandatory: WS1 Access Tenant URL

.PARAMETER Token
Mandatory: oAuth2 AccessToken

.PARAMETER RoleName
Mandatory: The name of the role
Available values : Administrator, AdminAPI

.EXEMPLE
 Get-WS1RoleMembers -Token $accesstoken -Tenent "vmware.exemple.com" -RoleMember "Administrator"
    
#>
function Get-WS1RoleMembers{
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)][string]$Tenant,
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)][string]$Token,
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)] [ValidateSet("Administrator", "AdminAPI")][string]$RoleName
    )
    Begin{}
    Process{

        $URI = "https://$($Tenant)​/SAAS​/jersey​/manager​/api​/reporting​/reports​/roles"
        $Header = @{
            Host = $Tenant
            Authorization = "HZN $($Token)"
            Accept = '*/*'
        }
        $Body = {
            roleName = $RoleName
        }
        $IRMParams = @{
            Method = 'Get'
            Headers = $Header
            URI = $URI
            Body =$body
        }   
        $roleMembers =  Invoke-RestMethod @IRMParams
        If($AppCatalog){
            Return $roleMembers
        }
        Return $false
    }
}
