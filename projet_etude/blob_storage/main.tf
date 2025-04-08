 # Resource Group
resource "azurerm_resource_group" "rg_az_lab" {
  name     = "RG-az-lab"
  location = "West Europe" # Replace with your desired Azure region
}

##  Blob stockage

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


## Containeur

resource "azurerm_storage_container" "containeur" {
  name                  = "vincicontainer" 
  storage_account_id  = azurerm_storage_account.stockage_blob.id
  container_access_type = "private" # Or "blob" or "container"
}


## Fichier à Uploader 

resource "azurerm_storage_blob" "stockage_blob" {
  name           = "configure_winrm.ps1" # le fichier à uploader
  storage_account_name = azurerm_storage_account.stockage_blob.name
  storage_container_name = azurerm_storage_container.containeur.name
  type           = "Block" # Or "Append" or "Page"
  source         = "/home/yannick/Infra_as_code/projet_etude/blob_storage/configure_winrm.ps1" # Replace with the actual path to your file

  # Optional settings
  content_type = "text/plain" # Adjust based on the file type
}
