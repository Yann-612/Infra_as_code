# Activer WinRM en HTTP (non-HTTPS, attention à la sécurité)
winrm quickconfig -force
winrm set winrm/config/service/Auth '@{Basic="true"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
Set-Item -Path WSMan:\localhost\Service\AllowUnencrypted -Value $true
Set-Item -Path WSMan:\localhost\Service\Auth\Basic -Value $true
Enable-PSRemoting -Force
# Autoriser les connexions à distance
Set-Item WSMan:\localhost\Service\AllowUnencrypted -Value $true
Set-Item WSMan:\localhost\Service\Auth\Basic -Value $true
# Autoriser les connexions à distance sur le pare-feu Windows
New-NetFirewallRule -Name "WinRM HTTP" -DisplayName "WinRM HTTP" -Enabled True -Profile Any -Action Allow -Protocol TCP -LocalPort 5985
# Autoriser les connexions à distance sur le pare-feu Windows (HTTPS)
New-NetFirewallRule -Name "WinRM HTTPS" -DisplayName "WinRM HTTPS" -Enabled True -Profile Any -Action Allow -Protocol TCP -LocalPort 5986
# Autoriser les connexions à distance sur le pare-feu Windows (WSMan)
New-NetFirewallRule -Name "WSMan" -DisplayName "WSMan" -Enabled True -Profile Any -Action Allow -Protocol TCP -LocalPort 80, 443, 5985, 5986
# Autoriser les connexions à distance sur le pare-feu Windows (HTTP)
New-NetFirewallRule -Name "HTTP" -DisplayName "HTTP" -Enabled True -Profile Any -Action Allow -Protocol TCP -LocalPort 80
# Autoriser les connexions à distance sur le pare-feu Windows (HTTPS)
New-NetFirewallRule -Name "HTTPS" -DisplayName "HTTPS" -Enabled True -Profile Any -Action Allow -Protocol TCP -LocalPort 443
# Autoriser les connexions à distance sur le pare-feu Windows (RDP)
New-NetFirewallRule -Name "RDP" -DisplayName "RDP" -Enabled True -Profile Any -Action Allow -Protocol TCP -LocalPort 3389