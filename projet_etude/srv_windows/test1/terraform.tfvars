
# Variables de configuration pour le déploiement Terraform
# Nom du groupe de ressources
resource_group_name = "RG-infra"
location = "France Central"

vnet_name = "Vnet-Infra-Cyna"
address_space =["10.0.0.0/16"]

subnet_name = "Subnet-Cyna-lab"
subnet_prefix = "10.0.1.0/24"

security_group_name = "Network-Security-Group"

# Nom de la machine virtuelle (doit être unique dans le groupe de ressources)
vm_name = "srv" # Nom de la machine virtuelle (doit être unique dans le groupe de ressources)
hostname = "srv"
vm_size = "Standard_B1s"
public_ip_name = "public-ip"

admin_username = "adminuser"
admin_password = "P@ssw0rd123!" # Mot de passe de l'administrateur (doit respecter les exigences de complexité d'Azure)
#sh_public_key = "C:/Users/Yann_/.ssh/id_rsa.pub"


