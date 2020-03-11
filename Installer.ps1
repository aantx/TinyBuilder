Set-ExecutionPolicy RemoteSigned
Set-PSRepository -Name psgallery -InstallationPolicy Trusted
Install-Module ps2exe
if ($env:Path -notmatch "git") {
    [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    [System.Windows.Forms.Messagebox]::Show("Install git pls and connect it to repo")
    exit
}
$env:Path += ";D:\prg\Powershell\TinyBuilder"
