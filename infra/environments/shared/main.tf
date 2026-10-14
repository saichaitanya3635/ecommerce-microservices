locals {
  tags = {
    project    = "ecom"
    env        = "shared"
    managed-by = "terraform"
    repo       = "ecommerce-microservices"
  }
}

# Already unna resources ni chadavadam (create kaadu)
data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "nonprod" {
  name = "rg-ecom-nonprod"
}

data "azurerm_storage_account" "tfstate" {
  name                = "stecomtfstate7c0b03"
  resource_group_name = "rg-ecom-tfstate"
}

# CI/CD folder
resource "azurerm_resource_group" "cicd" {
  name     = "rg-ecom-cicd"
  location = var.location
  tags     = local.tags
}

# ---------- Robot identities ----------
resource "azurerm_user_assigned_identity" "plan_nonprod" {
  name                = "id-github-plan-nonprod"
  resource_group_name = azurerm_resource_group.cicd.name
  location            = var.location
  tags                = local.tags
}

resource "azurerm_user_assigned_identity" "apply_nonprod" {
  name                = "id-github-apply-nonprod"
  resource_group_name = azurerm_resource_group.cicd.name
  location            = var.location
  tags                = local.tags
}

# ---------- Trust: "ee repo nunchi vache robot ni nammu" ----------
resource "azurerm_federated_identity_credential" "plan_nonprod_pr" {
  name                      = "github-pull-request"
  user_assigned_identity_id = azurerm_user_assigned_identity.plan_nonprod.id
  audience                  = ["api://AzureADTokenExchange"]
  issuer                    = "https://token.actions.githubusercontent.com"
  subject                   = "repo:${var.github_repo}:pull_request"
}

resource "azurerm_federated_identity_credential" "apply_nonprod_env" {
  name                      = "github-env-nonprod"
  user_assigned_identity_id = azurerm_user_assigned_identity.apply_nonprod.id
  audience                  = ["api://AzureADTokenExchange"]
  issuer                    = "https://token.actions.githubusercontent.com"
  subject                   = "repo:${var.github_repo}:environment:nonprod"
}

# ---------- Permissions ----------
locals {
  principals = {
    plan  = azurerm_user_assigned_identity.plan_nonprod.principal_id
    apply = azurerm_user_assigned_identity.apply_nonprod.principal_id
  }

  role_assignments = {
    plan_reader       = { who = "plan", role = "Reader", scope = data.azurerm_resource_group.nonprod.id }
    plan_kv_reader    = { who = "plan", role = "Key Vault Reader", scope = data.azurerm_resource_group.nonprod.id }
    plan_state        = { who = "plan", role = "Storage Blob Data Contributor", scope = data.azurerm_storage_account.tfstate.id }
    plan_aks_user     = { who = "plan", role = "Azure Kubernetes Service Cluster User Role", scope = data.azurerm_resource_group.nonprod.id }
    apply_contributor = { who = "apply", role = "Contributor", scope = data.azurerm_resource_group.nonprod.id }
    apply_rbac_admin  = { who = "apply", role = "Role Based Access Control Administrator", scope = data.azurerm_resource_group.nonprod.id }
    apply_kv_reader   = { who = "apply", role = "Key Vault Reader", scope = data.azurerm_resource_group.nonprod.id }
    apply_state       = { who = "apply", role = "Storage Blob Data Contributor", scope = data.azurerm_storage_account.tfstate.id }
  }
}

resource "azurerm_role_assignment" "github" {
  for_each             = local.role_assignments
  scope                = each.value.scope
  role_definition_name = each.value.role
  principal_id         = local.principals[each.value.who]
  principal_type       = "ServicePrincipal"
}