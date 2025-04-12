variable "resource_group_name" {
  description = "Nom du groupe de ressources"
  type        = string
}

variable "location" {
  description = "Localisation des ressources"
  type        = string
}

variable "vnet" {
  description = "Configuration du réseau virtuel"
  type = object({
    name          = string
    address_space = list(string)
  })
}

variable "subnet" {
  description = "Configuration du sous-réseau"
  type = object({
    name           = string
    address_prefix = string
  })
}