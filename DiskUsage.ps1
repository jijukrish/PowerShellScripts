$File = Get-Content -Path c:\powershell_scripts\Servers.txt



#the disk $DiskReport variable checks all servers returned by the $File variable (line 37)

$DiskReport = ForEach ($Servernames in ($File)) 

{Get-WmiObject win32_logicaldisk <#-Credential $RunAccount#> `
-ComputerName $Servernames -Filter "Drivetype=3" `
-ErrorAction SilentlyContinue | 

#return only disks with
#free space less  
#than or equal to 0.1 (10%)

Where-Object {   ($_.freespace/$_.size) -le '0.1'}

} 


$DiskReport | 

Select-Object @{Label = "Server Name";Expression = {$_.SystemName}},
@{Label = "Drive Letter";Expression = {$_.DeviceID}},
@{Label = "Total Capacity (GB)";Expression = {"{0:N1}" -f( $_.Size / 1gb)}},
@{Label = "Free Space (GB)";Expression = {"{0:N1}" -f( $_.Freespace / 1gb ) }},
@{Label = 'Free Space (%)'; Expression = {"{0:P0}" -f ($_.freespace/$_.size)}} |

#Export report to CSV file (Disk Report)

Export-Csv -path "c:\powershell_scripts\DiskReport_$logDate.csv" -NoTypeInformation
