
Get-Content Tamplate\WebLinks.csv | ConvertFrom-Csv | ForEach-Object {
    $WebLinkTemplate = @{
        catalogItemType = "WebAppLink"
        uuid = "$((New-Guid).Guid)"
        packageVersion = "1.0"
        name = "$($PSItem.name)"
        description = "$($PSItem.description)"
        authInfo = @{
            type="WebAppLink"; 
            targetUrl="$($PSItem.targetUrl)"
        }
    } | ConvertTo-Json
    New-WS1AppCatalogFromJSON -JSON $WebLinkTemplate -AppType "WebAppLink"
}
