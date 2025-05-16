variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
}

variable "vm_name" {
  description = "The name of the virtual machine"
  type        = string
}

variable "hostname" {
  description = "The hostname of the virtual machine"
  type        = string
}

variable "vm_size" {
  description = "The size of the virtual machine"
  type        = string
}

variable "public_ip_name" {
  description = "The name of the public IP address"
  type        = string
}



variable "admin_username" {
  type        = string
  default     = "adminuser"
}

variable "admin_password" {
  type        = string
  sensitive   = true
}

variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
}

variable "address_space" {
  description = "The address space for the virtual network"
  type        = list(string) # A list of strings for CIDR blocks
 }

variable "subnet_prefix" {
  description = "The address prefix for the subnet"
  type        = string
}

variable "security_group_name" {
  description = "The name of the network security group"
  type        = string
}

variable "client_secret" {
  description = "Client secret for authentication"
  type        = string
  sensitive   = true
}


