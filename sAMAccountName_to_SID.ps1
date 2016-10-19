# sAMAccountName_to_SID.ps1

$Domain = Read-Host "Enter Legacy Domain Name"
$Username = Read-Host "Enter sAMAccountName"
$User = New-Object System.Security.Principal.NTAccount("$Domain", "$Username")
$SID = $User.Translate([System.Security.Principal.SecurityIdentifier])
Write-Host $SID.Value
