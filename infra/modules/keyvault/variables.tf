variable "name_suffix" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "soft_delete_retention_days" {
  description = "Delete chesina tarvata recover cheyyagalige rojulu"
  type        = number
  default     = 7
}

variable "purge_protection_enabled" {
  description = "Prod lo true. Nonprod lo false (destroy/apply easy ga)"
  type        = bool
  default     = false
}

variable "admin_principal_ids" {
  description = "Key Vault Administrator role ivvalsina users/identities"
  type        = list(string)
}

variable "log_analytics_workspace_id" {
  description = "Audit logs pampadaniki"
  type        = string
}

variable "tags" {
  type = map(string)
}