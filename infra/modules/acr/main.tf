data "azurerm_client_config" "current" {}

locals {
  unique_suffix = substr(md5(data.azurerm_client_config.current.subscription_id), 0, 6)
}

resource "azurerm_container_registry" "main" {
  # ACR peru lo "-" allowed kaadu, letters + numbers matrame
  name                = replace("acr${var.name_suffix}${local.unique_suffix}", "-", "")
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = false # Username/password OFF, permissions (RBAC) tho matrame access 🔒
  tags                = var.tags
}