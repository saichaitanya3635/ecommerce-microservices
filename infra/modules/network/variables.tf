variable "name_suffix" {
  description = "Naming suffix, e.g. ecom-nonprod"
  type        = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "address_space" {
  description = "VNet address range"
  type        = list(string)
}

variable "subnet_prefixes" {
  description = "Subnet address ranges"
  type = object({
    aks               = string
    postgres          = string
    private_endpoints = string
  })
}

variable "tags" {
  type = map(string)
}