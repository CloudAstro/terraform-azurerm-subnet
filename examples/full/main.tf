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
  source                                        = "../.."
  name                                          = "subnet1"
  resource_group_name                           = azurerm_resource_group.vnetrg.name
  virtual_network_name                          = module.vnet.virtual_network.name
  default_outbound_access_enabled               = true
  address_prefixes                              = ["10.10.0.0/24"]
  private_link_service_network_policies_enabled = true
  private_endpoint_network_policies             = "Enabled"
  service_endpoints                             = ["Microsoft.Storage", "Microsoft.Sql"]
  delegation = [{
    name = "delegation"
    service_delegation = {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }]
}
