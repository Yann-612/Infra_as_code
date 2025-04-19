# Script PowerShell à exécuter sur la VM Windows Server 2022
# pour ouvrir le port d'écoute WINRM HTTP (NON SÉCURISÉ)

# Configuration du port HTTP WINRM (par défaut 5985)
$WinRMHTTPPort = 5985

# Vérifier si le listener HTTP WINRM existe déjà
$WinRMHTTPListener = Get-WSManInstance -ResourceURI winrm/config/Listener -SelectorSet @{Address="*"; Transport="HTTP"}

if (-not $WinRMHTTPListener) {
    # Créer le listener HTTP WINRM
    New-WSManInstance -ResourceURI winrm/config/Listener -SelectorSet @{Address="*"; Transport="HTTP"} -ValueSet @{Port=$WinRMHTTPPort}
    Write-Host "Listener HTTP WINRM créé sur le port $($WinRMHTTPPort) (NON SÉCURISÉ)."
} else {
    Write-Host "Listener HTTP WINRM existe déjà sur le port $($WinRMHTTPPort)."
}

# Ouvrir le port dans le pare-feu Windows
$FirewallRuleName = "WINRM-HTTP-In-TCP"

if (-not (Get-NetFirewallRule -Name $FirewallRuleName -ErrorAction SilentlyContinue)) {
    New-NetFirewallRule -Name $FirewallRuleName -DisplayName "Windows Remote Management (HTTP-In)" -Description "Autorise le trafic WINRM HTTP entrant (NON SÉCURISÉ)." -Protocol TCP -LocalPort $WinRMHTTPPort -Direction Inbound -Action Allow -Enabled True
    Write-Host "Règle de pare-feu $($FirewallRuleName) ajoutée pour autoriser le trafic WINRM HTTP sur le port $($WinRMHTTPPort) (NON SÉCURISÉ)."
} else {
    Write-Host "Règle de pare-feu $($FirewallRuleName) existe déjà."
}

# Activer PSRemoting si ce n'est pas déjà fait
if (-not (Get-PSSessionConfiguration -Name Microsoft.PowerShell)) {
    Enable-PSRemoting -Force
    Write-Host "PSRemoting activé."
}