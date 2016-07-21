Add-WindowsFeature "RSAT-AD-Tools"
Add-WindowsFeature "RSAT-DNS-Server"
Start-Job -Name addFeature -ScriptBlock { 
Import-Module ServerManager
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools}
Wait-Job -Name addFeature
