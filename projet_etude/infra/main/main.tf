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


# Creation des differents sous reseaux

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


module "nsg_dev" {
  source              = "../modules/nsg"
  nsg_name            = "nsg-dev"
  location            = var.location
  resource_group_name = module.rg.name
  subnet_id           = module.subnet_dev.subnet_id
}


module "vm_dev" {
  source              = "../modules/compute_vm"
  vm_name             = "vm-dev"
  location            = var.location
  resource_group_name = module.rg.name
  subnet_id           = module.subnet_dev.subnet_id
  admin_username      = "adminuser"
  admin_ssh_key       = file(var.ssh_public_key_path)
}

output "vm_dev_name" {
  description = "Nom de la VM de développement"
  value       = module.vm_dev.vm_name
}

output "vm_dev_public_ip" {
  description = "Adresse IP publique de la VM de développement"
  value       = module.vm_dev.public_ip
}