# Network security group
resource "azurerm_network_security_group" "vm_nsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.resource_group
}

# SSH rule
resource "azurerm_network_security_rule" "allow_ssh" {
  name                        = var.ssh_name
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group
  network_security_group_name = azurerm_network_security_group.vm_nsg.name
}

resource "azurerm_network_interface_security_group_association" "nsg_nic_association" {
  network_interface_id      = var.network_interface_id
  network_security_group_id = azurerm_network_security_group.vm_nsg.id
}
