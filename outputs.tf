output "vm_public_ip" {
  description = "Public IP address of the VM"
  value       = module.network.public_ip_address
}
