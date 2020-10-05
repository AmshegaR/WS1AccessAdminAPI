Import-Module WS1AccessAdminAPI\WS1AccessAdminAPI -Force
$WS1Aconfig = Get-Content C:\temp\environment.json | ConvertFrom-Json

If(-not $Token){
        $Token = Get-WS1AccessToken -Tenant $WS1Aconfig.'VIDM-Preview'.tenant -ClientID $WS1Aconfig.'VIDM-Preview'.clientID -ClientSecret $WS1Aconfig.'VIDM-Preview'.secret
}


<#
#TODO: Validate token & Refresh Token
If(-not $Token){
        $Token = Get-WS1AccessToken -Tenant $WS1Aconfig."m646484007".tenant -ClientID $WS1Aconfig."m646484007".clientID -ClientSecret $WS1Aconfig."m646484007".secret
}

#TODO: Export app catalog config, Find app by app URL
$APP = Get-WS1AppCatalog -Tenant $Token.Tenant -Token $Token.access_token -Filter @{
        "nameFilter" = "TestSAML"
        "categories" = @()
        "includeTypes" = @("Saml11", "Saml20", "WSFed12","WebAppLink")
        "includeAttributes" = @("labels", "uiCapabilities", "authInfo")
        "rootResource" = "false"
}

If($APP){
        Write-host "App Name: $($App.items.name)"
        Write-host "App ID: $($App.items.uuid)"
}
#>