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

# ---------- Cost switches ----------
variable "enable_acr" {
  description = "ACR create cheyyala"
  type        = bool
  default     = false
}

variable "enable_aks" {
  description = "AKS create cheyyala (costly!)"
  type        = bool
  default     = false
}

variable "enable_postgres" {
  description = "PostgreSQL create cheyyala (costly!)"
  type        = bool
  default     = false
}