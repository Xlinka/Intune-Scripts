
$hostname = $env:COMPUTERNAME
$ipAddress = (Get-NetIPAddress | Where-Object {$_.AddressFamily -eq 'IPv4' -and $_.InterfaceAlias -ne 'Loopback'}).IPAddress

$result = [PSCustomObject]@{
    Hostname = $hostname
    IPAddress = $ipAddress
}

$json = $result | ConvertTo-Json

Write-Output $json
