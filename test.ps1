#Remove-Variable * -Scope local -ErrorAction SilentlyContinue
Set-Location D:\prg\Powershell\MonitorHW

$VersionOld=[System.Version]::new(1, 0, 0, 0)

#Predict non-existing file
$VersionOld = (Get-Item .\MonitorHw.exe).VersionInfo.ProductVersionRaw

$Major = $VersionOld.Major
$Minor = $VersionOld.Minor
$Build = $VersionOld.Build
$Revision = $VersionOld.Revision

#checkout to master
$a = git log --format="%ai" -n 1 -- .\MonitorHw.exe
git log --format="%B" --since $a --reverse -- .\MonitorHw.ps1 |
    Where-Object { $_ -ne "" } | ForEach-Object {
            if ($_ -match "-A") {$Major+=1; $Minor=0; $Build = 0;$Revision = 0}
                elseif ($_ -match "-B") { $Minor+=1; $Build = 0; $Revision =0}
                elseif ($_ -match "-C") { $Build+=1; $Revision = 0}
            else {$Revision+=1}
        }
$VersionNew = [System.Version]::new($Major, $Minor, $Build, $Revision -join ".")

(Get-Content .\MonitorHw.ps1) -replace $VersionOld.ToString(), $VersionNew.ToString()|
    out-null #Write-Host
#ps2exe -inputFile $Path\MonitorHw.ps1 -outputFile $Path\MonitorHw.exe -x64 -requireAdmin -iconFile $Path\5.ico -title MonitorHW -product MonitorHW -copyright SPK -trademark SPK -company SPK  -description "Мониторинг оборудования компьютера" -version "$b"
