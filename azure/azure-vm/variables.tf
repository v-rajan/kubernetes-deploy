variable "subscription_id" {
	description = "The subscription to create the deployment with."
	default = "0e2b0407-908c-4b9c-a39d-6649ba5d41a5"
}

variable "client_id" {
	description = "The client ID of the service account (principal)."
	default = "48841e4f-aedf-47bc-894f-8b012ec872c3"
}

variable "client_secret" {
	description = "The client secret of the service account (principal)."
}

variable "tenant_id" {
	description = "The ID of the Azure Active Directory Tenant."
	default = "bb9c2814-bbcb-4677-a93a-ac68c43484b7"
}

variable "resource_group" {
	description = "The name of the resource group in which to create the virtual network."
	default = "scb001"
}

variable "hostname" {
	description = "VM name referenced also in storage-related names."
	default = "scb001-bastion"
}


variable "location" {
	description = "The location/region where the virtual network is created. Changing this forces a new resource to be created."
	default     = "eastus"
}

variable "virtual_network_name" {
	description = "The name for the virtual network."
	default     = "vnet"
}

variable "vm_size" {
	description = "Specifies the size of the virtual machine."
	default     = "Standard_A1_v2"
}

variable "image_publisher" {
	description = "name of the publisher of the image (az vm image list)"
	default     = "Canonical"
}

variable "image_offer" {
	description = "the name of the offer (az vm image list)"
	default     = "UbuntuServer"
}

variable "image_sku" {
	description = "image sku to apply (az vm image list)"
	default     = "16.04-LTS"
}

variable "image_version" {
	description = "version of the image to apply (az vm image list)"
	default     = "latest"
}

variable "username" {
	description = "administrator user name"
	default     = "ubuntu"
}

variable "password" {
	description = "administrator password (recommended to disable password auth)"
	default		= "C0c0nut1234!"
}

variable "private_key_path" {
	description = "Path to the private ssh key used to connect to the machine within the gateway."
	default = "/home/rajan/.ssh/id_rsa"
}

variable "public_key_path" {
	description = "Path to your SSH Public Key"
	default = "/home/rajan/.ssh/id_rsa.pub"
}