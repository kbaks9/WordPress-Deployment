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

module "compute" {
  source              = "./modules/compute"
  location            = var.location
  resource_group      = var.resource_group
  app_virtual_machine = var.app_virtual_machine
  network_interface   = var.network_interface
  subnet_id           = module.network.subnet
  admin_user          = var.admin_user
  admin_pass          = var.admin_pass
}

module "network" {
  source               = "./modules/network"
  location             = var.location
  resource_group       = var.resource_group
  virtual_network_name = var.virtual_network_name
  subnet_name          = var.subnet_name
}
