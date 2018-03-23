#
#  As a heads up for the last Item you will need the BetterCredentials Module 
#  that is available on the PowerShell Gallery 
#

#
#  The code used in this should mostly work in any version of PowerShell
#  Except the .foreach{ } calls which came in v4 of PowerShell 
#  For v2/3 Change those lines to $variable | Foreach {
#
#



#region Get Plaintext Passwords - from local disk

Set-Location C:\Presentations\Credentials\

$PlaintextCredFiles = Get-ChildItem .\creds\plaintext 

$PlaintextCredFiles.foreach{ New-Variable -Name "Cred_$($_.BaseName)" -Value `
                            ( New-Object System.Management.Automation.PSCredential($_.BaseName,(Get-Content $_.FullName |
                             ConvertTo-SecureString -AsPlainText -Force))) }

Get-Variable "Cred_*" | Select -Property @{n = 'User'; e = {$_.Value.Username} },`
                       @{n ='Password' ; e ={$_.Value.GetNetworkCredential().Password}}


Function Unprotect-CredentialPassword {
[Cmdletbinding()]
Param(
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        [securestring]$password
)

    $Ptr = [System.Runtime.InteropServices.Marshal]::SecureStringToCoTaskMemUnicode($password)
    $result = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($Ptr)
    [System.Runtime.InteropServices.Marshal]::ZeroFreeCoTaskMemUnicode($Ptr)
    $result 

}

#### Simple code

$PlaintextCredFiles.ForEach{ Get-Content -Path $_.fullname -Raw |
                             ConvertTo-SecureString -AsPlainText -Force | 
                             convertfrom-securestring | 
                             out-file $_.FullName.replace('plaintext','securestrings').replace('.txt','.stxt') }



#endregion


#region SecureStrings from Local disk - Uses DPAPI 

$SecureStringCredFiles = Get-ChildItem .\creds\securestrings 


$SecureStringCredFiles.foreach{ New-Variable -Name "SecCred_$($_.BaseName)" -Value `
                              ( New-Object System.Management.Automation.PSCredential($_.BaseName,(Get-Content $_.FullName |
                                ConvertTo-SecureString ))) }

Get-Variable "SecCred_*" | Select -Property @{n = 'User'; e = {$_.Value.Username} },`
                           @{n ='Password' ; e ={$_.Value.GetNetworkCredential().Password}}



#endregion


#region Swap to Local user ISE

#endregion

#region Using @jaykul's BetterCredential module to pull from Win Credential Store 

Import-Module BetterCredentials -Prefix B

$SecureStringCredFiles.ForEach{ New-Variable -Name "B_Cred_$($_.Basename)" -Value `
                               ( Get-BCredential -UserName $($_.Basename.replace('User_','BUser_')) `
                                -Password (Get-Content $_.FullName | ConvertTo-SecureString ) -Store )}


# the -Store Parameter will store the Credentials in the Credential Store if they don't already exist,
# if they do then it will Grab that Credential from the Store


#endregion


#region