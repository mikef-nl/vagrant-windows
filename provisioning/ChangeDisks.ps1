#Afer cloning dirveletter in the templat get reset because of the customization.
$drv = Get-WmiObject win32_volume -filter 'DriveLetter = "D:"'
$drv.DriveLetter = "Z:"
$drv.Put() | out-null


#Get the RAW disks and Initialize, Partition and Format them 
Get-Disk |
Where partitionstyle -eq 'raw' |
Initialize-Disk -PartitionStyle MBR -PassThru |
New-Partition -AssignDriveLetter -UseMaximumSize |
Format-Volume -FileSystem NTFS -NewFileSystemLabel "DATA-Changed" -Confirm:$false