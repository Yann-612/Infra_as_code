variable "resource_group_name" {
  description = "Nom du groupe de ressources"
  type        = string
}

variable "location" {
  description = "Région Azure"
  type        = string
}

variable "vnet_name" {
  description = "Nom du Virtual Network"
  type        = string
}

variable "vnet_address_space" {
  description = "Espace d'adressage du VNet"
  type        = list(string)
}

variable "admin_username" {
  description = "Nom de l'utilisateur admin pour la VM"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Chemin vers le fichier de clé publique SSH"
  type        = string
}

variable "client_secret" {
  description = "Client secret for authentication"
  type        = string
  sensitive   = true
}