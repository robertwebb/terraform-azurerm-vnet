#============================================================
# Terraform and AzureRm required versions
#============================================================
terraform {
  required_version = ">= 0.12.0"

  required_providers {
    azurerm = ">= 1.27.0"
  }
}

provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  #version = "=1.27.1"
}
#============================================================
# Pick up the Azure subscription info
#============================================================
data azurerm_subscription current {}

#============================================================
# Create a resource group
#============================================================
resource "azurerm_resource_group" "vnet-rg" {
  name     = var.resourceGroupName
  location = var.location
  tags     = var.resourceTags
}

#============================================================
# Create one or more Virtual Networks
#============================================================
resource azurerm_virtual_network virtualNetworks {
  count               = length(var.virtualNetworks)
  resource_group_name = azurerm_resource_group.vnet-rg.name
  location            = azurerm_resource_group.vnet-rg.location
  name                = var.virtualNetworks[count.index].name
  address_space       = var.virtualNetworks[count.index].address_space
  tags                = var.resourceTags
  dynamic "subnet" {
    for_each = [
      for s in var.virtualNetworks[count.index].subnets : {
        name   = s.subnet_name
        prefix = s.subnet_prefix
      }
    ]

    content {
      name           = subnet.value.name
      address_prefix = subnet.value.prefix
    }
  }
}

#============================================================
# Create one or more Network Security Groups
#============================================================
resource azurerm_network_security_group securityGroups {
  count               = length(var.networkSecurityGroups)
  resource_group_name = azurerm_resource_group.vnet-rg.name
  location            = azurerm_resource_group.vnet-rg.location
  name                = var.networkSecurityGroups[count.index].name
  tags                = var.resourceTags
  security_rule       = var.networkSecurityGroups[count.index].securityRules
}

#============================================================
# Create one or more Storage Accounts
#============================================================
resource azurerm_storage_account storageAccounts {
  count                    = length(var.storageAccounts)
  resource_group_name      = azurerm_resource_group.vnet-rg.name
  location                 = azurerm_resource_group.vnet-rg.location
  tags                     = var.resourceTags
  name                     = var.storageAccounts[count.index].storageAccountName
  account_tier             = var.storageAccounts[count.index].storageAccountTier
  account_replication_type = var.storageAccounts[count.index].storageAccountReplication
  account_kind             = var.storageAccounts[count.index].storageAccountKind
  access_tier              = var.storageAccounts[count.index].accessTier
}

#============================================================
# Create one or more Load Balancers
#============================================================
resource azurerm_lb loadBalancers {
  count               = length(var.loadBalancers)
  resource_group_name = azurerm_resource_group.vnet-rg.name
  location            = azurerm_resource_group.vnet-rg.location
  tags                = var.resourceTags
  name                = var.loadBalancers[count.index].name
  frontend_ip_configuration {
    name                          = "LoadBalancerFrontEnd"
    private_ip_address_allocation = var.loadBalancers[count.index].privateIPAllocationMethod
    private_ip_address            = var.loadBalancers[count.index].privateIPAddress
    subnet_id                     = format("%s/resourceGroups/%s/providers/Microsoft.Network/virtualNetworks/%s/subnets/%s", data.azurerm_subscription.current.id, var.loadBalancers[count.index].vnetResourceGroupName, var.loadBalancers[count.index].vnetName, var.loadBalancers[count.index].subnetName)
  }
}

#============================================================
# Create one or more Load Balancers
#============================================================
resource "azurerm_availability_set" "availabilitySets" {
  count                        = length(var.availabilitySets)
  resource_group_name          = azurerm_resource_group.vnet-rg.name
  location                     = azurerm_resource_group.vnet-rg.location
  tags                         = var.resourceTags
  name                         = var.availabilitySets[count.index].name
  platform_fault_domain_count  = var.availabilitySets[count.index].faultDomainCount
  platform_update_domain_count = var.availabilitySets[count.index].updateDomainCount
  managed                      = var.availabilitySets[count.index].useManagedDisks
}

#============================================================
# Create one or more Public IP Addresses
#============================================================
resource "azurerm_public_ip" "publicIPAddresses" {
  count                        = length(var.publicIPAddresses)
  resource_group_name          = azurerm_resource_group.vnet-rg.name
  location                     = azurerm_resource_group.vnet-rg.location
  tags                         = var.resourceTags
  name                         = var.publicIPAddresses[count.index].name
  public_ip_address_allocation = var.publicIPAddresses[count.index].allocationMethod
  domain_name_label            = var.publicIPAddresses[count.index].domainNameLabel
  sku                          = var.publicIPAddresses[count.index].sku
}

#============================================================
# Create one or more Network Interfaces
#============================================================
resource "azurerm_network_interface" "networkInterfaces" {
  count                         = length(var.networkInterfaces)
  resource_group_name           = azurerm_resource_group.vnet-rg.name
  location                      = azurerm_resource_group.vnet-rg.location
  tags                          = var.resourceTags
  name                          = var.networkInterfaces[count.index].name
  enable_accelerated_networking = var.networkInterfaces[count.index].enableAcceleratedNetworking
  ip_configuration {
    name                          = "ipconfig1"
    private_ip_address_allocation = var.networkInterfaces[count.index].privateIPAllocationMethod
    private_ip_address            = var.networkInterfaces[count.index].privateIpAddress
    public_ip_address_id          = var.networkInterfaces[count.index].publicIPAddress
    subnet_id                     = format("%s/resourceGroups/%s/providers/Microsoft.Network/virtualNetworks/%s/subnets/%s", data.azurerm_subscription.current.id, var.networkInterfaces[count.index].vnetResourceGroupName, var.networkInterfaces[count.index].vnetName, var.networkInterfaces[count.index].subnetName)
  }
}

#============================================================
# Create one or more Virtual Machines
#============================================================
# resource "azurerm_virtual_machine" "virtualmachines" {
#   count               = length(var.virtualmachines)
#   resource_group_name = azurerm_resource_group.vnet-rg.name
#   location            = azurerm_resource_group.vnet-rg.location
#   tags                = var.resourceTags
#   name                = var.virtualmachines[count.index].name

#   network_interface_ids = ["${azurerm_network_interface.main.id}"]
#   vm_size               =  var.virtualmachines[count.index].vmSize

#   # Uncomment this line to delete the OS disk automatically when deleting the VM
#   delete_os_disk_on_termination = true

#   # Uncomment this line to delete the data disks automatically when deleting the VM
#   delete_data_disks_on_termination = true

# }
