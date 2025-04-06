# Crée un groupe de ressources Azure où tous les autres services seront déployés.
resource "azurerm_resource_group" "example" {
  name     = "example-resources" # Nom du groupe de ressources.
  location = "West Europe"       # Région Azure où les ressources seront créées.
}

# Provisionne une infrastructure Oracle Exadata dans Azure.
resource "azurerm_oracle_exadata_infrastructure" "example" {
  name                = "example-exadata-infrastructure" # Nom interne de l'infrastructure.
  display_name        = "example-exadata-infrastructure" # Nom affiché dans le portail Azure.
  location            = azurerm_resource_group.example.location # Région Azure (héritée du groupe de ressources).
  resource_group_name = azurerm_resource_group.example.name      # Groupe de ressources où l'infrastructure sera créée.
  shape               = "Exadata.X9M"                           # Type d'infrastructure Exadata (modèle).
  storage_count       = "3"                                     # Nombre de serveurs de stockage.
  compute_count       = "2"                                     # Nombre de serveurs de calcul.
  zones               = ["3"]                                   # Zone de disponibilité Azure.
}

# Crée un réseau virtuel Azure pour connecter les ressources.
resource "azurerm_virtual_network" "example" {
  name                = "example-virtual-network" # Nom du réseau virtuel.
  address_space       = ["10.0.0.0/16"]           # Plage d'adresses IP pour le réseau.
  location            = azurerm_resource_group.example.location # Région Azure.
  resource_group_name = azurerm_resource_group.example.name      # Groupe de ressources associé.
}

# Crée un sous-réseau dans le réseau virtuel.
resource "azurerm_subnet" "example" {
  name                 = "example-subnet" # Nom du sous-réseau.
  resource_group_name  = azurerm_resource_group.example.name # Groupe de ressources associé.
  virtual_network_name = azurerm_virtual_network.example.name # Réseau virtuel parent.
  address_prefixes     = ["10.0.1.0/24"] # Plage d'adresses IP pour le sous-réseau.

  # Délégation de service pour permettre à Oracle Database d'utiliser ce sous-réseau.
  delegation {
    name = "delegation" # Nom de la délégation.

    service_delegation {
      actions = [
        "Microsoft.Network/networkinterfaces/*", # Actions autorisées sur les interfaces réseau.
        "Microsoft.Network/virtualNetworks/subnets/join/action", # Autorisation de joindre des sous-réseaux.
      ]
      name = "Oracle.Database/networkAttachments" # Service délégué pour Oracle Database.
    }
  }
}

# Récupère les serveurs Oracle DB disponibles dans l'infrastructure Exadata.
data "azurerm_oracle_db_servers" "example" {
  resource_group_name               = azurerm_resource_group.example.name # Groupe de ressources associé.
  cloud_exadata_infrastructure_name = azurerm_oracle_exadata_infrastructure.example.name # Nom de l'infrastructure Exadata.
}

# Crée un cluster Oracle Cloud VM dans l'infrastructure Exadata.
resource "azurerm_oracle_cloud_vm_cluster" "example" {
  name                            = "example-cloud-vm-cluster" # Nom du cluster.
  resource_group_name             = azurerm_resource_group.example.name # Groupe de ressources associé.
  location                        = azurerm_resource_group.example.location # Région Azure.
  gi_version                      = "23.0.0.0" # Version de Grid Infrastructure (Oracle).
  virtual_network_id              = azurerm_virtual_network.example.id # ID du réseau virtuel.
  license_model                   = "BringYourOwnLicense" # Modèle de licence (utilisation de votre propre licence Oracle).
  db_servers                      = [for obj in data.azurerm_oracle_db_servers.example.db_servers : obj.ocid] # Liste des serveurs DB disponibles.
  ssh_public_keys                 = [file("~/.ssh/id_rsa.pub")] # Clé publique SSH pour accéder au cluster.
  display_name                    = "example-cloud-vm-cluster" # Nom affiché dans le portail Azure.
  cloud_exadata_infrastructure_id = azurerm_oracle_exadata_infrastructure.example.id # ID de l'infrastructure Exadata.
  cpu_core_count                  = 2 # Nombre de cœurs CPU alloués.
  hostname                        = "hostname" # Nom d'hôte du cluster.
  subnet_id                       = azurerm_subnet.example.id # ID du sous-réseau associé.
}