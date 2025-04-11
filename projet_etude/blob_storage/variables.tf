# Variables pour le module de stockage Azure


# Nom du groupe de ressources
variable "resource_group_name" {
  description = "The name of the Azure resource group"
  type        = string
}

variable "location" {
  description = "Région Azure où seront déployées les ressources"
  type        = string
}
