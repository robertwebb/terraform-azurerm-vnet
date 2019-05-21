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
