# Activer WinRM
Set-Service -Name WinRM -StartupType Automatic
Start-Service -Name WinRM

# Configurer un listener HTTPS pour WinRM
$cert = New-SelfSignedCertificate -DnsName "your-server-name" -CertStoreLocation Cert:\LocalMachine\My
$thumbprint = $cert.Thumbprint
New-Item -Path WSMan:\Localhost\Service\CertificateThumbprint -Value $thumbprint

# Configurer le listener HTTPS
winrm create winrm/config/Listener?Address=*+Transport=HTTPS @{Hostname="your-server-name"; CertificateThumbprint="$thumbprint"}

# Activer l'authentification par mot de passe
winrm set winrm/config/service/auth @{Basic="true"}

# Activer le trafic non chiffré (optionnel, pour les tests uniquement)
winrm set winrm/config/service @{AllowUnencrypted="true"}

# Configurer les limites de WinRM
winrm set winrm/config @{MaxEnvelopeSizekb="8192"}
winrm set winrm/config/service @{MaxConcurrentOperationsPerUser="1000"}

# Ouvrir les ports nécessaires pour WinRM
New-NetFirewallRule -Name "WinRM_HTTPS" -DisplayName "WinRM over HTTPS" -Protocol TCP -LocalPort 5986 -Action Allow

# Vérifier la configuration
winrm enumerate winrm/config/listener
