provider "azurerm" {
  features {
    resource_group {
      # RG lopala resources unte RG delete avvakunda safety
      prevent_deletion_if_contains_resources = true
    }
    key_vault {
      # Nonprod: destroy chesinappudu purge chesi, malli apply lo same name dorakali
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
  # subscription_id ARM_SUBSCRIPTION_ID env variable nunchi vastundi
}