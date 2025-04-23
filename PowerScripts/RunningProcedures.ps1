# SCRIPT - Running procedures on a database
# Check Database Information

# Database credentials
$Login = "admin"
$PassWd = "admin"
$Database = "NAME_DATA_BASE"
$Ambiente = "DEVELOPMENT"
$ServerName = "NOME_SERVER_SQL"

# Files .sql
$ScriptPath = "C:\Users\PC\Documents\Procedures"

# Temp 
$ExecutionTime = Measure-Command {
    $Cont = 0
    foreach ($path in Get-ChildItem -Path $ScriptPath -Filter *.sql -Recurse) {
        $logPath = Join-Path $ScriptPath ("log_$Cont.log")
        Write-Host "Executando: $($path.FullName)"
        Sqlcmd -S $ServerName -d $Database -U $Login -P $PassWd -i $path.FullName -o $logPath
        $Cont++
    }
}

Write-Host "Procedures run successfully!" -ForegroundColor Yellow
Write-Host "The execution took $($ExecutionTime.TotalSeconds) seconds to complete" -ForegroundColor Yellow
Read-Host "Press Enter to exit..."
