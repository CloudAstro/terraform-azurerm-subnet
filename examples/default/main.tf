resource "azurerm_resource_group" "vnetrg" {
  name     = "rg-vnet-example"
  location = "germanywestcentral"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-example"
  location            = azurerm_resource_group.vnetrg.location
  resource_group_name = azurerm_resource_group.vnetrg.name
  address_space       = ["10.10.0.0/24"]
}

module "subnet" {
  source               = "../.."
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.vnetrg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.10.0.0/24"]
}
