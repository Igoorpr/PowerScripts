# SCRIPT - Check Suspicious File Modifications in Sensitive Folders

# Folders
$sensitiveFolders = @(
    "C:\Windows\System32",   # System
    "C:\Program Files",      # Program
    "C:\Users\Public",      
    "C:\Users\youruser\Documents" 
)

# time period modifications
$timeLimit = (Get-Date).AddHours(-24)

# Fuctions
function Check-ModifiedFiles {
    param (
        [string]$folderPath
    )

    Write-Host "Checking folder: $folderPath" -ForegroundColor Cyan

    $files = Get-ChildItem -Path $folderPath -Recurse -File

    $modifiedFiles = $files | Where-Object { $_.LastWriteTime -gt $timeLimit }

    if ($modifiedFiles.Count -gt 0) {
        Write-Host "`nFound suspicious modified files:" -ForegroundColor Red
        $modifiedFiles | ForEach-Object {
            Write-Host "  File: $($_.FullName) | Last Modified: $($_.LastWriteTime)"
        }
    } else {
        Write-Host "`nNo suspicious files found in $folderPath" -ForegroundColor Green
    }
}

function Check-SensitiveFiles {
    foreach ($folder in $sensitiveFolders) {
        if (Test-Path $folder) {
            Check-ModifiedFiles -folderPath $folder
        } else {
            Write-Host "`nFolder $folder does not exist or is inaccessible." -ForegroundColor Yellow
        }
    }
}

# Check
Write-Host "Starting to check sensitive folders for suspicious file modifications..." -ForegroundColor Cyan
Check-SensitiveFiles
Write-Host "`nCheck completed." -ForegroundColor Cyan
