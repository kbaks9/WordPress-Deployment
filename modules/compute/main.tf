resource "azurerm_network_interface" "network_interface" {
  name                = var.network_interface_name
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip_id
  }
}

resource "azurerm_linux_virtual_machine" "vm_linux" {
  name                            = var.app_virtual_machine
  resource_group_name             = var.resource_group
  location                        = var.location
  size                            = "Standard_F2"
  admin_username                  = var.admin_user
  admin_password                  = var.admin_pass
  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.network_interface.id,
  ]

  admin_ssh_key {
    username   = var.admin_user
    public_key = file(var.ssh_public_key)
  }

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

data "local_file" "wordpress_script" {
  filename = "${path.root}/script/wordpress.sh"
}

# Allows custom scripts
resource "azurerm_virtual_machine_extension" "vm_extension" {
  name                 = var.appvm_extension
  virtual_machine_id   = azurerm_linux_virtual_machine.vm_linux.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  protected_settings = <<PROT
 {
  "script": "${base64encode(data.local_file.wordpress_script.content)}"
 }
PROT
}
