variable "resource_group" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location of the resources"
  type        = string
}

### Compute

variable "network_interface" {
  description = "The name of the network interface"
  type        = string
}

variable "app_virtual_machine" {
  description = "The name of the virtual machine"
  type        = string
}

variable "admin_user" {
  description = "The admin username"
  type        = string
}

variable "admin_pass" {
  description = "The admin password"
  type        = string
}

##### Network

variable "virtual_network_name" {
  description = "The name of the virtual network"
  type        = string
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
}
