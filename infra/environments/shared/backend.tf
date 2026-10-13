terraform {
  backend "azurerm" {
    resource_group_name  = "rg-ecom-tfstate"
    storage_account_name = "stecomtfstate7c0b03"
    container_name       = "tfstate"
    key                  = "shared.tfstate"
    use_azuread_auth     = true
  }
}