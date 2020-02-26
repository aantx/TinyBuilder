Remove-Variable * -Scope local -ErrorAction SilentlyContinue
$w = [System.Diagnostics.Stopwatch]::StartNew()
$Path = (Split-Path -Parent $PSScriptRoot)+"\MonitorHW"
Set-Location $Path
$a=(Get-Item $Path\MonitorHw.exe).VersionInfo.ProductVersionRaw
$b= [System.Version]::new($a.Major,$a.Minor+2,$a.Build,$a.Revision+1)
#& "git log" "-1 HEAD"
#ps2exe -inputFile $Path\MonitorHw.ps1 -outputFile $Path\MonitorHw.exe -x64 -requireAdmin -iconFile $Path\5.ico -title MonitorHW -product MonitorHW -copyright SPK -trademark SPK -company SPK  -description "Мониторинг оборудования компьютера" -version "$b"
"was"+$a
"become"+$b
$gitHist = (git log --format="%ai`t%h`t%an`t%s" -n 1) | ConvertFrom-Csv -Delimiter "`t" -Header ("Date", "CommitId", "Author", "Subject")
$w.stop()
$w


#git log -p -- .\MonitorHw.exe
$w.ElapsedMillisecondss