resource "azurerm_network_security_group" "vm_nsg" {
  name                = "vm-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "ingress-from-bastion"
    priority                   = 500
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    destination_port_range     = "22"
    source_port_range          = "*"
    source_address_prefixes    = azurerm_subnet.bastion.address_prefixes
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "no-ingress-from-other-vms"
    priority                   = 600
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    destination_port_range     = "22"
    source_port_range          = "*"
    source_address_prefixes    = azurerm_subnet.private.address_prefixes
    destination_address_prefix = "*"
  }

  # Allow all outbound
  security_rule {
    name                       = "all-egress"
    priority                   = 500
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "*"
  }
}

# Associate NSG with VM's NIC
resource "azurerm_network_interface_security_group_association" "vm_nsg_association" {
  network_interface_id      = azurerm_network_interface.vm1_nic.id
  network_security_group_id = azurerm_network_security_group.vm_nsg.id
} 