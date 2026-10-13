output "tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}

output "plan_client_id" {
  value = azurerm_user_assigned_identity.plan_nonprod.client_id
}

output "apply_client_id" {
  value = azurerm_user_assigned_identity.apply_nonprod.client_id
}