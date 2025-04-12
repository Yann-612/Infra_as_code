
# Output the resource group name and location
# outputs.tf dans le module resource_group


output "name" {
  value = azurerm_resource_group.rg.name
}

output "location" {
  value = azurerm_resource_group.rg.location
}
