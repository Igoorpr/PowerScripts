# SCRIPT - FILE COPY WITH BACKUP

$source = "C:\Users\PC\Documents\" #base
$destination = "C:\Users\PC\Documents\Destination" #end
$backupDir = "$destination\_backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"

# Files to exclude from copy
$excludedFiles = @("web.config", "app.config")

if (!(Test-Path -Path $destination)) {
    New-Item -ItemType Directory -Path $destination -Force
}

Write-Host "Creating a backup of the current destination in: $backupDir..." -ForegroundColor Cyan
Copy-Item -Path "$destination\*" -Destination $backupDir -Recurse -Force -ErrorAction SilentlyContinue

$timeLimitHours = 24
# Set time threshold for recent files
$cutoffTime = (Get-Date).AddHours(-$timeLimitHours)

$filesToCopy = Get-ChildItem -Path $source -Recurse | Where-Object {
    $_.LastWriteTime -gt $cutoffTime -and
    $excludedFiles -notcontains $_.Name
}

# Copy the files
foreach ($file in $filesToCopy) {
    $relativePath = $file.FullName.Substring($source.Length)
    $fullDestinationPath = Join-Path $destination $relativePath

    $targetFolder = Split-Path $fullDestinationPath
    if (!(Test-Path $targetFolder)) {
        New-Item -ItemType Directory -Path $targetFolder -Force | Out-Null
    }

    Copy-Item -Path $file.FullName -Destination $fullDestinationPath -Force
}

Write-Host "`nCopy completed successfully!" -ForegroundColor Green
Write-Host "Total files copied: $($filesToCopy.Count)" -ForegroundColor Yellow