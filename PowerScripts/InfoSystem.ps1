# SCRIPT - SYSTEM INFO CHECK

Write-Host "System Information:" -ForegroundColor Cyan

# Computer
$compName = $env:COMPUTERNAME
$os = Get-CimInstance Win32_OperatingSystem
Write-Host "Computer Name: $compName"
Write-Host "Operating: $($os.Caption) $($os.Version)"
Write-Host "System Boot Time: $($os.LastBootUpTime)"

# RAM 
$ramTotal = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
$ramFree = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
Write-Host "`nRAM:"
Write-Host "  Total: $ramTotal GB"
Write-Host "  Free:  $ramFree GB"

# CPU
$cpu = Get-CimInstance Win32_Processor
Write-Host "`nCPU:"
Write-Host "  Model: $($cpu.Name)"
Write-Host "  Cores: $($cpu.NumberOfCores)"
Write-Host "  Logical Processors: $($cpu.NumberOfLogicalProcessors)"
Write-Host "  Current Load: $($cpu.LoadPercentage)%"

# Disk 
Write-Host "`nDisk:"
Get-PSDrive -PSProvider FileSystem | ForEach-Object {
    # Calculate disk usage in GB
    $used = [math]::Round($_.Used / 1GB, 2)
    $free = [math]::Round($_.Free / 1GB, 2)
    $total = [math]::Round(($used + $free), 2)

    Write-Host "  Drive $_.Name - Total: $total GB | Used: $used GB | Free: $free GB"
}

# Network 
Write-Host "`nNetwork:"
$adapters = Get-NetIPAddress | Where-Object { $_.AddressFamily -eq "IPv4" -and $_.IPAddress -notlike "169.*" }
foreach ($adapter in $adapters) {
    Write-Host "  Interface: $($adapter.InterfaceAlias) - IP: $($adapter.IPAddress)"
}

Write-Host "`n DONE"