data "azurerm_resource_group" "rg" {
  name = "${var.app_name}-${var.region}-rg"
}

data "azurerm_resource_group" "infra-rg" {
  name = "infra-${var.region}-rg"
}

data "azurerm_virtual_network" "vnet" {
  name                = "${var.app_name}-${var.environment}-${var.region}-vnet"
  resource_group_name = data.azurerm_resource_group.infra-rg.name
}

data "azurerm_subnet" "subnet" {
  name                 = "${var.app_name}-${var.environment}-${var.region}-subnet-2-1"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.infra-rg.name
}

data "azurerm_network_security_group" "nsg" {
  name                = "${var.app_name}-${var.environment}-${var.region}-tier-2-nsg"
  resource_group_name = data.azurerm_resource_group.infra-rg.name
}
