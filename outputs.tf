output virtualNetworks {
  value = [for resource in azurerm_virtual_network.virtualNetworks : resource.id]
}
