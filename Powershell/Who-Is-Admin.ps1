function CheckIsMemberOfLocalGroup($groupName) {
    $user = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
    $group = [ADSI]"WinNT://./$groupName,group"
    $members = @($group.Invoke("Members"))
    $members | ForEach-Object {
        $member = ([ADSI]$_)
        $memberName = $member.GetType().InvokeMember("Name", 'GetProperty', $null, $member, $null)
        if ($memberName -eq $user) {
            return $true
        }
    }
    return $false
}

$isAdmin = CheckIsMemberOfLocalGroup "Administrators"

$result = [PSCustomObject]@{
    User = $env:USERNAME
    IsAdmin = $isAdmin
}

$json = $result | ConvertTo-Json

Write-Output $json
