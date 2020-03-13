param($Path, $File)
Set-Location $Path -ErrorAction Stop
$VersionOld=[System.Version]::new(1, 0, 0, 0)

#Predict non-existing file

$OldFileAttr=(Get-Item .\$File.exe).VersionInfo

$VersionOld = $OldFileAttr.ProductVersionRaw
$Major = $VersionOld.Major
$Minor = $VersionOld.Minor
$Build = $VersionOld.Build
$Revision = $VersionOld.Revision

#checkout to master
$PrevVersion="HEAD"
$LastExeDate = git log --format="%ai" -n 1 -- .\$File.exe
git log --format="%B" --reverse --since=$LastExeDate -- .\$File.ps1 |
    Where-Object { $_ -ne "" } | ForEach-Object {
        if ($_ -match "-A") {$Major+=1; $Minor=0; $Build = 0;$Revision = 0}
        elseif ($_ -match "-B") { $Minor+=1; $Build = 0; $Revision =0}
        elseif ($_ -match "-C") { $Build+=1; $Revision = 0}
        else {$Revision+=1}
        $PrevVersion+="^"
    }
$VersionNew = [System.Version]::new($Major, $Minor, $Build, $Revision -join ".")
$VersionNew
$ScriptBody = Get-Content .\$File.ps1 -Encoding "UTF8"
$ScriptBody.Replace("([В-я]{6})\:([0-9]*\.){3}[0-9]*", ('$1:' + $VersionNew.ToString()))
$rege = [regex] "(([Д-я]{8})\:([0-9]{2}\.){2}[0-9]{4})"
$rega=[regex]"([А-я]*)\: ([\s\w\.\,\:А-я]+?\n\n)"
$rege.Replace($str, ('$2:' + (Get-Date -Format "dd.MM.yyyy").ToString()), 1)
$str
$rega.Replace($str, ('FINISHED'), 1)
<#
(Get-Content .\$File.ps1 -Encoding "UTF8") `
    -replace "([В-я]{6})\:([0-9]*\.){3}[0-9]*", ('$1:' + $VersionNew.ToString()) `
    -replace "","" `
    -replace "", ""|
    Set-Content .\$File.ps1 -Force -Encoding "UTF8"
#>
ps2exe -inputFile $Path\$File.ps1 -outputFile $Path\$File.exe -x64 -requireAdmin `
    -iconFile $Path\icon.ico -title $File -product $File `
    -copyright $OldFileAttr.LegalCopyright -trademark $OldFileAttr.LegalTrademarks `
    -company $OldFileAttr.CompanyName  -description $OldFileAttr.Comments `
    -version "$VersionNew"|Out-Null

$ChangeLog = git diff  $PrevVersion HEAD .\$File.ps1
$ChangeLog | Set-Content .\ChangeLog.md -Encoding "OEM"