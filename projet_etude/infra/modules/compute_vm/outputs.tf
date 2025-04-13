output "vm_name" {
  description = "Nom de la machine virtuelle"
  value       = azurerm_linux_virtual_machine.vm.name
}

output "public_ip" {
  description = "Adresse IP publique de la VM"
  value       = azurerm_public_ip.public_ip.ip_address
}
