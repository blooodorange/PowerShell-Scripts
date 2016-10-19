# SID_to_sAMAccountName.ps1

$SIDInput = Read-Host "Please enter SID"
$SID = New-Object System.Security.Principal.SecurityIdentifier("$SIDInput") 
$User = $SID.Translate([System.Security.Principal.NTAccount]) 
Write-Host $User.Value
