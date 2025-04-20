# Scripts de maintenance DHCP

Ce dossier contient les scripts de maintenance et de vérification pour le serveur DHCP.

## check_dhcp_config.ps1

Script de vérification quotidienne qui :

- Vérifie l'état du service DHCP
- Contrôle la configuration des logs d'audit
- Vérifie les filtres DHCP
- S'assure que la tâche de sauvegarde est active
- Analyse les scopes DHCP pour détecter :
  - Les conflits d'adresses IP
  - Le taux d'utilisation élevé (>80%)
- Génère un rapport détaillé au format JSON

### Utilisation

1. Exécution manuelle :
```powershell
.\check_dhcp_config.ps1
```

2. Configuration comme tâche planifiée :
```powershell
$action = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument "-File 'C:\Infra_as_code\projet_etude\dhcp_config\scripts\check_dhcp_config.ps1'"
$trigger = New-ScheduledTaskTrigger -Daily -At '08:00'
Register-ScheduledTask -TaskName 'DHCP_Check' -Action $action -Trigger $trigger -Description 'Vérification quotidienne du serveur DHCP'
```

### Logs et Rapports

Les fichiers sont stockés dans `C:\dhcp_backup\` :

- Logs quotidiens : `dhcp_check_YYYY-MM-DD.log`
- Rapports d'état : `dhcp_status_YYYY-MM-DD.json`
- Sauvegardes DHCP : `dhcp_backup_YYYY-MM-DD.xml`
