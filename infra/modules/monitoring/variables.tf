variable "name_suffix" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "retention_in_days" {
  description = "Logs entha rojulu store cheyyali"
  type        = number
  default     = 30
}

variable "daily_quota_gb" {
  description = "Rojuki maximum logs (GB). Cost control kosam"
  type        = number
  default     = 0.5
}

variable "tags" {
  type = map(string)
}