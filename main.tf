terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.1"
    }
  }
}
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg-wordpress" {
  name     = var.resource_group
  location = var.location
}

# module "" {
#   source = "./modules"
# }
