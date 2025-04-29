output "subnet" {
  value       = azurerm_subnet.subnet
  description = <<DESCRIPTION
  - `name` - Specifies the name of the Subnet.
  - `virtual_network_name` - Specifies the name of the Virtual Network this Subnet is located within.
  - `resource_group_name` - Specifies the name of the resource group the Virtual Network is located in.
  - `id` - The ID of the Subnet.
  - `address_prefixes` - The address prefixes for the subnet.
  - `network_security_group_id` - The ID of the Network Security Group associated with the subnet.
  - `route_table_id` - The ID of the Route Table associated with this subnet.
  - `service_endpoints` - A list of Service Endpoints within this subnet.
  - `default_outbound_access_enabled` - Is the default outbound access enabled for the subnet.
  - `private_endpoint_network_policies` - Enable or Disable network policies for the private endpoint on the subnet.
  - `private_link_service_network_policies_enabled` - Enable or Disable network policies for the private link service on the subnet.

Example output:
```
output "name" {
  value = module.module_name.subnet.name
}
```
DESCRIPTION
}
