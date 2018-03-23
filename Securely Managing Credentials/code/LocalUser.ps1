
# Proving stage 1 of being slightly more secure - as running in different user context



Set-Location C:\Presentations\Credentials\


$SecureStringCredFiles = Get-ChildItem .\creds\securestrings 

Get-content $SecureStringCredFiles[0].FullName


$SecureStringCredFiles.foreach{ New-Variable -Name "SecCred_$($_.BaseName)" -Value `
                              ( New-Object System.Management.Automation.PSCredential($_.BaseName,(Get-Content $_.FullName |
                                ConvertTo-SecureString ))) }

