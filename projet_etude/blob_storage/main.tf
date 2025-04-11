# Créer un groupe de ressources
resource "azurerm_resource_group" "RG" {
  name     = var.resource_group_name
  location = var.location
}

# Créer un compte de stockage
resource "azurerm_storage_account" "stockage_blob" {
  name                     = "vincistockageblob001" # Le nom doit être unique globalement
  resource_group_name      = azurerm_resource_group.RG.name
  location                 = azurerm_resource_group.RG.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # Paramètres optionnels
  access_tier = "Cool"
  tags = {
    Environment = "Dev"
  }
}

# Créer un conteneur de stockage
resource "azurerm_storage_container" "containeur" {
  name                  = "vincicontainer"
  storage_account_id    = azurerm_storage_account.stockage_blob.id
  container_access_type = "private" # Options : "private", "blob", "container"
}

# Télécharger un fichier blob dans le conteneur
resource "azurerm_storage_blob" "stockage_blob" {
  name                   = "configure_winrm.ps1" # Nom du fichier dans le conteneur
  storage_account_name   = azurerm_storage_account.stockage_blob.name
  storage_container_name = azurerm_storage_container.containeur.name
  type                   = "Block" # Options : "Block", "Append", "Page"
  source                 = "C:/Infra_as_code/projet_etude/blob_storage/configure_winrm.ps1" # Chemin vers le fichier local

  # Paramètres optionnels
  content_type = "text/plain" # Ajustez en fonction du type de fichier
}

# Outputs pour afficher les informations importantes
output "storage_account_name" {
  value       = azurerm_storage_account.stockage_blob.name
  description = "Le nom du compte de stockage"
}

output "storage_account_key" {
  value       = azurerm_storage_account.stockage_blob.primary_access_key
  description = "La clé d'accès primaire du compte de stockage"
  sensitive   = true
}

output "blob_url" {
  value       = azurerm_storage_blob.stockage_blob.url
  description = "L'URL du fichier blob"
}
