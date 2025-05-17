variable "resource_group_name" {
  type        = string
  description = "Nom du Resource Group"
}

variable "location" {
  type        = string
  description = "Région Azure"
}

variable "vm_name" {
  type        = string
  description = "Nom de la machine virtuelle"
}

variable "admin_username" {
  type        = string
  description = "Nom d'utilisateur administrateur"
}

variable "ssh_public_key" {
  type        = string
  description = "Chemin vers la clé SSH publique"
}

variable "prefix" {
  description = "Préfixe utilisé pour nommer les ressources"
  type        = string
}

variable "client_secret" {
  description = "Secret du client Azure"
  type        = string  
  sensitive = true
}

variable "subscription_id" { type = string }
variable "client_id"       { type = string }
variable "tenant_id"       { type = string }

