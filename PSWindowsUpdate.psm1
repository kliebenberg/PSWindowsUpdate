Get-ChildItem -Path $PSScriptRoot | Unblock-File
Get-ChildItem -Path $PSScriptRoot\*.ps1 | Foreach-Object{ . $_.FullName }

New-Alias Install-WindowsUpdate Get-WUInstall
New-Alias Uninstall-WindowsUpdate Get-WUUninstall
New-Alias Get-WindowsUpdate Get-WUList
New-Alias Hide-WindowsUpdate Hide-WUUpdate

Export-ModuleMember -Function * -Alias *


