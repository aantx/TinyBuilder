param($Path, $File)
#$Path = "D:\prg\Powershell\MonitorHW"
#$File="MonitorHw"
function ConvertTo-Encoding ([string]$From, [string]$To) {
    Begin {
        $encFrom = [System.Text.Encoding]::GetEncoding($from)
        $encTo = [System.Text.Encoding]::GetEncoding($to)
    }
    Process {
        $bytes = $encTo.GetBytes($_)
        $bytes = [System.Text.Encoding]::Convert($encFrom, $encTo, $bytes)
        $encTo.GetString($bytes)
    }
}

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

$GitOut = '$1: ' + (git log -1 --format="%B" -- .\$File.ps1) #| ConvertTo-Encoding "cp866" "utf-8"

$ScriptBody=Get-Content .\$File.ps1 -Encoding "UTF8"
foreach ($i in (0..100)){
    $ScriptBody[$i] = ([regex] "(Версия)\:([0-9]*\.){3}[0-9]*").Replace($ScriptBody[$i], '$1:' + $VersionNew.ToString(), 1)
    $ScriptBody[$i] = ([regex] "(Изменения)\: ([ \w\.\,\:A-zА-я]*)").Replace($ScriptBody[$i], $GitOut , 1)
    $ScriptBody[$i] = ([regex] "(создания)\:([0-9]{2}\.){2}[0-9]{4}").Replace($ScriptBody[$i], '$1:' + (Get-Date -Format "dd.MM.yyyy").ToString(), 1)
}
#$ScriptBody> .\1.txt
#Set-Content $ScriptBody -Path .\1.ps1 -Force -Encoding "UTF8"

<#
        $process=Start-Process $gitPath -ArgumentList $ArgumentsList -NoNewWindow -PassThru -Wait -RedirectStandardError $gitErrorPath -RedirectStandardOutput $gitOutputPath


$ScriptBody.Replace("(Версия)\:([0-9]*\.){3}[0-9]*", ('$1:' + $VersionNew.ToString()))
$rege = [regex] "((создания)\:([0-9]{2}\.){2}[0-9]{4})"
$rega = [regex]"(Изменения)\: ([ \w\.\,\:A-zА-я]*)"
$rege.Replace($str, ('$2:' + (Get-Date -Format "dd.MM.yyyy").ToString()), 1)
$VersString = '$1:' + $VersionNew.ToString()
$DateString='$1:' + (Get-Date -Format "dd.MM.yyyy").ToString()
$MessageString = '$1: ' + (git log -1 --format="%B" -- .\$File.ps1)
(Get-Content .\$File.ps1 -Encoding "UTF8") `
    -replace "([В-я]{6})\:([0-9]*\.){3}[0-9]*", ('$1:' + $VersionNew.ToString()) `
    -replace "","" `
    -replace "", ""|

#>
Set-Content .\$File.ps1 -Value $ScriptBody -Force -Encoding "UTF8"
ps2exe -inputFile $Path\$File.ps1 -outputFile $Path\$File.exe -x64 -requireAdmin `
    -iconFile $Path\icon.ico -title $File -product $File `
    -copyright $OldFileAttr.LegalCopyright -trademark $OldFileAttr.LegalTrademarks `
    -company $OldFileAttr.CompanyName  -description $OldFileAttr.Comments `
    -version "$VersionNew"|Out-Null

$ChangeLog = git diff  $PrevVersion HEAD .\$File.ps1
$ChangeLog | Set-Content .\ChangeLog.md -Encoding "OEM"
