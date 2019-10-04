# Convert_sAMAccountName_to_SID.ps1

$Domain = Read-Host "Enter user's NetBIOS domain name"
$Username = Read-Host "Enter user's sAMAccountName"
$User = New-Object System.Security.Principal.NTAccount("$Domain", "$Username")
$SID = $User.Translate([System.Security.Principal.SecurityIdentifier])
Write-Host $SID.Value
