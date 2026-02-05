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

  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group
  location = var.location
}

module "compute" {
  source              = "./modules/compute"
  location            = azurerm_resource_group.resource_group.location
  resource_group      = azurerm_resource_group.resource_group.name
  app_virtual_machine = var.app_virtual_machine
  network_interface   = var.network_interface
  subnet_id           = module.network.subnet_id
  admin_user          = var.admin_user
  admin_pass          = var.admin_pass
  ssh_public_key      = "~/.ssh/wordpress_vm.pub"
}

module "network" {
  source               = "./modules/network"
  location             = azurerm_resource_group.resource_group.location
  resource_group       = azurerm_resource_group.resource_group.name
  virtual_network_name = var.virtual_network_name
  subnet_name          = var.subnet_name
}
