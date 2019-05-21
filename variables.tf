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
