output "Bastion_SSH" {
  value = "ssh ${var.username}@${azurerm_public_ip.bastion_pip.fqdn}"
}
