module "rg" {
  source   = "../modules/resource_group"
  name     = var.resource_group_name
  location = var.location
}

module "vnet" {
  source              = "../modules/vnet"
  resource_group_name = module.rg.name
  location            = module.rg.location
  name                = var.vnet_name
  address_space       = var.vnet_address_space
}

module "subnet_dev" {
  source               = "../modules/subnet"
  name                 = "subnet-dev"
  address_prefixes     = ["10.0.1.0/24"]
  resource_group_name  = module.rg.name
  virtual_network_name = module.vnet.vnet_name
}

module "subnet_prod" {
  source               = "../modules/subnet"
  name                 = "subnet-prod"
  address_prefixes     = ["10.0.2.0/24"]
  resource_group_name  = module.rg.name
  virtual_network_name = module.vnet.vnet_name
}

module "subnet_dmz" {
  source               = "../modules/subnet"
  name                 = "subnet-dmz"
  address_prefixes     = ["10.0.3.0/24"]
  resource_group_name  = module.rg.name
  virtual_network_name = module.vnet.vnet_name
}

module "subnet_backend" {
  source               = "../modules/subnet"
  name                 = "subnet-backend"
  address_prefixes     = ["10.0.4.0/24"]
  resource_group_name  = module.rg.name
  virtual_network_name = module.vnet.vnet_name
}