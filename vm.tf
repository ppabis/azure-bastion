
resource "azurerm_network_interface" "vm1_nic" {
  name                = "vm1-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "nic-ip"
    subnet_id                     = azurerm_subnet.private.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "vm1" {
  name                          = "vm1"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  network_interface_ids         = [azurerm_network_interface.vm1_nic.id]
  vm_size                       = "Standard_B1s"
  delete_os_disk_on_termination = true
  storage_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
  storage_os_disk {
    name          = "vm1-os-disk"
    create_option = "FromImage"
    caching       = "ReadWrite"
    disk_size_gb  = 30
  }
  os_profile {
    admin_username = "azureuser"
    computer_name  = "vm1"
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = tls_private_key.ssh_key.public_key_openssh
      path     = "/home/azureuser/.ssh/authorized_keys"
    }
  }
}