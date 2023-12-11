$usedMemory = Get-WmiObject -Class Win32_OperatingSystem
$totalMemory = $usedMemory.TotalVisibleMemorySize
$freeMemory = $usedMemory.FreePhysicalMemory
$memory = (Get-WmiObject Win32_PhysicalMemory  | Measure-Object -Sum -Property Capacity).Sum / (1024*1024*1024) 

$memoryUsage = ($totalMemory - $freeMemory) / $totalMemory * 100

$cpu = Get-WmiObject -Class Win32_Processor |  Select-Object @{n="ComputerName";e={$_.systemname}},@{n="CPU";e={$_.name}}
$cpuUsage = (Get-WmiObject -Class Win32_Processor | Measure-Object -Property LoadPercentage -Average).Average

$loggedInUser = Get-WmiObject -Class Win32_ComputerSystem | Select-Object -ExpandProperty UserName
$serialNumber = Get-WmiObject win32_bios | Select-Object SerialNumber
$model = Get-WmiObject -Class Win32_ComputerSystem | Select-Object Model,Manufacturer

[PSCUStOMOBJECT]@{ 
    "ComputerName" = $env:COMPUTERNAME;
    "CurrentUser" = $loggedInUser;
    "CPU" = $cpu.CPU;
    "CPUUsage(%)" = $cpuUsage;
    "RAM(GB)"=$memory;
    "MemoryUsage(GB)" = $memoryUsage;
    "Model" = $model.Model;
    "SerialNumber" = $serialNumber.SerialNumber
    
} | ConvertTo-Json
