# Quand Terraform provisionne la ressource pour la première fois, il faut utiliser le module "rg".
# Quand Terraform utilise la ressource existante il faut utiliser la data source.

module "rg" {
  source   = "../modules/resource_group"
  name     = var.rg_name
  location = var.location
}

module "network" {
  source              = "../modules/network"
  resource_group_name = module.rg.name
  location            = var.location

  vnet_name           = "vnet-dev"
  vnet_address_space  = ["10.0.0.0/16"]
  subnet_name         = "subnet-dev"
  subnet_prefixes     = ["10.0.1.0/24"]
}


# Quand Terraform utilise la ressource existante il faut utiliser la data source.
# on décommente le module "network" et on commente le module "rg".
# Quand Terraform utilise la ressource existante il faut utiliser la data source.

# module "network" {
#   source              = "../modules/network"
#   resource_group_name = data.azurerm_resource_group.rg.name
#   location            = data.azurerm_resource_group.rg.location
#   vnet_name           = "vnet-dev"
#   vnet_address_space  = ["10.0.0.0/16"]
#   subnet_name         = "subnet-dev"
#   subnet_prefixes     = ["10.0.1.0/24"]
# }

