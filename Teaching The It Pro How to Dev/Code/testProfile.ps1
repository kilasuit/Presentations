<# # Some Modules that I already have installed and use day to day

Import-Module posh-git
Import-Module EditorServicesCommandSuite
Import-Module BetterCredentials -Prefix b


$TestCredential = [pscredential]::new('Test-UserAccount',(ConvertTo-SecureString 'SuperSecurePassword123' -AsPlainText -Force))

Set-bCredential -Credential $TestCredential -Target ProfileCredential

Find-bCredential | Where Target -match 'Test' | Select Username


if (Get-Module SharePointPnPPowerShellOnline -ListAvailable) {
        Import-Module SharePointPnPPowerShellOnline
    }
    else{
        Install-Module SharePointPnPPowerShellOnline -RequiredVersion 3.2.1810.0 -Repository PSGallery -Scope CurrentUser -Force
        Import-Module SharePointPnPPowerShellOnline  
    }


 #>