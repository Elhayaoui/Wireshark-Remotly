$SourcePath = "\\sharedpath\npcap-0.96.exe"
$WiresharkPath = "\\sharedpath\Wireshark-4.2.10-x64.msi"
$DestinationFolder = "C:\wireinstall"
$NpcapFile = "$DestinationFolder\npcap-0.96.exe"
$WiresharkFile = "$DestinationFolder\Wireshark-4.2.10-x64.msi"
$NpcapService = "npcap"

if (!(Test-Path $DestinationFolder)) { New-Item -ItemType Directory -Path $DestinationFolder -Force | Out-Null }

Copy-Item -Path $SourcePath -Destination $NpcapFile -Force -ErrorAction Stop
Copy-Item -Path $WiresharkPath -Destination $WiresharkFile -Force -ErrorAction Stop
if (!(Test-Path $NpcapFile)) { Write-Host "Error: Npcap file not found." -ForegroundColor Red; exit 1 }
if (!(Test-Path $WiresharkFile)) { Write-Host "Error: Wireshark file not found." -ForegroundColor Red; exit 1 }

Start-Process -FilePath $NpcapFile -ArgumentList "/S" -Wait -NoNewWindow
Start-Sleep -Seconds 5

Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$WiresharkFile`" /qn" -Wait -NoNewWindow
Start-Sleep -Seconds 5

$Service = Get-Service -Name $NpcapService -ErrorAction SilentlyContinue
if ($Service -and $Service.Status -eq "Running") {
    Write-Host "Npcap installed successfully." -ForegroundColor Green
} else {
    Write-Host "Error: Npcap installation failed." -ForegroundColor Red; exit 1
}

Write-Host "Wireshark installation completed." -ForegroundColor Green

Remove-Item -Path $DestinationFolder -Recurse -Force
