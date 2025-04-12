resource_group_name = "RG-infra"
location = "France Central"
vnet_name = "Vnet-Infra"
subnet_name = "Subnet-web"


# Configuration du VNet
vnet = {
  name          = "vnet-infra"
  address_space = ["10.0.0.0/16"]
}

# Configuration du Subnet
subnet = {
  name           = "subnet-web"
  address_prefix = "10.0.1.0/24"
}