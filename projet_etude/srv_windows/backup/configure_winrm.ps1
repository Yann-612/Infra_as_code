# Enable WinRM
Set-Service -Name WinRM -StartupType Automatic
Start-Service -Name WinRM
winrm quickconfig -Force
winrm set winrm/config/service/auth @{Basic="true"}
winrm set winrm/config/service @{AllowUnencrypted="true"}
New-NetFirewallRule -Name "WinRM_HTTP" -DisplayName "WinRM over HTTP" -Enabled True -Direction Inbound -Protocol TCP -LocalPort 5985 -Action Allow

# Install AD DS role
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Promote the server to a domain controller
$domainName = "cyna.local"
$domainNetbiosName = "CYNA"
$adminPassword = ConvertTo-SecureString "P@$$wOrd1234!" -AsPlainText -Force
Install-ADDSForest -DomainName $domainName -SafeModeAdministratorPassword $adminPassword -Force -NoRebootOnCompletion