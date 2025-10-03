$file = "C:\FILE.rpt"

$server = "Server\Name"
$database = "Name"
$user = "user"
$password = "password"

$lines = Get-Content -Path $file -Encoding UTF8

$sqlBlock = ""
$counter = 0

foreach ($line in $lines) {
    if ($line.Trim().ToUpper() -eq "GO") {
        if ($sqlBlock.Trim().Length -gt 0) {
            $tmpFile = [System.IO.Path]::GetTempFileName() + "_" + [System.Guid]::NewGuid().ToString() + ".sql"
            Set-Content -Path $tmpFile -Value $sqlBlock -Encoding UTF8

            $counter++
            Write-Host "Executing block $counter..."

            & sqlcmd -S $server -d $database -U $user -P $password -i $tmpFile

            Remove-Item -Path $tmpFile -Force
            $sqlBlock = ""
        }
    } else {
        $sqlBlock += "$line`r`n"
    }
}

if ($sqlBlock.Trim().Length -gt 0) {
    $tmpFile = [System.IO.Path]::GetTempFileName() + "_" + [System.Guid]::NewGuid().ToString() + ".sql"
    Set-Content -Path $tmpFile -Value $sqlBlock -Encoding UTF8

    $counter++
    Write-Host "Executing block $counter..."

    & sqlcmd -S $server -d $database -U $user -P $password -i $tmpFile

    Remove-Item -Path $tmpFile -Force
}

Write-Host "`nCompleted. Total blocks executed: $counter"
