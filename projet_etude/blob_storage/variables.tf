# 🌍 Emplacement des ressources Azure
variable "location" {
  description = "Région Azure où seront déployées les ressources"
  type        = string
  default     = "France Central"
}

# 🏢 Nom du groupe de ressources
variable "resource_group_name" {
  description = "The name of the Azure resource group"
  type        = string
  default     = "RG-Cyna-lab"
}

# Nom du security group
variable "security_group_name" {
  description = "Nom du groupe de sécurité"
  type        = string
  default     = "Network-Security-Group"
}

# 🌐 Nom du réseau virtuel
variable "vnet_name" {
  description = "Nom du réseau virtuel"
  type        = string
  default     = "Vnet-Cyna-lab"
}

# 📌 Nom du sous-réseau
variable "subnet_name" {
  description = "Nom du sous-réseau"
  type        = string
  default     = "Subnet-Cyna-lab"
}

# 🖥️ Nom de la machine virtuelle
variable "vm_name" {
  description = "Nom de la machine virtuelle"
  type        = string
  default     = "Web-srv"
}

# 🖥️ Nom de l'hôte
variable "hostname" {
  description = "Nom de l'hôte pour la machine virtuelle"
  type        = string
  default     = "web-srv"
}

# 📏 Type de la machine virtuelle
variable "vm_size" {
  description = "Taille de la VM Azure"
  type        = string
  default     = "Standard_B1s"
}

# 👤 Nom de l'utilisateur administrateur
variable "admin_username" {
  description = "Nom de l'utilisateur administrateur de la VM"
  type        = string
  default     = "adminuser"
}

# 🔑 Clé SSH publique pour la connexion
variable "ssh_public_key" {
  description = "Chemin vers la clé SSH publique"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}
