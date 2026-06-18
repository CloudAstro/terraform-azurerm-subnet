resource "azurerm_resource_group" "vnetrg" {
  name     = "rg-vnet-example"
  location = "germanywestcentral"
}

module "vnet" {
  source              = "CloudAstro/virtual-network/azurerm"
  name                = "vnet-example"
  resource_group_name = azurerm_resource_group.vnetrg.name
  address_space       = ["10.10.0.0/24"]
  location            = azurerm_resource_group.vnetrg.location
}

module "subnet" {
  source               = "../.."
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.vnetrg.name
  virtual_network_name = module.vnet.virtual_network.name
  address_prefixes     = ["10.10.0.0/24"]
}
