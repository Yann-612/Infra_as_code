variable "resource_group_name" {
  description = "Nom du groupe de ressources Azure"
  type        = string
}

variable "location" {
  description = "Localisation des ressources Azure"
  type        = string
}

variable "vnet_name" {
  description = "Nom du réseau virtuel"
  type        = string
}

variable "subnet_name" {
  description = "Nom du sous-réseau"
  type        = string
}

variable "vm_name" {
  description = "Nom de la machine virtuelle"
  type        = string
}

variable "admin_username" {
  description = "Nom d'utilisateur administrateur"
  type        = string
}

variable "admin_password" {
  description = "Mot de passe administrateur"
  type        = string
}

variable "client_secret" {
  description = "Client secret for authentication"
  type        = string
  sensitive   = true
}
