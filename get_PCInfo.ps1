$computers =  ,"."
#Specify the list of PC names in the line above. "." means local system

function Decode {
    If ($args[0] -is [System.Array]) {
        [System.Text.Encoding]::ASCII.GetString($args[0])
    }
    Else {
        "Not Found"
    }
}

Clear-Host
$results = foreach ($computer in $computers) 
{
    Write-Verbose "Processing $computer"
    $computerSystem = Get-WmiObject Win32_ComputerSystem -Computer $computer
    $computerBIOS = Get-WmiObject Win32_BIOS -Computer $computer
    $computerOS = Get-WmiObject Win32_OperatingSystem -Computer $computer
	$computerBaseboard = Get-WmiObject win32_baseboard
    $computerCPU = Get-WmiObject Win32_Processor -Computer $computer
    #$computerNetwork = get-WmiObject Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE -Computer $computer
    $computerDisk = Get-WmiObject Win32_logicaldisk -ComputerName $computer -Filter drivetype=3 |
        select DeviceID, @{Name="Size(GB)";Expression={[decimal]("{0:N0}" -f($_.size/1gb))}}
    #$computerNet = Get-NetIPConfiguration -Detailed
	$computerGPU = Get-WmiObject Win32_VideoController -Computer $computer
	$computerRAM = Get-WmiObject win32_physicalmemory -Computer $computer
	$computerDiskDrive = Get-WMIObject win32_diskdrive -Computer $computer
	$monitor = Get-WmiObject WmiMonitorID -Namespace root\wmi
	$mouse = Get-WmiObject win32_PointingDevice
	$keyboard = Get-WmiObject win32_Keyboard 
	#$DiskPartition = $Disk.GetRelated('Win32_DiskPartition')
		Select-Object -Property DeviceID, DriveType, VolumeName, 
		@{L='FreeSpaceGB';E={"{0:N2}" -f ($_.FreeSpace /1GB)}},
		@{L="Capacity";E={"{0:N2}" -f ($_.Size/1GB)}}
    [PSCustomObject]@{
		"Computer" = $computerSystem.Name
        "Disk Drive Model" = $computerDiskDrive.model
		"Disk Drive Serial Number" = $computerDiskDrive.SerialNumber
		"Operating System" = $computerOS.caption
        #"System Manufacturer" = $computerSystem
        #Model = $computerSystem.Model
        #"Serial Number" = $computerBIOS.SerialNumber
		"Baseboard" = $computerBaseboard.Manufacturer
		"Baseboard Serial Number" = $computerBaseboard.SerialNumber
        "CPU" = $computerCPU.Name
		"GPU" = $computerGPU.Description
		"GPU ID" = $computerGPU.PNPDeviceID
        "RAM Manufacturer" = $computerRAM.Manufacturer
		"RAM Serial Number" = $computerRAM.Serialnumber
		"Monitor Manufacturer" = Decode $monitor.UserFriendlyName 
		"Monitor Serial Number" = Decode $monitor.SerialNumberID 
		"Mouse Manufacturer" = $mouse.Manufacturer, $mouse.Name
		"Mouse Serial Number" = $mouse.PNPDeviceID
		"Keyboard Manufacturer" = $keyboard.Manufacturer, $mouse.Name
		"Keyboard Serial Number" = $keyboard.PNPDeviceID
        
        #"Service Pack" = $computerOS.ServicePackMajorVersion
        #"Last Reboot" = $computerOS.ConvertToDateTime($computerOS.LastBootUpTime)
        #Network = $($computerNetwork.IPAddress)[0]
    }
}
# Sample outputs
$results | Format-Table -AutoSize
#$results | Out-GridView
#$results | Export-Csv -Path .\$computers.csv -NoTypeInformation -Encoding ASCII
$computerName = $env:computername
$results | Out-File -FilePath .\$computerName.txt -Encoding ascii
