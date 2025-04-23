# SCRIPT - Network Ping Sweep

# Define the range of IP addresses to check
$subnet = "192.168.1"  # Change this to your subnet
$startRange = 1
$endRange = 254

Write-Host "Starting Ping: $subnet.0/24..." -ForegroundColor Cyan

# Loop through the IP range
for ($i = $startRange; $i -le $endRange; $i++) {
    $ipAddress = "$subnet.$i"
    
    # Send a single ping request and check if the machine is online
    $pingResult = Test-Connection -ComputerName $ipAddress -Count 1 -Quiet
    
    # Result
    if ($pingResult) {
        Write-Host "$ONLINE" -ForegroundColor Green
    } else {
        Write-Host "$OFFLINE" -ForegroundColor Red
    }
}

Write-Host "`nPing Sweep Completed!" -ForegroundColor Yellow