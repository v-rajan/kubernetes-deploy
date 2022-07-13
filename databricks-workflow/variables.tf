variable "subscription_id" {
  description = "The subscription to create the deployment with."
  default     = "2e0b8521-9073-4e22-a5b9-dddddddddd"
}

variable "client_id" {
  description = "The client ID of the service account (principal)."
  default     = "e252cac1-6f40-488e-b467-ddddddddd"
}

variable "client_secret" {
  description = "The client secret of the service account (principal)."
}

variable "tenant_id" {
  description = "The ID of the Azure Active Directory Tenant."
  default     = "45f3b82e-a626-457f-8f9c-dddddddddddd"
}

variable "app_name" {
  description = "The Name of the vnet to deploy the service."
  default     = "databricksaim"
}

variable "region" {
  description = "The Name of the vnet to deploy the service."
  default     = "uksouth"
}

variable "environment" {
  description = "The Name of the vnet to deploy the service."
  default     = "development"
}

variable "databricks_prefix" {
  description = "The Name of the vnet to deploy the service."
  default     = "databricksdemobz45v0"
}

variable "BRANCH" {
  description = "The Name of the vnet to deploy the service."
}



