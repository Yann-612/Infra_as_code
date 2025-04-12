# 🏢 Nom du groupe de ressources
variable "resource_group_name" {
  description = "The name of the Azure resource group"
  type        = string
}

# 🌍 Emplacement des ressources Azure
variable "location" {
  description = "Région Azure où seront déployées les ressources"
  type        = string
}

# 🌐 Nom du réseau virtuel
variable "vnet_name" {
  description = "Nom du réseau virtuel"
  type        = string
}

# 📌 Nom du sous-réseau
variable "subnet_name" {
  description = "Nom du sous-réseau"
  type        = string
}


# Nom du security group
variable "security_group_name" {
  description = "Nom du groupe de sécurité"
  type        = string
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
}

# 👤 Nom de l'utilisateur administrateur
variable "admin_username" {
  description = "Nom de l'utilisateur administrateur de la VM"
  type        = string
}

# 🔑 Clé SSH publique pour la connexion
variable "ssh_public_key" {
  description = "Chemin vers la clé SSH publique"
  type        = string
}

# 🖥️ Nom de la machine virtuelle
variable "vm_name" {
  description = "Nom de la machine virtuelle"
  type        = string
}

variable "os_disk" {
  description = "Configuration du disque OS"
  type = object({
    caching              = string
    storage_account_type = string
  })
}

variable "source_image_reference" {
  description = "Référence de l'image source pour la VM"
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
}
