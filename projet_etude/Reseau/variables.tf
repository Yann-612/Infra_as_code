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