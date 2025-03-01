while ($true) {

$process = Start-Process -FilePath "ollama" -ArgumentList "run deepseek-r1:32b" -PassThru

Write-Host "Started process ID: $($process.Id)"

Start-Sleep -Seconds 60

Stop-Process -Id $process.Id -Force

Write-Host "Killed process ID: $($process.Id)"

Start-Sleep -Seconds 2

}