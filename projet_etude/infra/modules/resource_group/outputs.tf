output "name" {
  description = "Nom du Resource Group"
  value       = azurerm_resource_group.rg.name
}

output "location" {
  description = "Région du Resource Group"
  value       = azurerm_resource_group.rg.location
}
