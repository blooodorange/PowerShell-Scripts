# Change_userPrincipalName.ps1

$Users = Get-Content .\users.txt # format: user@domain.com
$newDomain = "newdomain.com"

Import-Module activedirectory
foreach($User in $Users){
    $Username = $User.Split("@")[0]
    $Domain	= $User.Split("@")[1]
    $ADUser = Get-ADUser $Username -Server $Domain
    $newUPN = $ADUser.UserPrincipalName.Replace($Domain,$newDomain)
    Set-ADUser -Identity $ADUser.SamAccountName -UserPrincipalName $newUPN -Server $Domain
    }
