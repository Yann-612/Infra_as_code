# Script de vérification de la configuration DHCP
# ==========================================

# Fonction pour écrire dans le journal
function Write-Log {
    param($Message)
    $logPath = "C:\dhcp_backup\dhcp_check_$(Get-Date -Format 'yyyy-MM-dd').log"
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    "$timestamp - $Message" | Add-Content -Path $logPath
    Write-Host $Message
}

# Vérification du service DHCP
Write-Log "Vérification du service DHCP..."
$service = Get-Service -Name 'DHCPServer'
if ($service.Status -ne 'Running') {
    Write-Log "ERREUR: Le service DHCP n'est pas en cours d'exécution"
    Start-Service -Name 'DHCPServer'
    Write-Log "Service DHCP redémarré"
}

# Vérification de la journalisation
Write-Log "Vérification de la configuration des logs..."
$auditLog = Get-DhcpServerAuditLog
if (-not $auditLog.Enable) {
    Write-Log "Réactivation des logs d'audit..."
    Set-DhcpServerAuditLog -Enable $true -Type 'DhcpServFailure,IPAddressConflict,DhcpDeleted,DhcpExpired'
}

# Vérification des filtres
Write-Log "Vérification des filtres DHCP..."
$filterList = Get-DhcpServerv4FilterList
if (-not ($filterList.Enable)) {
    Write-Log "Réactivation des filtres DHCP..."
    Set-DhcpServerv4FilterList -Enable $true -AllowList $true -DenyList $true
}

# Vérification de la tâche de sauvegarde
Write-Log "Vérification de la tâche de sauvegarde..."
$task = Get-ScheduledTask -TaskName 'DHCP_Backup' -ErrorAction SilentlyContinue
if (-not $task) {
    Write-Log "Recréation de la tâche de sauvegarde..."
    $backupPath = 'C:\dhcp_backup'
    $action = New-ScheduledTaskAction -Execute 'PowerShell.exe' `
        -Argument "-Command `"Export-DhcpServer -File '$backupPath\dhcp_backup_`$(Get-Date -Format 'yyyy-MM-dd').xml' -Force`""
    $trigger = New-ScheduledTaskTrigger -Daily -At '23:00'
    Register-ScheduledTask -TaskName 'DHCP_Backup' -Action $action -Trigger $trigger `
        -Description 'Sauvegarde quotidienne du serveur DHCP' -Force
}

# Vérification des scopes DHCP
Write-Log "Vérification des scopes DHCP..."
$scopes = Get-DhcpServerv4Scope
foreach ($scope in $scopes) {
    Write-Log "Analyse du scope $($scope.ScopeId)..."
    
    # Vérification des conflits
    $stats = Get-DhcpServerv4ScopeStatistics -ScopeId $scope.ScopeId
    if ($stats.ConflictDetectionAttempts -gt 0) {
        Write-Log "ATTENTION: $($stats.ConflictDetectionAttempts) conflits détectés dans le scope $($scope.ScopeId)"
    }
    
    # Vérification du taux d'utilisation
    $utilisationPercent = ($stats.InUse / $stats.Total) * 100
    Write-Log "Taux d'utilisation du scope $($scope.ScopeId): $($utilisationPercent)%"
    if ($utilisationPercent -gt 80) {
        Write-Log "ATTENTION: Le scope $($scope.ScopeId) est utilisé à plus de 80%"
    }
}

# Génération du rapport
Write-Log "Génération du rapport de vérification..."
$report = @{
    'Timestamp' = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    'Service' = $service.Status
    'AuditLog' = $auditLog
    'FilterList' = $filterList
    'BackupTask' = $task.State
    'Scopes' = $scopes | Select-Object ScopeId, SubnetMask, Name, State
    'Statistics' = $scopes | ForEach-Object {
        $stats = Get-DhcpServerv4ScopeStatistics -ScopeId $_.ScopeId
        @{
            'ScopeId' = $_.ScopeId
            'InUse' = $stats.InUse
            'Available' = $stats.Free
            'UtilizationPercent' = ($stats.InUse / $stats.Total) * 100
            'Conflicts' = $stats.ConflictDetectionAttempts
        }
    }
}

# Sauvegarde du rapport
$reportPath = "C:\dhcp_backup\dhcp_status_$(Get-Date -Format 'yyyy-MM-dd').json"
$report | ConvertTo-Json -Depth 4 | Set-Content -Path $reportPath
Write-Log "Rapport sauvegardé dans $reportPath"
