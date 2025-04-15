variable "resource_group_name" {
  type        = string
  default     = "rg-winvm"
}

variable "location" {
  type        = string
  default     = "East US"
}

variable "admin_username" {
  type        = string
  default     = "adminuser"
}

variable "admin_password" {
  type        = string
  sensitive   = true
  default     = "Pa$$word1234!"
}
