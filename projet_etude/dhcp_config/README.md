# Configuration DHCP Ansible pour Azure VM

Ce projet contient les fichiers nécessaires pour déployer et configurer un serveur DHCP sur une machine virtuelle Windows Azure en utilisant Ansible.

## Prérequis

- Une VM Windows Server sur Azure
- WinRM configuré sur la VM
- Ansible installé sur la machine de contrôle
- Module pywinrm Python installé (`pip install pywinrm`)

## Structure des fichiers

- `deploy_dhcp.yml` : Playbook principal pour le déploiement DHCP
- `inventory.ini` : Fichier d'inventaire contenant les informations de connexion
- `vars/dhcp_vars.yml` : Variables de configuration DHCP

## Configuration

1. Modifier le fichier `inventory.ini` avec les informations de votre VM Azure :
   - Remplacer `AZURE_VM_IP` par l'IP de votre VM
   - Mettre à jour les credentials d'accès

2. Ajuster les variables dans `vars/dhcp_vars.yml` selon vos besoins :
   - Plage d'adresses IP
   - Masque de sous-réseau
   - Passerelle
   - Serveurs DNS
   - Réservations DHCP

## Exécution

```bash
ansible-playbook -i inventory.ini deploy_dhcp.yml
```
