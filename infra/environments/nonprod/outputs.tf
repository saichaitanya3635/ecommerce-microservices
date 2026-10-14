output "acr_login_server" {
  value = var.enable_acr ? module.acr[0].login_server : null
}

output "key_vault_name" {
  value = module.keyvault.key_vault_name
}