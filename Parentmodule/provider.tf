terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.43.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-saumya-for-backend"
    storage_account_name = "stgacsaumya4backend123"
    container_name       = "tfstate-container123"
    key                  = "prod.terraform.tfstate"

  }
}

provider "azurerm" {
  features {}
  subscription_id = "e8e67e49-af5a-4a37-abc9-4599917aee83"
}
