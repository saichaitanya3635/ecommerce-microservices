data "azurerm_client_config" "current" {}

locals {
  # Key Vault name world lo unique undali: subscription nunchi chinna suffix
  unique_suffix = substr(md5(data.azurerm_client_config.current.subscription_id), 0, 6)
}

resource "azurerm_key_vault" "main" {
  name                          = "kv-${var.name_suffix}-${local.unique_suffix}"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = "standard"
  rbac_authorization_enabled    = true
  soft_delete_retention_days    = var.soft_delete_retention_days
  purge_protection_enabled      = var.purge_protection_enabled
  public_network_access_enabled = true # Step 11 lo private endpoint pettaka false
  tags                          = var.tags
}

# Admins ki secrets manage cheyyadaniki permission
resource "azurerm_role_assignment" "admins" {
  for_each             = toset(var.admin_principal_ids)
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = each.value
}

# Audit logs: evaru, eppudu, ye secret access chesaro record
resource "azurerm_monitor_diagnostic_setting" "kv" {
  name                       = "diag-to-log-analytics"
  target_resource_id         = azurerm_key_vault.main.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category_group = "audit"
  }
}