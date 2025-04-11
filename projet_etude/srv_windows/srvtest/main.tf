# Créer un groupe de ressources
resource "azurerm_resource_group" "RG_infra" {
  name     = var.resource_group_name
  location = var.location
}

# Créer un réseau virtuel
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = azurerm_resource_group.RG_infra.name
  address_space       = ["10.0.0.0/16"]
}

# Créer un sous-réseau
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.RG_infra.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Créer une adresse IP publique
resource "azurerm_public_ip" "public" {
  name                = "public-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.RG_infra.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Créer une interface réseau
resource "azurerm_network_interface" "nic" {
  name                = "ethernet-${var.vm_name}"
  location            = var.location
  resource_group_name = azurerm_resource_group.RG_infra.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public.id
  }
}

# Créer une machine virtuelle Windows Server
resource "azurerm_windows_virtual_machine" "srv" {
  name                = "win-vm-srv" # Ensure this is 15 characters or fewer
  resource_group_name = azurerm_resource_group.RG_infra.name
  location            = var.location
  size                = "Standard_F4"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
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

resource "azurerm_virtual_machine_extension" "winrm_config" {
  name                 = "winrm-config"
  virtual_machine_id   = azurerm_windows_virtual_machine.srv.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = <<SETTINGS
    {
      "commandToExecute": "powershell.exe -ExecutionPolicy Unrestricted -File C:\\path\\to\\configure_winrm.ps1"
    }
  SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
      "fileUris": ["https://<storage-account-name>.blob.core.windows.net/<container-name>/configure_winrm.ps1?<sas-token>"]
    }
  PROTECTED_SETTINGS
}

output "vm_id" {
  value = azurerm_windows_virtual_machine.srv.id
}

output "vm_public_ip" {
  value = azurerm_public_ip.public.ip_address
}