## Resource Group
resource "azurerm_resource_group" "RG" {
  name     = var.resource_group_name
  location = var.location
}

## Vnet
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet.name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet.address_space

  depends_on = [azurerm_resource_group.RG]
}

## Subnet
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet.name
  address_prefixes     = [var.subnet.address_prefix]

  depends_on = [azurerm_virtual_network.vnet]
}

## Network Security Group
resource "azurerm_network_security_group" "security_group" {
  name                = var.security_group_name
  location            = var.location
  resource_group_name = var.resource_group_name

  depends_on = [azurerm_resource_group.RG]


## Network Security Rule
 security_rule {
  name                        = "allow_ssh_in"
  priority                    = 1001  # Priorité de la règle
  direction                   = "Inbound" # Sens du flux  (Inbound / Outbound)
  access                      = "Allow" # Autorisation (Allow / Deny)
  protocol                    = "Tcp" # Protocole (Tcp / Udp / *)
  source_port_range           = "*" # Port source
  destination_port_range      = "22" # Port destination
  source_address_prefix       = "*" # Adresse IP source
  destination_address_prefix  = "*" # Adresse IP destination
 }

 security_rule {
  name                        = "allow_http_in"
  priority                    = 1002  # Priorité de la règle
  direction                   = "Inbound" # Sens du flux  (Inbound / Outbound)
  access                      = "Allow" # Autorisation (Allow / Deny)
  protocol                    = "Tcp" # Protocole (Tcp / Udp / *)
  source_port_range           = "*" # Port source
  destination_port_range      = "80" # Port destination
  source_address_prefix       = "*" # Adresse IP source
  destination_address_prefix  = "*" # Adresse IP destination
 }

  security_rule {
    name                        = "allow_all_out"
    priority                    = 1003  # Priorité de la règle
    direction                   = "Outbound" # Sens du flux  (Inbound / Outbound)
    access                      = "Allow" # Autorisation (Allow / Deny)
    protocol                    = "*" # Protocole (Tcp / Udp / *)
    source_port_range           = "*" # Port source
    destination_port_range      = "*" # Port destination
    source_address_prefix       = "*" # Adresse IP source
    destination_address_prefix  = "*" # Adresse IP destination
  }
}



## Network Watcher
resource "azurerm_network_watcher" "net-watcher" {
  name                = "net-watcher"
  location            = var.location
  resource_group_name = azurerm_resource_group.RG.name

  depends_on = [azurerm_resource_group.RG]
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
    public_key = file(var.ssh_public_key)
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
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard" 

  depends_on = [azurerm_resource_group.RG]
}

## Network Interface Security Group Association
resource "azurerm_network_interface_security_group_association" "nic_sec_group" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.security_group.id
}
