variable "project" {
  description = "Project short name"
  type        = string
}

variable "environment" {
  description = "Environment name (nonprod / prod)"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "centralindia"
}

variable "kv_admin_object_ids" {
  description = "Key Vault admins (Entra object IDs)"
  type        = list(string)
}