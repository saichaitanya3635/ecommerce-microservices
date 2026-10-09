provider "azurerm" {
  features {
    resource_group {
      # RG lopala resources unte RG delete avvakunda safety
      prevent_deletion_if_contains_resources = true
    }
  }
  # subscription_id ARM_SUBSCRIPTION_ID env variable nunchi vastundi
}