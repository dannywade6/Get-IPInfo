$Data = Import-CSV -Path .\Personal\Security\user_logs.csv

function Get-IPAddressGeoLocation {
    param (
        [string]$IPAddress
    )
    
    $jsonData = Invoke-WebRequest -URI "http://ip-api.com/json/$IPAddress"
    $parsedData = $jsonData.Content | ConvertFrom-Json
    $Country = $parsedData.Country
    return $Country
}

function Get-MaliciousIPAddress {
    param (
        [String]$Country
    )

    $addressIsMalicious = $false
    $addressCheck = Get-IPAddressGeoLocation -IPAddress $Country

    If ($addressCheck -eq "China" -or "Russia" -or "North Korea") {
        $addressIsMalicious = $true
    } Else {
        $addressIsMalicious = $false
    }

    return $addressIsMalicious
}

ForEach($user in $data[200..220]) {

    $IPAddressLocation = Get-IPAddressGeoLocation -IPAddress $user.ip_address

    If($IPAddressLocation -eq  "China" -Or $IPAddressLocation -eq "Russia" -Or $IPAddressLocation -eq "North Korea") {
        $outputObject = New-Object psobject -Property @{
            Country = $IPAddressLocation
            IPAddress = $user.ip_address
            Username = $user.user_name
        }
    
        $outputObject | Export-CSV -Path "C:\Dev\Scripts\Powershell\Personal\Security\IPLocations.csv" -Append -NoTypeInformation
    }
}
