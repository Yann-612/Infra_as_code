output "public_ip_address" {
  value = azurerm_public_ip.public_ip.ip_address
}

output "vm_id" {
  value       = azurerm_windows_virtual_machine.vm.id
  description = "The ID of the virtual machine"
}
