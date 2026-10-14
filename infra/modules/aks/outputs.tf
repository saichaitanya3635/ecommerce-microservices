output "name" {
  value = azurerm_kubernetes_cluster.main.name
}

output "id" {
  value = azurerm_kubernetes_cluster.main.id
}

output "oidc_issuer_url" {
  value = azurerm_kubernetes_cluster.main.oidc_issuer_url
}

output "kubelet_object_id" {
  value = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}