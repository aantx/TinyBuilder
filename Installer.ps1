[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
if ($env:Path -notmatch "TinyBuilder") {
    Set-ExecutionPolicy RemoteSigned
    Set-PSRepository -Name psgallery -InstallationPolicy Trusted
    Install-Module ps2exe
    if ($env:Path -notmatch "git") {

        [System.Windows.Forms.Messagebox]::Show("Install git pls and connect it to repo")
        exit
    }
    $env:Path += ";$PSScriptRoot\TinyBuilder"
    
    [System.Windows.Forms.Messagebox]::Show("Installed successfully")
}
else {
    $msgBoxInput=[System.Windows.Forms.Messagebox]::Show("Adlready installed. Wanna uninstall?", "TinyBuilderInstaller", "YesNo")
    switch ($msgBoxInput) {
        'Yes' {
            [System.Environment]::SetEnvironmentVariable(
                'Path',
                ([System.Environment]::GetEnvironmentVariable(
                        'PATH',
                        'Machine'
                    ).split(";") | Where-Object { $_ -notmatch "TinyBuilder" }) -join ";",
                'Machine'
            )
            [System.Windows.Forms.Messagebox]::Show("Uninstalled successfully")
        }
        'No' {
            "exiting"
            Exit
        }
    }


}