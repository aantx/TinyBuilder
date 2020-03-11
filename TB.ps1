#Remove-Variable * -Scope local -ErrorAction SilentlyContinue
#param($Path, $File)
$Path ="D:\prg\Powershell\MonitorHW"
$File ="MonitorHW"
Set-Location $Path

$VersionOld=[System.Version]::new(1, 0, 0, 0)

#Predict non-existing file
$VersionOld = (Get-Item .\$File.exe).VersionInfo.ProductVersionRaw

$Major = $VersionOld.Major
$Minor = $VersionOld.Minor
$Build = $VersionOld.Build
$Revision = $VersionOld.Revision

#checkout to master
$LastExeDate = git log --format="%ai" -n 1 -- *.exe
git log --format="%B" --reverse --since=$LastExeDate -- *.ps1 |
    Where-Object { $_ -ne "" } | ForEach-Object {
            if ($_ -match "-A") {$Major+=1; $Minor=0; $Build = 0;$Revision = 0}
                elseif ($_ -match "-B") { $Minor+=1; $Build = 0; $Revision =0}
                elseif ($_ -match "-C") { $Build+=1; $Revision = 0}
            else {$Revision+=1}
        }
$VersionNew = [System.Version]::new($Major, $Minor, $Build, $Revision -join ".")
$VersionNew
(Get-Content .\$File.ps1) -replace $VersionOld.ToString(), $VersionNew.ToString()|
    out-null #Write-Host
#ps2exe -inputFile $Path\$File.ps1 -outputFile $Path\$File.exe -x64 -requireAdmin -iconFile $Path\5.ico -title $File -product $File -copyright SPK -trademark SPK -company SPK  -description "Мониторинг оборудования компьютера" -version "$b"
