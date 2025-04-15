resource "azurerm_resource_group" "rg" {
  name     = "my-windows-server-rg"
  location = "East US 2" # Choisissez la région souhaitée
}

resource "azurerm_virtual_network" "vnet" {
  name                = "my-vnet"
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
}

resource "azurerm_subnet" "subnet" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "windows-server-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowWinRM"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5985"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowRDP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_public_ip" "pip" {
  name                = "windows-server-pip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Dynamic" # Vous pouvez choisir "Static" si vous avez besoin d'une IP publique fixe
}

resource "azurerm_network_interface" "nic" {
  name                = "windows-server-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                = "windows-server-2022"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_DS1_v2" # Choisissez la taille de VM souhaitée
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]
  admin_username        = "adminuser" # Remplacez par le nom d'utilisateur souhaité
  admin_password        = "P@$$wOrd1234!" # Remplacez par un mot de passe sécurisé
  provisioner "local-exec" { # Ceci est déconseillé pour la production, utilisez plutôt des extensions ou des outils de configuration
    command = "echo 'Warning: Using local-exec with plain text password. Consider using Azure Key Vault or other secure methods for password management.' > warning.txt"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
}

resource "azurerm_network_interface_security_group_association" "nic_nsg_association" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

output "public_ip_address_id" {
  value = azurerm_public_ip.pip.ip_address
  description = "The public IP address of the Windows Server VM"
  
}