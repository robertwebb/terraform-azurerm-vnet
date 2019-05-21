output virtualNetworks {
  value = [for resource in azurerm_virtual_network.virtualNetworks : resource.id]
}

output securityGroups {
  value = [for resource in azurerm_network_security_group.securityGroups : resource.id]
}

output storageAccounts {
  value = [for resource in azurerm_storage_account.storageAccounts : resource.id]
}

output loadBalancers {
  value = [for resource in azurerm_lb.loadBalancers : resource.id]
}

output availabilitySets {
  value = [for resource in azurerm_availability_set.availabilitySets : resource.id]
}

output publicIPAddresses {
  value = [for resource in azurerm_public_ip.publicIPAddresses : resource.id]
}

output publicIPAddressesFQDN {
  value = [for resource in azurerm_public_ip.publicIPAddresses : resource.fqdn]
}
