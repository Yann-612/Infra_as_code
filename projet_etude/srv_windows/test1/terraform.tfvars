
# Variables de configuration pour le déploiement Terraform
# Nom du groupe de ressources
resource_group_name = "RG-infra"
location = "France Central"
vnet_name = "Vnet-Cyna-lab"
subnet_name = "Subnet-Cyna-lab"
security_group_name = "Network-Security-Group"

# Nom de la machine virtuelle (doit être unique dans le groupe de ressources)
vm_name = "srv" # Nom de la machine virtuelle (doit être unique dans le groupe de ressources)
hostname = "srv"
vm_size = "Standard_B1s"
public_ip_name = "public-ip"

admin_username = "adminuser"
ssh_public_key = "C:/Users/Yannick/.ssh/id_rsa.pub"


# Nom du compte de stockage
storage_account_name = "vincistockageblob001"
