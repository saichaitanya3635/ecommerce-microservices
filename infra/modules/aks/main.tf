data "azurerm_client_config" "current" {}

# ---------- AKS control plane identity ----------
resource "azurerm_user_assigned_identity" "aks" {
  name                = "id-aks-${var.name_suffix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

# AKS ki mana subnet lo network panulu cheyyadaniki permission
resource "azurerm_role_assignment" "aks_network" {
  scope                = var.subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}

# ---------- Cluster ----------
resource "azurerm_kubernetes_cluster" "main" {
  name                = "aks-${var.name_suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "aks-${var.name_suffix}"
  node_resource_group = "rg-${var.name_suffix}-aks-nodes"
  kubernetes_version  = var.kubernetes_version
  sku_tier            = "Free"
  
  node_provisioning_profile {
    mode = "Manual"
  }

  automatic_upgrade_channel = "patch"
  node_os_upgrade_channel   = "NodeImage"

  # Pods ki password lekunda Azure access
  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  # kubectl: local admin OFF, Entra login + Azure RBAC matrame
  local_account_disabled            = true
  role_based_access_control_enabled = true
  azure_active_directory_role_based_access_control {
    azure_rbac_enabled = true
    tenant_id          = data.azurerm_client_config.current.tenant_id
  }

  default_node_pool {
    name                         = "system"
    vm_size                      = var.system_vm_size
    node_count                   = 1
    vnet_subnet_id               = var.subnet_id
    os_disk_size_gb              = 30
    only_critical_addons_enabled = true
    temporary_name_for_rotation  = "systemtmp"

    upgrade_settings {
      max_surge = "1"
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks.id]
  }

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    pod_cidr            = "192.168.0.0/16"
    service_cidr        = "172.16.0.0/16"
    dns_service_ip      = "172.16.0.10"
    load_balancer_sku   = "standard"
    outbound_type       = "loadBalancer"
  }

  oms_agent {
    log_analytics_workspace_id      = var.log_analytics_workspace_id
    msi_auth_for_monitoring_enabled = true
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  tags = var.tags

  depends_on = [azurerm_role_assignment.aks_network]
}

# ---------- Apps node pool ----------
resource "azurerm_kubernetes_cluster_node_pool" "apps" {
  name                  = "apps"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vm_size               = var.apps_vm_size
  node_count            = var.apps_node_count
  vnet_subnet_id        = var.subnet_id
  mode                  = "User"
  os_disk_size_gb       = 30

  upgrade_settings {
    max_surge = "1"
  }

  tags = var.tags
}

# ---------- Permissions ----------
resource "azurerm_role_assignment" "acr_pull" {
  count                = var.attach_acr ? 1 : 0
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}

resource "azurerm_role_assignment" "cluster_admins" {
  for_each             = toset(var.admin_object_ids)
  scope                = azurerm_kubernetes_cluster.main.id
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id         = each.value
}