<#Remove-Variable * -Scope Local  -ErrorAction SilentlyContinue
$co= New-Object -ComObject "Virtualbox.virtualbox"
$co | Get-Member
#Add-Type -AssemblyName System.Windows.Forms
$Notific = New-Object System.Windows.Forms.NotifyIcon
$Notific.Icon = [System.Drawing.Icon]::new("D:\prg\powershell\monitorhw\5.ico")
$Notific.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Info
$Notific.BalloonTipText = "Halo"
$Notific.BalloonTipTitle = "first"
$Notific.Visible = $true
$Notific.ShowBalloonTip(10000)

Start-Sleep -Seconds 10

$Notific.Dispose() 
#>
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Data Entry Form'

$form.StartPosition = 'CenterScreen'

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(25,120)
$OKButton.Size = New-Object System.Drawing.Size(140,35)
$OKButton.Text = 'Скомпилировать'
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $OKButton
$form.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(150,120)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = 'Cancel'
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $CancelButton
$form.Controls.Add($CancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Please enter the information in the space below:'
$form.Controls.Add($label)

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10,40)
$textBox.Size = New-Object System.Drawing.Size(260,20)
$form.Controls.Add($textBox)

$form.Topmost = $true

$form.Add_Shown({$textBox.Select()})
$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $x = $textBox.Text
    $x
}