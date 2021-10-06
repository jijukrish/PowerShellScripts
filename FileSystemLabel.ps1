$computername = "server1"
$scritblock = {
  param($hostname)
  $driveObj = Invoke-Command -ComputerName $hostname {Get-Volume }
  Write-Host $driveObj
  $driveObj | For-Each-Object {
    if($_.FileSystemLabel -eq 'C'){
      Invoke-Command -computername $hostname { Set-Volume -FileSystemLabel "C" -NewFileSystemLabel "Windows" }
      #Repeat above command for all required drives
      }
  }

}-ArgumentList $computername
