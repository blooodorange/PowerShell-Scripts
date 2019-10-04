# List_Mailbox_Permissions.ps1
# Lists all Exchange 2010 mailboxes with Send-As & FullAccess permissions assigned

$OutFile = "C:\PermissionExport.txt"
"DisplayName" + "," + "Alias" + "," + "Full Access" + "," + "Send As" | Out-File $OutFile -Force
 
$Mailboxes = Get-Mailbox -ResultSize Unlimited | Select Identity, Alias, DisplayName, DistinguishedName
ForEach ($Mailbox in $Mailboxes) {
	$SendAs = Get-ADPermission $Mailbox.DistinguishedName | Where-Object {$_.ExtendedRights -like "Send-As" -and $_.User -notlike "NT AUTHORITY\SELF" -and !$_.IsInherited} | ForEach-Object {$_.User}
	$FullAccess = Get-MailboxPermission $Mailbox.Identity | Where-Object {$_.AccessRights -eq "FullAccess" -and !$_.IsInherited} | ForEach-Object {$_.User}
 
	$Mailbox.DisplayName + "," + $Mailbox.Alias + "," + $FullAccess + "," + $SendAs | Out-File $OutFile -Append
}
