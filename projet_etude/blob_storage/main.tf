 # Resource Group
resource "azurerm_resource_group" "rg_az_lab" {
  name     = "RG-az-lab"
  location = "West Europe" # Replace with your desired Azure region
}

resource "azurerm_storage_account" "stockage_blob" {
  name                     = "vincistockageblob001"
  resource_group_name      = azurerm_resource_group.rg_az_lab.name
  location                 = azurerm_resource_group.rg_az_lab.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  

  # Optional settings (customize as needed)
  access_tier = "Cool"
  tags = {
    Environment = "Dev"
  }
}

resource "azurerm_storage_container" "containeur" {
  name                  = "vincicontainer" 
  storage_account_name  = azurerm_storage_account.stockage_blob.name
  container_access_type = "private" # Or "blob" or "container"
}
