# Nom du groupe de ressources
variable "resource_group_name" {
  description = "Nom du groupe de ressources Azure"
  type        = string
}

# Emplacement des ressources Azure
variable "location" {
  description = "Région Azure où seront déployées les ressources"
  type        = string
}

# Nom du groupe de sécurité réseau
variable "security_group_name" {
  description = "Nom du groupe de sécurité réseau"
  type        = string
}

# Nom du réseau virtuel
variable "vnet_name" {
  description = "Nom du réseau virtuel"
  type        = string
}

# Nom du sous-réseau
variable "subnet_name" {
  description = "Nom du sous-réseau"
  type        = string
}

# Nom de la machine virtuelle
variable "vm_name" {
  description = "Nom de la machine virtuelle"
  type        = string
}

# Nom de l'hôte
variable "hostname" {
  description = "Nom de l'hôte pour la machine virtuelle"
  type        = string
}

# Taille de la machine virtuelle
variable "vm_size" {
  description = "Taille de la machine virtuelle"
  type        = string
}

# Nom de l'adresse IP publique
variable "public_ip_name" {
  description = "Nom de l'adresse IP publique"
  type        = string
}

variable "storage_account_name" {
  description = "Nom du compte de stockage Azure"
  type        = string
}

# Nom de l'utilisateur administrateur
variable "admin_username" {
  description = "Nom de l'utilisateur administrateur de la VM"
  type        = string
}

# Clé SSH publique pour la connexion
variable "ssh_public_key" {
  description = "Chemin vers la clé SSH publique ou contenu de la clé"
  type        = string
}
