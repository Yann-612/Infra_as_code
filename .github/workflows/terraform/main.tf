# Terraform script to provision a Linux web server on Azure with a public IP and security group rules
## Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

## Vnet
resource "azurerm_virtual_network" "vnet" {
  depends_on          = [azurerm_resource_group.rg]
  name                = "vnet-${var.vm_name}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

## Subnet
# Removed the incomplete azurerm_subnet block to avoid duplication and missing attributes.
## Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "subnet-${var.vm_name}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Public IP
resource "azurerm_public_ip" "public_ip" {
  name                = "public-ip-${var.vm_name}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Network Interface
resource "azurerm_network_interface" "nic" {
  name                = "nic-${var.vm_name}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

# NSG
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-${var.vm_name}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowHTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

# NSG Association
resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# VM
resource "azurerm_linux_virtual_machine" "vm" {
  name                            = "${var.prefix}-vm"
  location                        = var.location
  resource_group_name             = azurerm_resource_group.rg.name
  size                            = "Standard_B1s"
  admin_username                  = var.admin_username
  network_interface_ids           = [azurerm_network_interface.nic.id]
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDQSSabUu9GyBLJWHNPf0MnA6BKtXfB5aBHrI2WkpweFsy8xcpsSjKCIU5jbiwCR9thQjBkbOoAoA11BP403Sw80yy+Rp61QPhzz88j6j4NRVbwxOdWNEXlYvdR585J5dyTHZEoOMCKiopa/eEPDYdvEp08JyBN6Y411ehBziBirvrt+wnZIjsGlvTPeyyITiNX+5wqLASGgZhLXsSIoDGALecNeT272EDxfxyVRL7vkr/txGlNHR103+sekRc8FJZfdpQ2to4rhjxC6RofIVPaRQNJEvjrYtR0oWTYME+Ojf9THgXIHTIhdH92TzScp2LclU8w9e+/pPJSKylQ2vZIanl728HjPo+DwQyrpB1FjkuMd7SRf4/Vcie7BTvDBBaqReQoCpoIrTvZuJhaa7D6vOE4X3KDrf/ouAPrxNl9rasDgzzQ1cO1DJADgrn6FC3qKB0FLh6E6t4nVMJwC7j6P1eHZuC/EnlWMgjJNSU6zswSk88PN7NhkF5VKz109x/XKnDTBKNSIsd5mFIFZhaIA7JoBMIBm/1SY3BJ4IJkL3LSKziXI2552W4tSSLgMkrgIyf8zJ0pqeKQXOy4IykqMmYf7v2BJ85ImLRgPy2IY8kdJCfyo/Dn1jNdleI8cG0qhVfeFyqzr9GNI3Zq2YUBCFGKyZElrg16U463BjMHGw== asi-cours-472@supdevinci-edu.fr"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "${var.vm_name}-osdisk"
    disk_size_gb         = 30
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}



