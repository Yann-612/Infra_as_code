#la ressource azurerm_resource_group.rg est déclarée avec les variables name et location.

resource "azurerm_resource_group" "rg" {
  name     = var.name
  location = var.location
}


#Remplace "resource" par une "data" quand Terraform l'utilise comme une donnée existante.

#data "azurerm_resource_group" "rg" {
  #name = var.name
#}
