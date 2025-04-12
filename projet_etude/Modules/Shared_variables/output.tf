# outputs.tf dans le module shared_variables

output "resource_group_name" {
  value = var.resource_group_name
}

output "location" {
  value = var.location
}

output "vnet" {
  value = var.vnet
}

output "subnet" {
  value = var.subnet
}