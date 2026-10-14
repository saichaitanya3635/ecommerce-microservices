variable "name_suffix" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "sku" {
  description = "Basic (cheap) / Standard / Premium"
  type        = string
  default     = "Basic"
}

variable "tags" {
  type = map(string)
}