output "subnet_id" {
  description = "ID of the internal subnet"
  value       = azurerm_subnet.subnetA.id
}

output "public_ip_id" {
  description = "ID of the public IP"
  value       = azurerm_public_ip.vm_public_ip.id
}

output "public_ip_address" {
  description = "The actual public IP address"
  value       = azurerm_public_ip.vm_public_ip.ip_address
}
