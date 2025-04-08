#Enable WinRM
Set-Service -Name WinRM -StartupType Automatic
Start-Service -Name WinRM

# Configure WinRM listener
winrm quickconfig -Force

# Allow basic authentication
winrm set winrm/config/service/auth @{Basic="true"}

# Allow unencrypted traffic (optional, for testing purposes)
winrm set winrm/config/service @{AllowUnencrypted="true"}

# Open firewall ports for WinRM
New-NetFirewallRule -Name "WinRM_HTTP" -DisplayName "WinRM over HTTP" -Protocol TCP -LocalPort 5985 -Action Allow
