locals {
  name_suffix = "${var.project}-${var.environment}"

  tags = {
    project    = var.project
    env        = var.environment
    managed-by = "terraform"
    repo       = "ecommerce-microservices"
  }
}