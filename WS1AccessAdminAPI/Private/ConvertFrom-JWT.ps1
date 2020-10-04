<#
.SYNOPSIS
Decode JWT access_token or id_Token.
@Source: https://www.michev.info/Blog/Post/2140/decode-jwt-access-and-id-Tokens-via-powershell ©Vasil_Michev

.PARAMETER Token
Mandatory: WS1 Access Token.

.PARAMETER IncludeHeader
Optional: Return header.

.EXAMPLE
ConvertFrom-JWT -Token $Token.access_Token
#>
Function ConvertFrom-JWT {
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Token,[Alias('ih')][switch]$IncludeHeader
    )
    # Access and ID Tokens are fine, Refresh Tokens will not work
    If (!$Token.Contains(".") -or !$Token.StartsWith("eyJ")) { 
        Write-Error "Invalid Token"
        Return $false
    }
    # Extract header and payload
    $TokenHeader, $TokenPayload = $Token.Split(".").Replace('-', '+').Replace('_', '/')[0..1]
    # Fix padding as needed, keep adding "=" until string length modulus 4 reaches 0
    While ($TokenHeader.Length % 4) { Write-Debug "Invalid length For a Base-64 char array or string, adding ="; $TokenHeader += "=" }
    While ($TokenPayload.Length % 4) { Write-Debug "Invalid length For a Base-64 char array or string, adding ="; $TokenPayload += "=" }
    Write-Debug "Base64 encoded (padded) Header:`n$TokenHeader"
    Write-Debug "Base64 encoded (padded) payoad:`n$TokenPayload"
    # Convert Header from Base64 encoded string to PSObject all at once
    $Header = [System.Text.Encoding]::ASCII.GetString([system.convert]::FromBase64String($TokenHeader)) | ConvertFrom-Json
    Write-Debug "Decoded Header:`n$Header"
    # Convert payload to string array
    $TokenArray = [System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String($TokenPayload))
    Write-Debug "Decoded array in JSON format:`n$TokenArray"  
    # Convert from JSON to PSObject
    $TokOBJ = $TokenArray | ConvertFrom-Json
    Write-Debug "Decoded Payload:"
    
    If($IncludeHeader){ Return $Header }
    Return $TokOBJ
}