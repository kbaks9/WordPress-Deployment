resource "azurerm_network_interface" "network_interface" {
  name                = var.network_interface
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = var.app_virtual_machine
  resource_group_name = var.resource_group
  location            = var.location
  size                = "Standard_F2"
  admin_username      = var.admin_user
  admin_password      = var.admin_pass
  network_interface_ids = [
    azurerm_network_interface.network_interface.id,
  ]

  # admin_ssh_key {
  #   username   = "adminuser"
  #   public_key = file("~/.ssh/id_rsa.pub")
  # }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
