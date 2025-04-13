output "vnet_name" {
  description = "Nom du Virtual Network"
  value       = azurerm_virtual_network.vnet.name
}

output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}
