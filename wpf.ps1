Remove-Variable * -Scope local -ErrorAction SilentlyContinue

[xml]$xmlWPF = Get-Content -Path D:\prg\Powershell\tinybuilder\BuilderForm.xml
$Gui=[Windows.Markup.XamlReader]::Load((new-object System.Xml.XmlNodeReader $xmlWPF))
$xmlWPF.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | %{Set-Variable -Name ($_.Name) -Value $Gui.FindName($_.Name) -Scope Global}

$Gui.ShowDialog()
$gui.({
[System.Windows.Forms.MessageBox]::Show("OK!")
})