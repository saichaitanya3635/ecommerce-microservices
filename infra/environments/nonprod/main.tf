resource "azurerm_resource_group" "main" {
  name     = "rg-${local.name_suffix}"
  location = var.location
  tags     = local.tags
}

module "network" {
  source = "../../modules/network"

  name_suffix         = local.name_suffix
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  address_space       = ["10.10.0.0/16"]

  subnet_prefixes = {
    aks               = "10.10.0.0/22"
    postgres          = "10.10.8.0/24"
    private_endpoints = "10.10.9.0/24"
  }

  tags = local.tags
}