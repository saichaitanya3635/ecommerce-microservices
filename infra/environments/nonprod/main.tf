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

module "monitoring" {
  source = "../../modules/monitoring"

  name_suffix         = local.name_suffix
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  retention_in_days   = 30
  daily_quota_gb      = 0.5

  tags = local.tags
}

module "keyvault" {
  source = "../../modules/keyvault"

  name_suffix                = local.name_suffix
  resource_group_name        = azurerm_resource_group.main.name
  location                   = var.location
  soft_delete_retention_days = 7
  purge_protection_enabled   = false
  admin_principal_ids        = var.kv_admin_object_ids
  log_analytics_workspace_id = module.monitoring.workspace_id

  tags = local.tags
}

module "acr" {
  source = "../../modules/acr"
  count  = var.enable_acr ? 1 : 0

  name_suffix         = local.name_suffix
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  sku                 = "Basic"

  tags = local.tags
}