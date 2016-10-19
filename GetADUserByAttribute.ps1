# GetADUserByAttribute.ps1

$CSVPath = ""
$Attribute = ""

Import-Module activedirectory
$Domains = (Get-ADForest).Domains
ForEach ($Domain in $Domains){
    Get-ADUser -Filter * -Properties * -Server $Domain -ResultPageSize 50000 | Where-Object {$_.$Attribute -ne $null} | Select-Object Name, $Attribute, CanonicalName | Export-Csv -NoTypeInformation -Path $CSVPath
    }
