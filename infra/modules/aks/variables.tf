variable "name_suffix" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "subnet_id" {
  description = "Nodes ee subnet lo untayi (snet-aks)"
  type        = string
}

variable "log_analytics_workspace_id" {
  type = string
}

variable "attach_acr" {
  description = "ACR nunchi images pull permission ivvala"
  type        = bool
  default     = true
}

variable "acr_id" {
  type    = string
  default = null
}

variable "admin_object_ids" {
  description = "kubectl full access ichhe users"
  type        = list(string)
}

variable "kubernetes_version" {
  description = "null = AKS default version"
  type        = string
  default     = null
}

variable "system_vm_size" {
  type    = string
  default = "Standard_B2s"
}

variable "apps_vm_size" {
  type    = string
  default = "Standard_B2ms"
}

variable "apps_node_count" {
  type    = number
  default = 1
}

variable "tags" {
  type = map(string)
}