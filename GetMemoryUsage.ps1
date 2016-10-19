# GetMemoryUsage.ps1

$ComputerName = $ENV:ComputerName
$ComputerSystem = Get-WmiObject -ComputerName $ComputerName -Class Win32_operatingsystem -Property CSName, TotalVisibleMemorySize, FreePhysicalMemory
$MachineName = $ComputerSystem.CSName
$FreePhysicalMemory = ($ComputerSystem.FreePhysicalMemory) / (1mb)
$TotalVisibleMemorySize = ($ComputerSystem.TotalVisibleMemorySize) / (1mb)
$TotalVisibleMemorySizeR = "{0:N2}" -f $TotalVisibleMemorySize
$TotalFreeMemPerc = ($FreePhysicalMemory/$TotalVisibleMemorySize)*100
$TotalFreeMemPercR = "{0:N2}" -f $TotalFreeMemPerc
Write-Host "Name: $MachineName - Total RAM: $TotalVisibleMemorySizeR GB - Free Physical Memory: $TotalFreeMemPercR %"
