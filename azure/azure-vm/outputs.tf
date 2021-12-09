output "Bastion_SSH" {
  # Public IP
  # value = "ssh ${var.username}@${azurerm_public_ip.bastion_pip.fqdn}"
  # Private IP
  value = "ssh ${var.username}@${azurerm_lb.alb-01.private_ip_address}"
}
