# This Terraform script provisions a Windows Server virtual machine in Azure with a public IP address and a network security group allowing RDP access.
# The script includes the creation of a resource group, virtual network, subnet, network interface, and the virtual machine itself.
# It also outputs the public IP address of the virtual machine.

resource "azurerm_resource_group" "RG_infra" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_network_security_group" "security_group" {
  name                = "RG-infra-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "Allow-RDP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-winrm-5985"
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
    name                       = "Allow-winrm-5986"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5986"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

resource "azurerm_virtual_machine_extension" "winrm_config" {
  name                 = "winrm-config"
  virtual_machine_id   = azurerm_windows_virtual_machine.srv.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = <<SETTINGS
    {
      "commandToExecute": "powershell.exe -ExecutionPolicy Unrestricted -Command \"Set-Service -Name WinRM -StartupType Automatic; Start-Service -Name WinRM; winrm quickconfig -Force; winrm set winrm/config/service/auth @{Basic=\\\"true\\\"}; winrm set winrm/config/service @{AllowUnencrypted=\\\"true\\\"}; New-NetFirewallRule -Name \\\"WinRM_HTTP\\\" -DisplayName \\\"WinRM over HTTP\\\" -Enabled True -Direction Inbound -Protocol TCP -LocalPort 5985 -Action Allow\""
    }
  SETTINGS
} 

resource "azurerm_network_interface_security_group_association" "nic_sec_group" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.security_group.id
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

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

## machine virtuel

resource "azurerm_windows_virtual_machine" "srv" {
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_F4"
  admin_username      = "adminuser"
  admin_password      = "Pa$$word1234!"
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_public_ip" "public" {
  name                = "public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name

  allocation_method = "Static"
  sku               = "Standard"
}

output "vm_public_ip" {
  value       = azurerm_public_ip.public.ip_address
  description = " The public IP adress of the virtual machine"
}

