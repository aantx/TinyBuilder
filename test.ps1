Remove-Variable * -Scope local -ErrorAction SilentlyContinue
$w = [System.Diagnostics.Stopwatch]::StartNew()

$a=(Get-Item $PSScriptRoot\MonitorHw.exe).VersionInfo.ProductVersionRaw#.ToString()
#ps2exe -inputFile $PSScriptRoot\MonitorHw.ps1 -outputFile $PSScriptRoot\MonitorHw.exe -x64 -requireAdmin -iconFile $PSScriptRoot\5.ico -title MonitorHW -product MonitorHW -copyright SPK -trademark SPK -company SPK  -description "Мониторинг оборудования компьютера" -version 1.0

$w.stop()
$w.ElapsedMillisecondss