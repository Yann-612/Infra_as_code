# Terraform-Vrac
# Provisionnement Azure

# Main.tf

resource "azurerm_resource_group" "ressource" {
  name     = "gsu_grp_ressource"
  location = "west europe"
}

resource "azurerm_network_security_group" "reseau_azure" {
  name                = "gsu-reseau-azure"
  location            = azurerm_resource_group.ressource.location
  resource_group_name = azurerm_resource_group.ressource.name

security_rule {
    name                       = "SSH-in"
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
    name                       = "SSH-out"
    priority                   = 1002
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }


}

resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.example.id
  network_security_group_id = azurerm_network_security_group.reseau_azure.id
}

resource "azurerm_virtual_network" "reseau_virtuel" {
  name                = "reseau_vituel"
  location            = "west europe"
  resource_group_name = azurerm_resource_group.ressource.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]
}

resource "azurerm_subnet" "subnet1" {
  name = "subnet"
  virtual_network_name = azurerm_virtual_network.reseau_virtuel.name
  resource_group_name = azurerm_resource_group.ressource.name
  address_prefixes = ["10.0.0.0/16"  ]
}

resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.ressource.location
  resource_group_name = azurerm_resource_group.ressource.name


  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}


resource "azurerm_linux_virtual_machine" "Linux" {
  name                = "Ubuntu-24.04"
  resource_group_name = azurerm_resource_group.ressource.name
  location            = azurerm_resource_group.ressource.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

### ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("C:/projet/Terraform_projets/id_rsa.pub")
  }


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }


  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

resource "azurerm_public_ip" "example" {
  name                = "example-pip"
  location            = azurerm_resource_group.ressource.location
  resource_group_name = azurerm_resource_group.ressource.name
  allocation_method   = "Static"
}

output "vm_public_ip" {
  value = azurerm_public_ip.example.ip_address
}
