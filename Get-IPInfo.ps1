 $Data = Import-CSV -Path C:\Temp\Get-MaliciousIPAddress\user_logs.csv

function Get-IPAddressGeoLocation {
    param (
        [string]$IPAddress
    )
    
    $jsonData = Invoke-WebRequest -URI "http://ip-api.com/json/$IPAddress"
    $parsedData = $jsonData.Content | ConvertFrom-Json
    $Country = $parsedData.Country
    return $Country
}

ForEach($user in $data[200..220]) {

    $IPAddressLocation = Get-IPAddressGeoLocation -IPAddress $user.ip_address

    If($IPAddressLocation -eq  "China" -Or $IPAddressLocation -eq "Russia" -Or $IPAddressLocation -eq "North Korea") {
        $outputObject = New-Object psobject -Property @{
            Country = $IPAddressLocation
            IPAddress = $user.ip_address
            Username = $user.user_name
        }
    
        $outputObject | Export-CSV -Path "C:\temp\Get-MaliciousIPAddress\IPLocations.csv" -Append -NoTypeInformation
    }
} 
