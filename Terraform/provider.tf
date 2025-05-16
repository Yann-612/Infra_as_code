# This file contains the provider configuration for AzureRM

provider "azurerm" {
subscription_id = "646ca952-46fb-4252-912d-cc379b67948b"
client_id = "d96bf417-1a9f-402c-8d0a-bf96649c09ad" # AppId
client_secret = var.client_secret # password
tenant_id = "b7b023b8-7c32-4c02-92a6-c8cdaa1d189c" # tenant
features {}
}
