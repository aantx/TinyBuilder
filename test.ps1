#Remove-Variable * -Scope local -ErrorAction SilentlyContinue
# $w = [System.Diagnostics.Stopwatch]::StartNew()
# $Path = (Split-Path -Parent $PSScriptRoot)+"\MonitorHW"
# Set-Location $Path
# $a=(Get-Item $Path\MonitorHw.exe).VersionInfo.ProductVersionRaw
# $b= [System.Version]::new($a.Major,$a.Minor+2,$a.Build,$a.Revision+1)
# #& "git log" "-1 HEAD"
# #ps2exe -inputFile $Path\MonitorHw.ps1 -outputFile $Path\MonitorHw.exe -x64 -requireAdmin -iconFile $Path\5.ico -title MonitorHW -product MonitorHW -copyright SPK -trademark SPK -company SPK  -description "Мониторинг оборудования компьютера" -version "$b"
# "was"+$a
# "become"+$b
# $gitHist = (git log --format="%ai`t%h`t%an`t%s" -n 1) | ConvertFrom-Csv -Delimiter "`t" -Header ("Date", "CommitId", "Author", "Subject")
# $w.stop()
# $w


# git log -p --format="%ai" -n 1 -- .\MonitorHw.exe
# $w.ElapsedMillisecondss
$VersionOld=[System.Version]::new(1, 0, 0, 0)

#обыграть отсутствие файла
$VersionOld = (Get-Item .\*.exe).VersionInfo.ProductVersionRaw

#[System.Version]::new($VersionOld.Major, $VersionOld.Minor, $VersionOld.Build, $VersionOld.Revision)
$a = git log --format="%ai" -n 1 -- .\MonitorHw.exe
git log --format="%B" --since $a --reverse -- .\MonitorHw.ps1 | Where-Object { $_ -ne "" } |
    ForEach-Object {
        if ($_ -match "-A") {$Major=$VersionOld.Major + 1; $Minor=0; $Build = 0
            $Revision = 0
            elseif ($_ -match "-B") { $Minor = $VersionOld.Minor + 1; $Build = 0
            $Revision =0}
            elseif ($_ -match "-C") { $Build = $VersionOld.Build + 1
                $Revision = 0}
            else $Revision = $VersionOld.Revision + 1 }
    }
$VersionNew = [System.Version]::new($Major, $Minor, $Build, $revision -join ".")
$VersionNew