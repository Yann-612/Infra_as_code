# Nom du groupe de ressources
resource_group_name = "RG-linux"

# Localisation des ressources
location = "France Central"

# Nom du réseau virtuel
vnet_name = "Vnet-Cyna-lab"

# Nom du sous-réseau
subnet_name = "Subnet-Cyna-lab"

# Nom du groupe de sécurité réseau
security_group_name = "NSG-Cyna-lab"

# Nom de la machine virtuelle
vm_name = "VM-Cyna-lab"

# Taille de la machine virtuelle
vm_size = "Standard_B2s"

# Nom d'utilisateur administrateur
admin_username = "adminuser"

# Clé publique SSH pour l'accès à la VM
#ssh_public_key = "C:/Users/Yannick/.ssh/id_ed25519.pub"
ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK2ZW+G05wyuDs41YwgV9GFKaZpCJ6p48UrBLMRF/mUe yann_@Yan-leno"

# Nom d'hôte de la machine virtuelle
hostname = "Ubuntu"
