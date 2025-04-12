# Variables de configuration pour le provisionnement d'une machine virtuelle Linux sur Azure avec Terraform
resource_group_name = "RG-infra"
location = "France Central"
vnet_name = "Vnet-Infra"
subnet_name = "Subnet-web"
security_group_name = "NSG-srv-linux"

# Nom de la machine virtuelle (doit être unique dans le groupe de ressources)
vm_name = "srv-linux"
vm_size = "Standard_B2s"
admin_username = "adminuser"
hostname = "Ubuntu"

# Configuration du disque OS
os_disk = {
  caching              = "ReadWrite"
  storage_account_type = "Standard_LRS"
}

# Référence de l'image source
source_image_reference = {
  publisher = "Canonical"
  offer     = "0001-com-ubuntu-server-jammy"
  sku       = "22_04-lts"
  version   = "latest"
}

# Clé publique SSH pour l'accès hostname = "Ubuntu"à la VM
#ssh_public_key = "C:/Users/Yannick/.ssh/id_ed25519.pub"
ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK2ZW+G05wyuDs41YwgV9GFKaZpCJ6p48UrBLMRF/mUe yann_@Yan-leno"

# Configuration du VNet
vnet = {
  name          = "vnet-infra"
  address_space = ["10.0.0.0/16"]
}

# Configuration du Subnet
subnet = {
  name           = "subnet-web"
  address_prefix = "10.0.1.0/24"
}
