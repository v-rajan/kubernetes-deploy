variable "subscription_id" {
	description = "The subscription to create the deployment with."
	default = ""
}

variable "client_id" {
	description = "The client ID of the service account (principal)."
	default = ""
}

variable "client_secret" {
	description = "The client secret of the service account (principal)."
}

variable "tenant_id" {
	description = "The ID of the Azure Active Directory Tenant."
	default = ""
}

variable "app_name" {
	description = "The Name of the vnet to deploy the service."
	default = "databricksaim"
}

variable "region" {
	description = "The Name of the vnet to deploy the service."
	default     = "uksouth"
}

variable "environment" {
	description = "The Name of the vnet to deploy the service."
	default = "development"
}

variable "vm_size" {
	description = "Specifies the size of the virtual machine."
	default     = "Standard_D2ds_v5"
}

variable "image_publisher" {
	description = "name of the publisher of the image (az vm image list)"
	default     = "RedHat"
}

variable "image_offer" {
	description = "the name of the offer (az vm image list)"
	default     = "RHEL"
}

variable "image_sku" {
	description = "image sku to apply (az vm image list)"
	default     = "7-LVM"
}

variable "image_version" {
	description = "version of the image to apply (az vm image list)"
	default     = "latest"
}

variable "username" {
	description = "administrator user name"
	default     = "user001"
}

variable "password" {
	description = "administrator password (recommended to disable password auth)"
	default		= "Xcdnoo1234!"
}

variable "public_key_path" {
	description = "Path to your SSH Public Key"
	default = "/home/rajan/.ssh/id_rsa.pub"
}