variable "resource_group" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location of the resources"
  type        = string
}

variable "nsg_name" {
  description = "The name of the network security group"
  type        = string
}

variable "ssh_name" {
  description = "The name of the secure shell"
  type        = string
}

variable "network_interface_id" {
  description = "The name of the network interface"
  type        = string
}
