$NpcapUninstall = "C:\Program Files\Npcap\Uninstall.exe"
$WiresharkGUID = "{99096B34-4123-4F8E-B44E-3C5B3E654CDE}"  #The Wireshark GUID may need to be verified depending on the version used.” 

Write-Host "Uninstalling Wireshark..." -ForegroundColor Yellow
Start-Process -FilePath "msiexec.exe" -ArgumentList "/x $WiresharkGUID /qn" -Wait -NoNewWindow

if (Test-Path $NpcapUninstall) {
    Write-Host "Uninstalling Npcap..." -ForegroundColor Yellow
    Start-Process -FilePath $NpcapUninstall -ArgumentList "/S" -Wait -NoNewWindow
} else {
    Write-Host "Npcap uninstaller not found." -ForegroundColor Red
}

Write-Host "Uninstallation completed." -ForegroundColor Green
