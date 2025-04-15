# This script configures Windows Remote Management (WinRM) on a Windows server.
# It enables the WinRM service, configures a listener, and sets up firewall rules.
# It also allows basic authentication and unencrypted traffic for testing purposes.

Set-Service -Name WinRM -StartupType Automatic
Start-Service -Name WinRM

# Configure WinRM listener
winrm quickconfig -Force

# Allow basic authentication
winrm set winrm/config/service/auth @{Basic="true"}

# Allow unencrypted traffic (optional, for testing purposes)
winrm set winrm/config/service @{AllowUnencrypted="true"}

# Open firewall ports for WinRM
New-NetFirewallRule -Name "WinRM_HTTP" -DisplayName "WinRM over HTTP" -enabled True -direction Inbound -Protocol TCP -LocalPort 5985 -Action Allow
