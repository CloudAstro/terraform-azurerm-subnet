variable "name" {
  type        = string
  description = <<DESCRIPTION
* `name` - (Required) The name of the subnet. Changing this forces a new resource to be created.

Example Input:
```
name = "snet-aks"
```
DESCRIPTION
}

variable "resource_group_name" {
  type        = string
  description = <<DESCRIPTION
* `resource_group_name` - (Required) The name of the resource group in which to create the subnet. This must be the resource group that the virtual network resides in. Changing this forces a new resource to be created.

Example Input:
```
resource_group_name = "rg-vnet-gwc-hub"
```
DESCRIPTION
}

variable "virtual_network_name" {
  type        = string
  description = <<DESCRIPTION
* `virtual_network_name` - (Required) The name of the virtual network to which to attach the subnet. Changing this forces a new resource to be created.

Example Input:
```
virtual_network_name = "vnet-gwc-hub"
```
DESCRIPTION
}

variable "address_prefixes" {
  type        = list(string)
  description = <<DESCRIPTION
* `address_prefixes` - (Required) The address prefixes to use for the subnet.

-> **NOTE:** Currently only a single address prefix can be set as the [Multiple Subnet Address Prefixes Feature](https://github.com/Azure/azure-cli/issues/18194#issuecomment-880484269) is not yet in public preview or general availability.

Example Input:
```
address_prefixes = ["10.0.1.0/24"]
```
DESCRIPTION
}

variable "default_outbound_access_enabled" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
* `default_outbound_access_enabled` - (Optional) Enable default outbound access to the internet for the subnet. Defaults to `true`.

Example Input:
```
default_outbound_access_enabled = true
```
DESCRIPTION
}

variable "private_endpoint_network_policies" {
  type        = string
  default     = "Disabled"
  description = <<DESCRIPTION
* `private_endpoint_network_policies` - (Optional) Enable or Disable network policies for the private endpoint on the subnet. Possible values are `Disabled`, `Enabled`, `NetworkSecurityGroupEnabled` and `RouteTableEnabled`. Defaults to `Disabled`.

-> **Note:** If you don't want to use network policies like user-defined Routes and Network Security Groups, you need to set `private_endpoint_network_policies` in the subnet to `Disabled`. This setting only applies to Private Endpoints in the Subnet and affects all Private Endpoints in the Subnet. For other resources in the Subnet, access is controlled based via the Network Security Group which can be configured using the `azurerm_subnet_network_security_group_association` resource.
-> **Note:** If you want to use network policies like user-defined Routes and Network Security Groups, you need to set the `private_endpoint_network_policies` in the Subnet to `Enabled`/`NetworkSecurityGroupEnabled`/`RouteTableEnabled`. This setting only applies to Private Endpoints in the Subnet and affects all Private Endpoints in the Subnet. For other resources in the Subnet, access is controlled based via the Network Security Group which can be configured using the `azurerm_subnet_network_security_group_association` resource.
-> **Note:** See more details from [Manage network policies for Private Endpoints](https://learn.microsoft.com/en-gb/azure/private-link/disable-private-endpoint-network-policy?tabs=network-policy-portal).

Example Input:
```
private_endpoint_network_policies = "Disabled"
```
DESCRIPTION
}

variable "private_link_service_network_policies_enabled" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
* `private_link_service_network_policies_enabled` - (Optional) Enable or Disable network policies for the private link service on the subnet. Defaults to `true`.

-> **Note:** When configuring Azure Private Link service, the explicit setting `private_link_service_network_policies_enabled` must be set to `false` in the subnet since Private Link Service does not support network policies like user-defined Routes and Network Security Groups. This setting only affects the Private Link service. For other resources in the subnet, access is controlled based on the Network Security Group which can be configured using the `azurerm_subnet_network_security_group_association` resource. See more details from [Manage network policies for Private Link Services](https://learn.microsoft.com/en-gb/azure/private-link/disable-private-link-service-network-policy?tabs=private-link-network-policy-powershell).

Example Input:
```
private_link_service_network_policies_enabled = true
```
DESCRIPTION
}

variable "service_endpoints" {
  type        = set(string)
  default     = null
  description = <<DESCRIPTION
* `service_endpoints` - (Optional) The list of Service endpoints to associate with the subnet. Possible values include: `Microsoft.AzureActiveDirectory`, `Microsoft.AzureCosmosDB`, `Microsoft.ContainerRegistry`, `Microsoft.EventHub`, `Microsoft.KeyVault`, `Microsoft.ServiceBus`, `Microsoft.Sql`, `Microsoft.Storage`, `Microsoft.Storage.Global` and `Microsoft.Web`.

-> **NOTE:** In order to use `Microsoft.Storage.Global` service endpoint (which allows access to virtual networks in other regions), you must enable the `AllowGlobalTagsForStorage` feature in your subscription. This is currently a preview feature, please see the [official documentation](https://learn.microsoft.com/en-us/azure/storage/common/storage-network-security?tabs=azure-cli#enabling-access-to-virtual-networks-in-other-regions-preview) for more information.

Example Input:
```
service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
```
DESCRIPTION
}

variable "service_endpoint_policy_ids" {
  type        = set(string)
  default     = null
  description = <<DESCRIPTION
* `service_endpoint_policy_ids` - (Optional) The list of IDs of Service Endpoint Policies to associate with the subnet.

Example Input:
```
service_endpoint_policy_ids = {
  snet-name = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-name/providers/Microsoft.Network/serviceEndpointPolicies/test"]
}
```
DESCRIPTION
}

variable "delegation" {
  type = list(object({
    name = string
    service_delegation = object({
      name    = string
      actions = optional(set(string))
    })
  }))
  default     = null
  description = <<DESCRIPTION
* `delegation` - (Optional) One or more `delegation` blocks as defined below.
A `delegation` block supports the following:
  * `name` - (Required) A name for this delegation.
  * `service_delegation` - (Required) A `service_delegation` block as defined below.
A `service_delegation` block supports the following:

-> **Note:** Delegating to services may not be available in all regions. Check that the service you are delegating to is available in your region using the [Azure CLI](https://docs.microsoft.com/cli/azure/network/vnet/subnet?view=azure-cli-latest#az-network-vnet-subnet-list-available-delegations). Also, `actions` is specific to each service type. The exact list of `actions` needs to be retrieved using the aforementioned [Azure CLI](https://docs.microsoft.com/cli/azure/network/vnet/subnet?view=azure-cli-latest#az-network-vnet-subnet-list-available-delegations).
  * `name` - (Required) The name of service to delegate to. Possible values are `GitHub.Network/networkSettings`, `Informatica.DataManagement/organizations`, `Microsoft.ApiManagement/service`, `Microsoft.Apollo/npu`, `Microsoft.App/environments`, `Microsoft.App/testClients`, `Microsoft.AVS/PrivateClouds`, `Microsoft.AzureCosmosDB/clusters`, `Microsoft.BareMetal/AzureHostedService`, `Microsoft.BareMetal/AzureHPC`, `Microsoft.BareMetal/AzurePaymentHSM`, `Microsoft.BareMetal/AzureVMware`, `Microsoft.BareMetal/CrayServers`, `Microsoft.BareMetal/MonitoringServers`, `Microsoft.Batch/batchAccounts`, `Microsoft.CloudTest/hostedpools`, `Microsoft.CloudTest/images`, `Microsoft.CloudTest/pools`, `Microsoft.Codespaces/plans`, `Microsoft.ContainerInstance/containerGroups`, `Microsoft.ContainerService/managedClusters`, `Microsoft.ContainerService/TestClients`, `Microsoft.Databricks/workspaces`, `Microsoft.DBforMySQL/flexibleServers`, `Microsoft.DBforMySQL/servers`, `Microsoft.DBforMySQL/serversv2`, `Microsoft.DBforPostgreSQL/flexibleServers`, `Microsoft.DBforPostgreSQL/serversv2`, `Microsoft.DBforPostgreSQL/singleServers`, `Microsoft.DelegatedNetwork/controller`, `Microsoft.DevCenter/networkConnection`, `Microsoft.DevOpsInfrastructure/pools`, `Microsoft.DocumentDB/cassandraClusters`, `Microsoft.Fidalgo/networkSettings`, `Microsoft.HardwareSecurityModules/dedicatedHSMs`, `Microsoft.Kusto/clusters`, `Microsoft.LabServices/labplans`, `Microsoft.Logic/integrationServiceEnvironments`, `Microsoft.MachineLearningServices/workspaces`, `Microsoft.Netapp/volumes`, `Microsoft.Network/applicationGateways`, `Microsoft.Network/dnsResolvers`, `Microsoft.Network/managedResolvers`, `Microsoft.Network/fpgaNetworkInterfaces`, `Microsoft.Network/networkWatchers.`, `Microsoft.Network/virtualNetworkGateways`, `Microsoft.Orbital/orbitalGateways`, `Microsoft.PowerAutomate/hostedRpa`, `Microsoft.PowerPlatform/enterprisePolicies`, `Microsoft.PowerPlatform/vnetaccesslinks`, `Microsoft.ServiceFabricMesh/networks`, `Microsoft.ServiceNetworking/trafficControllers`, `Microsoft.Singularity/accounts/networks`, `Microsoft.Singularity/accounts/npu`, `Microsoft.Sql/managedInstances`, `Microsoft.Sql/managedInstancesOnebox`, `Microsoft.Sql/managedInstancesStage`, `Microsoft.Sql/managedInstancesTest`, `Microsoft.Sql/servers`, `Microsoft.StoragePool/diskPools`, `Microsoft.StreamAnalytics/streamingJobs`, `Microsoft.Synapse/workspaces`, `Microsoft.Web/hostingEnvironments`, `Microsoft.Web/serverFarms`, `NGINX.NGINXPLUS/nginxDeployments`, `PaloAltoNetworks.Cloudngfw/firewalls`, `Qumulo.Storage/fileSystems`, and `Oracle.Database/networkAttachments`.
  * `actions` - (Optional) A list of Actions which should be delegated. This list is specific to the service to delegate to. Possible values are `Microsoft.Network/networkinterfaces/*`, `Microsoft.Network/publicIPAddresses/join/action`, `Microsoft.Network/publicIPAddresses/read`, `Microsoft.Network/virtualNetworks/read`, `Microsoft.Network/virtualNetworks/subnets/action`, `Microsoft.Network/virtualNetworks/subnets/join/action`, `Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action`, and `Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action`.

  -> **Note:** Azure may add default actions depending on the service delegation name and they can't be changed.

Example Input:
```
delegation = [{
  name = "delegation"
  service_delegation = {
    name    = "Microsoft.ContainerInstance/containerGroups"
    actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
  }
}]
```
DESCRIPTION
}

variable "timeouts" {
  type = object({
    create = optional(string, "30")
    update = optional(string, "30")
    read   = optional(string, "5")
    delete = optional(string, "30")
  })
  default     = null
  description = <<DESCRIPTION
The `timeouts` block allows you to specify [timeouts](https://www.terraform.io/language/resources/syntax#operation-timeouts) for certain actions:
  * `create` - (Defaults to 30 minutes) Used when creating the Subnet.
  * `update` - (Defaults to 30 minutes) Used when updating the Subnet.
  * `read` - (Defaults to 5 minutes) Used when retrieving the Subnet.
  * `delete` - (Defaults to 30 minutes) Used when deleting the Subnet.
DESCRIPTION
}
