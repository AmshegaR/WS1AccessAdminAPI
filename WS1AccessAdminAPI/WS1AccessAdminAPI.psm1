#Folder function definition files.
    $private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )
    $public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1,$PSScriptRoot\Root\*.ps1 -ErrorAction SilentlyContinue )

#Dot source the files
    foreach($import in @($private + $public))
    {
        try
        {
            . $import.fullname
        }
        catch
        {
            Write-Error -Message "Failed to import function $($import.fullname): $_"
        }
    }
$WS1SessionToken = @{
    scope = "Admin"
    access_token = "Null"
    token_type = "Bearer"
    expires_in = 0
    refresh_token = "Null"
    Tenant = "example.vmware.com"
}

Export-ModuleMember -Function $public.Basename -Variable (Get-Variable -Name WS1SessionToken).name
