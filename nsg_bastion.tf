variable "allowed_subnet" {
  description = "Subnet CIDR that is allowed to access the Bastion"
  type        = string
  default     = "10.0.0.0/24" # Change this to your allowed subnet
}

resource "azurerm_network_security_group" "bastion_nsg" {
  name                = "bastion-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  dynamic "security_rule" {
    for_each = {
      "public-ip" = {
        prefix   = var.allowed_subnet
        priority = 150
      }
      "gateway-manager" = {
        prefix   = "GatewayManager"
        priority = 160
      }
      "azure-load-balancer" = {
        prefix   = "AzureLoadBalancer"
        priority = 170
      }
    }

    content {
      name                       = "ingress-${security_rule.key}"
      priority                   = security_rule.value.priority
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = security_rule.value.prefix
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "443"
    }
  }

  # Egress to target VMs
  security_rule {
    name                       = "all-egress"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "*"
  }
}

# Associate NSG with Bastion subnet
resource "azurerm_subnet_network_security_group_association" "bastion_nsg_association" {
  subnet_id                 = azurerm_subnet.bastion.id
  network_security_group_id = azurerm_network_security_group.bastion_nsg.id
}