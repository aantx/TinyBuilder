param($Path, $File)
Set-Location $Path -ErrorAction Stop
$VersionOld=[System.Version]::new(1, 0, 0, 0)

#If path do not contains basic exe
if (-not (Test-Path -Path .\$File.exe)){
    Write-Host "Исполняемый файл не найден. Введите"
    $Major = Read-Host "Введите мажорную версию:"
    $Minor = Read-Host "Введите минорную версию:"
    $Build = Read-Host "Введите версию билда:"
    $Revision = Read-Host "Введите номер ревизии:"
    $VersionNew = [System.Version]::new($Major, $Minor, $Build, $Revision -join ".")
    ps2exe -inputFile $Path\$File.ps1 -outputFile $Path\$File.exe -x64 -requireAdmin `
        -title $File -product $File -version "$VersionNew" | Out-Null
    exit
}

$OldFileAttr=(Get-Item .\$File.exe).VersionInfo
$VersionOld = $OldFileAttr.ProductVersionRaw
$Major = $VersionOld.Major
$Minor = $VersionOld.Minor
$Build = $VersionOld.Build
$Revision = $VersionOld.Revision

#checkout to master
$PrevVersion="HEAD"
$LastExeDate = &git log --format=`"%ai`" -n 1 -- ".\$File.exe"
git log --format="%B" --reverse --since=$LastExeDate -- .\$File.ps1 |
    Where-Object { $item -ne "" } | ForEach-Object {
        if ($item -match "-A") {$Major+=1; $Minor=0; $Build = 0;$Revision = 0}
        elseif ($item -match "-B") { $Minor+=1; $Build = 0; $Revision =0}
        elseif ($item -match "-C") { $Build+=1; $Revision = 0}
        else {$Revision+=1}
        $PrevVersion+="^"
    }
$VersionNew = [System.Version]::new($Major, $Minor, $Build, $Revision -join ".")
$VersionNew
[Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding("UTF-8")
$GitOut = '$1: ' + (git log -1 --format="%B" -- .\$File.ps1)

$ScriptBody=Get-Content .\$File.ps1 -Encoding "UTF8"
#hardcoded synopsis. it supposed to be in first 100 strs of script.
foreach ($i in (0..100)){
    $ScriptBody[$i] = ([regex] "(Версия)\:([0-9]*\.){3}[0-9]*").Replace($ScriptBody[$i], '$1:' + $VersionNew.ToString(), 1)
    $ScriptBody[$i] = ([regex] "(Изменения)\: ([ \w\.\,\:A-zА-я]*)").Replace($ScriptBody[$i], $GitOut , 1)
    $ScriptBody[$i] = ([regex] "(создания)\:([0-9]{2}\.){2}[0-9]{4}").Replace($ScriptBody[$i], '$1:' + (Get-Date -Format "dd.MM.yyyy").ToString(), 1)
}
Set-Content .\$File.ps1 -Value $ScriptBody -Force -Encoding "UTF8"
ps2exe -inputFile $Path\$File.ps1 -outputFile $Path\$File.exe -x64 -requireAdmin `
    -iconFile $Path\icon.ico -title $File -product $File `
    -copyright $OldFileAttr.LegalCopyright -trademark $OldFileAttr.LegalTrademarks `
    -company $OldFileAttr.CompanyName  -description $OldFileAttr.Comments `
    -version "$VersionNew"|Out-Null

[Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding("cp866")

$ChangeLog = git diff  $PrevVersion HEAD .\$File.ps1
$ChangeLog | Set-Content .\ChangeLog.md -Encoding "OEM"
