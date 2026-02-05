variable "resource_group" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location of the resources"
  type        = string
}

variable "network_interface_name" {
  description = "The name of the network interface"
  type        = string
}

variable "app_virtual_machine" {
  description = "The name of the virtual machine"
  type        = string
}

variable "subnet_id" {
  description = "The id of the internal subnet"
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

variable "ssh_public_key" {
  description = "The SSH public key"
  type        = string
}

variable "public_ip_id" {
  description = "The ID of the public IP address"
  type        = string
}
