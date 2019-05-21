variable "resourceGroupName" {
  type        = "string"
  description = "Virtual Network resource group"
}

variable "location" {
  type        = "string"
  description = "location for the virtual network"
}

variable "resourceTags" {
  type        = "map"
  description = "Resource tags"
  default     = {}
}

variable "virtualNetworks" {
  description = "Array of Virtual Network objects"
  type = list(object(
    {
      name          = string
      address_space = list(string)
      subnets = list(object(
        {
          subnet_name   = string
          subnet_prefix = string
        }
      ))
    }
  ))
}

variable "networkSecurityGroups" {
  description = "Array of Network Security Group objects"
  type = list(object(
    {
      name = string
      securityRules = list(object(
        {
          name                                       = string
          protocol                                   = string
          source_port_range                          = string
          source_port_ranges                         = list(string)
          source_address_prefix                      = string
          source_address_prefixes                    = list(string)
          source_application_security_group_ids      = list(string)
          destination_port_range                     = string
          destination_port_ranges                    = list(string)
          destination_address_prefix                 = string
          destination_address_prefixes               = list(string)
          destination_application_security_group_ids = list(string)
          access                                     = string
          priority                                   = string
          direction                                  = string
          description                                = string
        }
      ))
    }
  ))
}

variable "storageAccounts" {
  description = "Array of Storage Account objects"
  type = list(object(
    {
      storageAccountName        = string
      storageAccountTier        = string
      storageAccountReplication = string
      storageAccountKind        = string
      accessTier                = string
    }
  ))
}

variable "loadBalancers" {
  description = "Array of Load Balancer objects"
  type = list(object(
    {
      name                      = string
      privateIPAllocationMethod = string
      privateIPAddress          = string
      vnetResourceGroupName     = string
      vnetName                  = string
      subnetName                = string
    }
  ))
}

variable "availabilitySets" {
  description = "Array of Availability Set objects"
  type = list(object(
    {
      name              = string
      faultDomainCount  = number
      updateDomainCount = number
      useManagedDisks   = bool
    }
  ))
}

variable "publicIPAddresses" {
  description = "Array of Public IP Address objects"
  type = list(object(
    {
      name             = string
      allocationMethod = string
      domainNameLabel  = string
      sku              = string
    }
  ))
}

variable "networkInterfaces" {
  description = "Array of Network Interface objects"
  type = list(object(
    {
      name                        = string
      enableAcceleratedNetworking = bool
      privateIPAllocationMethod   = string
      privateIpAddress            = string
      publicIPAddress             = string
      vnetResourceGroupName       = string
      vnetName                    = string
      subnetName                  = string
    }
  ))
}

