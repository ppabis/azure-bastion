resource "azurerm_resource_group" "rg" {
  name     = "default-rg"
  location = "germanywestcentral"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-default"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.180.0.0/16"]
}

resource "azurerm_subnet" "private" {
  name                 = "private"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.180.0.0/24"]
}