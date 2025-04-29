<!-- BEGINNING OF PRE-COMMIT-OPENTOFU DOCS HOOK -->
# Azure Subnet Terraform Module

[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-blue.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![OpenTofu Registry](https://img.shields.io/badge/opentofu-registry-yellow.svg)](https://search.opentofu.org/module/CloudAstro/subnet/azurerm/)

This module is designed to manage individual subnets within an Azure Virtual Network (VNet). Each subnet can be customized with various configurations including address prefixes, service endpoints, and network policies. It also supports dynamic delegation settings for specific use cases.

# Features

- Subnet Management: Facilitates the creation and management of individual subnets within a VNet.
- Configurable Address Prefixes: Allows specification of address prefixes for each subnet.
- Service Endpoints: Supports configuration of service endpoints for enhanced connectivity.
- Network Policies: Enables or disables network policies such as private link service and private endpoint policies.
- Dynamic Delegation: Supports dynamic delegation configurations for specific services within subnets.

# Example Usage

This example demonstrates how to provision subnets within a virtual network, each with its specific configurations and optional delegations.

```hcl
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
  source                                        = "../.."
  name                                          = "subnet1"
  resource_group_name                           = azurerm_resource_group.vnetrg.name
  virtual_network_name                          = azurerm_virtual_network.vnet.name
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
```
<!-- markdownlint-disable MD033 -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.9.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 4.0.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |

<!-- markdownlint-disable MD013 -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_prefixes"></a> [address\_prefixes](#input\_address\_prefixes) | * `address_prefixes` - (Required) The address prefixes to use for the subnet.<br/><br/>-> **NOTE:** Currently only a single address prefix can be set as the [Multiple Subnet Address Prefixes Feature](https://github.com/Azure/azure-cli/issues/18194#issuecomment-880484269) is not yet in public preview or general availability.<br/><br/>Example Input:<pre>address_prefixes = ["10.0.1.0/24"]</pre> | `list(string)` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | * `name` - (Required) The name of the subnet. Changing this forces a new resource to be created.<br/><br/>Example Input:<pre>name = "snet-aks"</pre> | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | * `resource_group_name` - (Required) The name of the resource group in which to create the subnet. This must be the resource group that the virtual network resides in. Changing this forces a new resource to be created.<br/><br/>Example Input:<pre>resource_group_name = "rg-vnet-gwc-hub"</pre> | `string` | n/a | yes |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | * `virtual_network_name` - (Required) The name of the virtual network to which to attach the subnet. Changing this forces a new resource to be created.<br/><br/>Example Input:<pre>virtual_network_name = "vnet-gwc-hub"</pre> | `string` | n/a | yes |
| <a name="input_default_outbound_access_enabled"></a> [default\_outbound\_access\_enabled](#input\_default\_outbound\_access\_enabled) | * `default_outbound_access_enabled` - (Optional) Enable default outbound access to the internet for the subnet. Defaults to `true`.<br/><br/>Example Input:<pre>default_outbound_access_enabled = true</pre> | `bool` | `true` | no |
| <a name="input_delegation"></a> [delegation](#input\_delegation) | * `delegation` - (Optional) One or more `delegation` blocks as defined below.<br/>A `delegation` block supports the following:<br/>  * `name` - (Required) A name for this delegation.<br/>  * `service_delegation` - (Required) A `service_delegation` block as defined below.<br/>A `service_delegation` block supports the following:<br/><br/>-> **Note:** Delegating to services may not be available in all regions. Check that the service you are delegating to is available in your region using the [Azure CLI](https://docs.microsoft.com/cli/azure/network/vnet/subnet?view=azure-cli-latest#az-network-vnet-subnet-list-available-delegations). Also, `actions` is specific to each service type. The exact list of `actions` needs to be retrieved using the aforementioned [Azure CLI](https://docs.microsoft.com/cli/azure/network/vnet/subnet?view=azure-cli-latest#az-network-vnet-subnet-list-available-delegations).<br/>  * `name` - (Required) The name of service to delegate to. Possible values are `GitHub.Network/networkSettings`, `Informatica.DataManagement/organizations`, `Microsoft.ApiManagement/service`, `Microsoft.Apollo/npu`, `Microsoft.App/environments`, `Microsoft.App/testClients`, `Microsoft.AVS/PrivateClouds`, `Microsoft.AzureCosmosDB/clusters`, `Microsoft.BareMetal/AzureHostedService`, `Microsoft.BareMetal/AzureHPC`, `Microsoft.BareMetal/AzurePaymentHSM`, `Microsoft.BareMetal/AzureVMware`, `Microsoft.BareMetal/CrayServers`, `Microsoft.BareMetal/MonitoringServers`, `Microsoft.Batch/batchAccounts`, `Microsoft.CloudTest/hostedpools`, `Microsoft.CloudTest/images`, `Microsoft.CloudTest/pools`, `Microsoft.Codespaces/plans`, `Microsoft.ContainerInstance/containerGroups`, `Microsoft.ContainerService/managedClusters`, `Microsoft.ContainerService/TestClients`, `Microsoft.Databricks/workspaces`, `Microsoft.DBforMySQL/flexibleServers`, `Microsoft.DBforMySQL/servers`, `Microsoft.DBforMySQL/serversv2`, `Microsoft.DBforPostgreSQL/flexibleServers`, `Microsoft.DBforPostgreSQL/serversv2`, `Microsoft.DBforPostgreSQL/singleServers`, `Microsoft.DelegatedNetwork/controller`, `Microsoft.DevCenter/networkConnection`, `Microsoft.DevOpsInfrastructure/pools`, `Microsoft.DocumentDB/cassandraClusters`, `Microsoft.Fidalgo/networkSettings`, `Microsoft.HardwareSecurityModules/dedicatedHSMs`, `Microsoft.Kusto/clusters`, `Microsoft.LabServices/labplans`, `Microsoft.Logic/integrationServiceEnvironments`, `Microsoft.MachineLearningServices/workspaces`, `Microsoft.Netapp/volumes`, `Microsoft.Network/applicationGateways`, `Microsoft.Network/dnsResolvers`, `Microsoft.Network/managedResolvers`, `Microsoft.Network/fpgaNetworkInterfaces`, `Microsoft.Network/networkWatchers.`, `Microsoft.Network/virtualNetworkGateways`, `Microsoft.Orbital/orbitalGateways`, `Microsoft.PowerAutomate/hostedRpa`, `Microsoft.PowerPlatform/enterprisePolicies`, `Microsoft.PowerPlatform/vnetaccesslinks`, `Microsoft.ServiceFabricMesh/networks`, `Microsoft.ServiceNetworking/trafficControllers`, `Microsoft.Singularity/accounts/networks`, `Microsoft.Singularity/accounts/npu`, `Microsoft.Sql/managedInstances`, `Microsoft.Sql/managedInstancesOnebox`, `Microsoft.Sql/managedInstancesStage`, `Microsoft.Sql/managedInstancesTest`, `Microsoft.Sql/servers`, `Microsoft.StoragePool/diskPools`, `Microsoft.StreamAnalytics/streamingJobs`, `Microsoft.Synapse/workspaces`, `Microsoft.Web/hostingEnvironments`, `Microsoft.Web/serverFarms`, `NGINX.NGINXPLUS/nginxDeployments`, `PaloAltoNetworks.Cloudngfw/firewalls`, `Qumulo.Storage/fileSystems`, and `Oracle.Database/networkAttachments`.<br/>  * `actions` - (Optional) A list of Actions which should be delegated. This list is specific to the service to delegate to. Possible values are `Microsoft.Network/networkinterfaces/*`, `Microsoft.Network/publicIPAddresses/join/action`, `Microsoft.Network/publicIPAddresses/read`, `Microsoft.Network/virtualNetworks/read`, `Microsoft.Network/virtualNetworks/subnets/action`, `Microsoft.Network/virtualNetworks/subnets/join/action`, `Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action`, and `Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action`.<br/><br/>  -> **Note:** Azure may add default actions depending on the service delegation name and they can't be changed.<br/><br/>Example Input:<pre>delegation = [{<br/>  name = "delegation"<br/>  service_delegation = {<br/>    name    = "Microsoft.ContainerInstance/containerGroups"<br/>    actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]<br/>  }<br/>}]</pre> | <pre>list(object({<br/>    name = string<br/>    service_delegation = object({<br/>      name    = string<br/>      actions = optional(set(string))<br/>    })<br/>  }))</pre> | `null` | no |
| <a name="input_private_endpoint_network_policies"></a> [private\_endpoint\_network\_policies](#input\_private\_endpoint\_network\_policies) | * `private_endpoint_network_policies` - (Optional) Enable or Disable network policies for the private endpoint on the subnet. Possible values are `Disabled`, `Enabled`, `NetworkSecurityGroupEnabled` and `RouteTableEnabled`. Defaults to `Disabled`.<br/><br/>-> **Note:** If you don't want to use network policies like user-defined Routes and Network Security Groups, you need to set `private_endpoint_network_policies` in the subnet to `Disabled`. This setting only applies to Private Endpoints in the Subnet and affects all Private Endpoints in the Subnet. For other resources in the Subnet, access is controlled based via the Network Security Group which can be configured using the `azurerm_subnet_network_security_group_association` resource.<br/>-> **Note:** If you want to use network policies like user-defined Routes and Network Security Groups, you need to set the `private_endpoint_network_policies` in the Subnet to `Enabled`/`NetworkSecurityGroupEnabled`/`RouteTableEnabled`. This setting only applies to Private Endpoints in the Subnet and affects all Private Endpoints in the Subnet. For other resources in the Subnet, access is controlled based via the Network Security Group which can be configured using the `azurerm_subnet_network_security_group_association` resource.<br/>-> **Note:** See more details from [Manage network policies for Private Endpoints](https://learn.microsoft.com/en-gb/azure/private-link/disable-private-endpoint-network-policy?tabs=network-policy-portal).<br/><br/>Example Input:<pre>private_endpoint_network_policies = "Disabled"</pre> | `string` | `"Disabled"` | no |
| <a name="input_private_link_service_network_policies_enabled"></a> [private\_link\_service\_network\_policies\_enabled](#input\_private\_link\_service\_network\_policies\_enabled) | * `private_link_service_network_policies_enabled` - (Optional) Enable or Disable network policies for the private link service on the subnet. Defaults to `true`.<br/><br/>-> **Note:** When configuring Azure Private Link service, the explicit setting `private_link_service_network_policies_enabled` must be set to `false` in the subnet since Private Link Service does not support network policies like user-defined Routes and Network Security Groups. This setting only affects the Private Link service. For other resources in the subnet, access is controlled based on the Network Security Group which can be configured using the `azurerm_subnet_network_security_group_association` resource. See more details from [Manage network policies for Private Link Services](https://learn.microsoft.com/en-gb/azure/private-link/disable-private-link-service-network-policy?tabs=private-link-network-policy-powershell).<br/><br/>Example Input:<pre>private_link_service_network_policies_enabled = true</pre> | `bool` | `true` | no |
| <a name="input_service_endpoint_policy_ids"></a> [service\_endpoint\_policy\_ids](#input\_service\_endpoint\_policy\_ids) | * `service_endpoint_policy_ids` - (Optional) The list of IDs of Service Endpoint Policies to associate with the subnet.<br/><br/>Example Input:<pre>service_endpoint_policy_ids = {<br/>  snet-name = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-name/providers/Microsoft.Network/serviceEndpointPolicies/test"]<br/>}</pre> | `set(string)` | `null` | no |
| <a name="input_service_endpoints"></a> [service\_endpoints](#input\_service\_endpoints) | * `service_endpoints` - (Optional) The list of Service endpoints to associate with the subnet. Possible values include: `Microsoft.AzureActiveDirectory`, `Microsoft.AzureCosmosDB`, `Microsoft.ContainerRegistry`, `Microsoft.EventHub`, `Microsoft.KeyVault`, `Microsoft.ServiceBus`, `Microsoft.Sql`, `Microsoft.Storage`, `Microsoft.Storage.Global` and `Microsoft.Web`.<br/><br/>-> **NOTE:** In order to use `Microsoft.Storage.Global` service endpoint (which allows access to virtual networks in other regions), you must enable the `AllowGlobalTagsForStorage` feature in your subscription. This is currently a preview feature, please see the [official documentation](https://learn.microsoft.com/en-us/azure/storage/common/storage-network-security?tabs=azure-cli#enabling-access-to-virtual-networks-in-other-regions-preview) for more information.<br/><br/>Example Input:<pre>service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]</pre> | `set(string)` | `null` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | The `timeouts` block allows you to specify [timeouts](https://www.terraform.io/language/resources/syntax#operation-timeouts) for certain actions:<br/>  * `create` - (Defaults to 30 minutes) Used when creating the Subnet.<br/>  * `update` - (Defaults to 30 minutes) Used when updating the Subnet.<br/>  * `read` - (Defaults to 5 minutes) Used when retrieving the Subnet.<br/>  * `delete` - (Defaults to 30 minutes) Used when deleting the Subnet. | <pre>object({<br/>    create = optional(string, "30")<br/>    update = optional(string, "30")<br/>    read   = optional(string, "5")<br/>    delete = optional(string, "30")<br/>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnet"></a> [subnet](#output\_subnet) | * `name` - Specifies the name of the Subnet.<br/>  * `virtual_network_name` - Specifies the name of the Virtual Network this Subnet is located within.<br/>  * `resource_group_name` - Specifies the name of the resource group the Virtual Network is located in.<br/>  * `id` - The ID of the Subnet.<br/>  * `address_prefixes` - The address prefixes for the subnet.<br/>  * `network_security_group_id` - The ID of the Network Security Group associated with the subnet.<br/>  * `route_table_id` - The ID of the Route Table associated with this subnet.<br/>  * `service_endpoints` - A list of Service Endpoints within this subnet.<br/>  * `default_outbound_access_enabled` - Is the default outbound access enabled for the subnet.<br/>  * `private_endpoint_network_policies` - Enable or Disable network policies for the private endpoint on the subnet.<br/>  * `private_link_service_network_policies_enabled` - Enable or Disable network policies for the private link service on the subnet.<br/><br/>Example output:<pre>output "name" {<br/>  value = module.module_name.subnet.name<br/>}</pre> |

## Modules

No modules.

## 🌐 Additional Information  

This module provides a flexible way to manage Azure subnets, supporting advanced features such as service delegation, service endpoints, and policy attachments. It is designed to be used in both standalone subnet deployments and as part of larger network architectures.

## 📚 Resources

- [Terraform AzureRM Subnet Resource](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet)  
- [Azure Subnet Delegation](https://learn.microsoft.com/en-us/azure/virtual-network/subnet-delegation-overview)  
- [Azure Service Endpoints](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-service-endpoints-overview)  
- [Terraform AzureRM Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)  

## ⚠️ Notes  

- Ensure subnets do not overlap with each other or other VNETs.  
- Validate that required services (e.g., Microsoft.Sql) are available in the selected Azure region before applying service endpoints or delegations.  
- NSG and Route Table associations should be managed outside this module or extended if required.  
- Delegations and policies must align with the subnet’s intended use case (e.g., Azure SQL, App Services, Container Instances, etc.).

## 🧾 License  

This module is released under the **Apache 2.0 License**. See the [LICENSE](./LICENSE) file for full details.
<!-- END OF PRE-COMMIT-OPENTOFU DOCS HOOK -->