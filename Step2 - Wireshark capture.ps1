$EthernetAdapter = Get-NetAdapter | Where-Object { 
    $_.Status -eq 'Up' -and $_.InterfaceDescription -notmatch 'Wi-Fi|Bluetooth|Virtual'
} | Select-Object -First 1

if (-not $EthernetAdapter) {
    Write-Host "No active Ethernet interface found. Exiting..."
    exit 1
}

$InterfaceName = $EthernetAdapter.Name

$tsharkPath = "C:\Program Files\Wireshark\tshark.exe"
$CaptureFile = "$env:USERPROFILE\Desktop\capture.pcap"  #Save it to the desktop on your profile, or you can change the location to a shared folder

if (-not (Test-Path $tsharkPath)) {
    Write-Host "tshark not found at $tsharkPath. Exiting..."
    exit 1
}

$CaptureDuration = 300  #You can adjust it as you like

$Arguments = @(
    "-i `"$InterfaceName`"",
    "-a duration:$CaptureDuration",
    "-w `"$CaptureFile`""
) -join ' '

try {
    & "$tsharkPath" $Arguments.split()
    Write-Host "Capture completed: $CaptureFile"
}
catch {
    Write-Host "Error occurred: $_"
    exit 1
}