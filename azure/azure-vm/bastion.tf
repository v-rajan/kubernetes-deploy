
#
# Bastion Load Balancer
#

# Uncomment for load balancer or VM public IP ####################################

# Public IP
#resource "azurerm_public_ip" "bastion_pip" {
#  name                = "${data.azurerm_resource_group.rg.name}-bastion-pip"
#  resource_group_name = data.azurerm_resource_group.rg.name
#  location            = data.azurerm_resource_group.rg.location
#  sku                 = "Standard"
#  allocation_method   = "Static"
#  domain_name_label   = "${data.azurerm_resource_group.rg.name}-bastion"
#}

# Uncomment for load balancer or VM public IP ####################################

# Uncomment for load balancer  public IP ####################################

# Loadbalancing NAT rule
#resource "azurerm_lb_nat_rule" "natrule-01" {
#  resource_group_name            = data.azurerm_resource_group.rg.name
#  loadbalancer_id                = azurerm_lb.alb-01.id
#  name                           = "AllowSshInBound"
#  protocol                       = "Tcp"
#  frontend_port                  = 22
#  backend_port                   = 22
#  frontend_ip_configuration_name = "${data.azurerm_resource_group.rg.name}-bastion-alb-feip-config"
#}

# Associate network Interface and nat rule
#resource "azurerm_network_interface_nat_rule_association" "assnatrule-01" {
#  count                   = 1
#  network_interface_id    = element(azurerm_network_interface.bastion_nic.*.id, count.index)
#  ip_configuration_name   = "${data.azurerm_resource_group.rg.name}-bastion-ipconfig"
#  nat_rule_id           = azurerm_lb_nat_rule.natrule-01.id
#}

# Uncomment for load balancer  public IP ####################################

# Uncomment for load balancer private IP ####################################

# Loadbalancing rule
resource "azurerm_lb_rule" "albrule-01" {
  name                           = "AllowSshInBound"
  resource_group_name            = data.azurerm_resource_group.rg.name
  probe_id                       = azurerm_lb_probe.albp-01.id
  protocol                       = "tcp"
  backend_port                   = 22
  frontend_port                  = 22
  idle_timeout_in_minutes        = 15
  frontend_ip_configuration_name = "${data.azurerm_resource_group.rg.name}-bastion-alb-feip-config"
  loadbalancer_id                = azurerm_lb.alb-01.id
}

# Uncomment for load balancer private IP ####################################

# Load Balancer
resource "azurerm_lb" "alb-01" {
  name                = "${data.azurerm_resource_group.rg.name}-bastion-alb"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku                 = "standard"
  frontend_ip_configuration {
    name = "${data.azurerm_resource_group.rg.name}-bastion-alb-feip-config"
    # Private IP
    subnet_id = data.azurerm_subnet.subnet.id
    private_ip_address            = "10.254.0.6"
    private_ip_address_allocation = "Static"
    # Public IP
    # public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }
}

# Backend address pool
resource "azurerm_lb_backend_address_pool" "abp-01" {
  name            = "${data.azurerm_resource_group.rg.name}-bastion-abp"
  loadbalancer_id = azurerm_lb.alb-01.id
}

# Associate network Interface and backend address pool
resource "azurerm_network_interface_backend_address_pool_association" "assbp-01" {
  count                   = 1
  network_interface_id    = element(azurerm_network_interface.bastion_nic.*.id, count.index)
  ip_configuration_name   = "${data.azurerm_resource_group.rg.name}-bastion-ipconfig"
  backend_address_pool_id = azurerm_lb_backend_address_pool.abp-01.id
}

# Probe
resource "azurerm_lb_probe" "albp-01" {
  name                = "${data.azurerm_resource_group.rg.name}-bastion-lbprobe"
  resource_group_name = data.azurerm_resource_group.rg.name
  port                = 22
  protocol            = "tcp"
  interval_in_seconds = 15
  number_of_probes    = 2
  loadbalancer_id     = azurerm_lb.alb-01.id
}

#
# Bastion Host
#
resource "azurerm_network_interface" "bastion_nic" {
  name                = "${data.azurerm_resource_group.rg.name}-bastion-nic"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "${data.azurerm_resource_group.rg.name}-bastion-ipconfig"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    # Uncomment for Public IP
    # public_ip_address_id          = azurerm_public_ip.bastion_pip.id
  }
}

resource "azurerm_network_security_rule" "bastion_nsr" {
  name                        = "AllowSshInBound"
  priority                    = 400
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.infra-rg.name
  network_security_group_name = data.azurerm_network_security_group.nsg.name
}

resource "azurerm_virtual_machine" "bastion" {
  name                             = "${data.azurerm_resource_group.rg.name}-bastion"
  location                         = data.azurerm_resource_group.rg.location
  resource_group_name              = data.azurerm_resource_group.rg.name
  vm_size                          = var.vm_size
  network_interface_ids            = ["${azurerm_network_interface.bastion_nic.id}"]
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  os_profile {
    computer_name  = "${var.app_name}-bastion"
    admin_username = var.username
    admin_password = var.password
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/${var.username}/.ssh/authorized_keys"
      key_data = file(var.public_key_path)
    }
  }
  storage_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  storage_os_disk {
    name              = "${var.app_name}-bastion-osdisk"
    managed_disk_type = "Standard_LRS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
  }
}
