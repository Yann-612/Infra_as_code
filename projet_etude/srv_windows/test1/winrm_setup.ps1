# Configure WinRM for Ansible (insecure HTTP)
Set-Item -Path WSMan:\localhost\Service\AllowUnencrypted -Value $true
Set-Item -Path WSMan:\localhost\Service\Auth\Basic -Value $true

# Start the WinRM service
Set-Service -Name WinRM -StartupType Automatic
Start-Service -Name WinRM

# Add firewall rule for WinRM
New-NetFirewallRule -DisplayName "WinRM Inbound" -Direction Inbound -Protocol TCP -LocalPort 5985 -Action Allow

