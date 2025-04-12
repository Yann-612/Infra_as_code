module "shared_variables" {
  source = "../../modules/Shared_variables"

  resource_group_name = "RG-infra"
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
  name     = module.shared_variables.resource_group_name
  location = module.shared_variables.location
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
}


## Network Security Group
resource "azurerm_network_security_group" "security_group" {
  name                = var.security_group_name
  location            = var.location
  resource_group_name = module.shared_variables.resource_group_name

  depends_on = [module.shared_variables]
}


## Network Security Rule
resource "azurerm_network_security_rule" "allow_ssh_in" {
   name                        = "allow_ssh_in"
   priority                    = 1001
   direction                   = "Inbound"
   access                      = "Allow"
   protocol                    = "Tcp"
   source_port_range           = "*"
   destination_port_range      = "22"
   source_address_prefix       = "*"
   destination_address_prefix  = "*"
   network_security_group_name = azurerm_network_security_group.security_group.name
   resource_group_name         = module.shared_variables.resource_group_name
   }

resource "azurerm_network_security_rule" "allow_http_in" {
   name                        = "allow_http_in"
   priority                    = 1002
   direction                   = "Inbound"
   access                      = "Allow"
   protocol                    = "Tcp"
   source_port_range           = "*"
   destination_port_range      = "80"
   source_address_prefix       = "*"
   destination_address_prefix  = "*"
   network_security_group_name = azurerm_network_security_group.security_group.name
   resource_group_name         = module.shared_variables.resource_group_name
   }

resource "azurerm_network_security_rule" "allow_all_out" {
   name                        = "allow_all_out"
   priority                    = 1003
   direction                   = "Outbound"
   access                      = "Allow"
   protocol                    = "*"
   source_port_range           = "*"
   destination_port_range      = "*"
   source_address_prefix       = "*"
   destination_address_prefix  = "*"
   network_security_group_name = azurerm_network_security_group.security_group.name
   resource_group_name         = module.shared_variables.resource_group_name
   }


## Virtual Machine 
resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  os_disk {
    caching              = var.os_disk.caching
    storage_account_type = var.os_disk.storage_account_type
  }

  source_image_reference {
    publisher = var.source_image_reference.publisher
    offer     = var.source_image_reference.offer
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }

  computer_name                  = var.hostname
  disable_password_authentication = true
  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }
}

## Network Interface
resource "azurerm_network_interface" "nic" {
  name                = "ethernet-${var.vm_name}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public.id
  }
}

## Public IP
resource "azurerm_public_ip" "public" {
  name                = "public-ip"
  resource_group_name = module.shared_variables.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"

  depends_on = [module.shared_variables]
}

## Network Interface Security Group Association
resource "azurerm_network_interface_security_group_association" "nic_sec_group" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.security_group.id
}

