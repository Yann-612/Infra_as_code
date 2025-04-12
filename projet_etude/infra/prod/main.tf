
module "rg" {
  source   = "../modules/resource_group"
  name     = var.rg_name
  location = var.location
}

module "network" {
  source              = "../modules/network"
  resource_group_name = module.rg.name
  location            = var.location

  vnet_name           = "vnet-prod"
  vnet_address_space  = ["10.1.0.0/16"]
  subnet_name         = "subnet-prod"
  subnet_prefixes     = ["10.1.1.0/24"]
}
