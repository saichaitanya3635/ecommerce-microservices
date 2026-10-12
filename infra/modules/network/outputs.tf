output "vnet_id" {
  value = azurerm_virtual_network.main.id
}

output "vnet_name" {
  value = azurerm_virtual_network.main.name
}

output "subnet_ids" {
  value = {
    aks               = azurerm_subnet.aks.id
    postgres          = azurerm_subnet.postgres.id
    private_endpoints = azurerm_subnet.private_endpoints.id
  }
}