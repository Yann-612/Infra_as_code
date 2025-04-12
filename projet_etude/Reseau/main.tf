module "shared_variables" {
  source = "../../modules/Shared_variables"

  resource_group_name = var.resource_group_name
  location            = "France Central"
  vnet = {
    name          = "vnet-infra"
    address_space = ["10.0.0.0/16"]
  }
  subnet = {
    name           = "subnet-web"
    address_prefix = "10.0.1.0/24"
  }
}

## Resource Group
resource "azurerm_resource_group" "RG" {
  name     = "RG-infra"
  location = var.location
}

## Vnet
resource "azurerm_virtual_network" "vnet" {
  name                = module.shared_variables.vnet.name
  location            = module.shared_variables.location
  resource_group_name = module.shared_variables.resource_group_name
  address_space       = module.shared_variables.vnet.address_space
}

## Subnet
resource "azurerm_subnet" "subnet" {
  name                 = module.shared_variables.subnet.name
  resource_group_name  = module.shared_variables.resource_group_name
  virtual_network_name = module.shared_variables.vnet.name
  address_prefixes     = [module.shared_variables.subnet.address_prefix]

  depends_on = [azurerm_virtual_network.vnet]
}
