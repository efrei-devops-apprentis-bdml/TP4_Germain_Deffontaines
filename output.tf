#nom du ressource group
output "resource_group_name" {
  value = data.azurerm_resource_group.tp4.name
}

#adresse ip publique
output "public_ip_address" {
  value = azurerm_linux_virtual_machine.devops-20180604.public_ip_address
}

#clef privée
output "tls_private_key" {
  value     = tls_private_key.tp4-prkey.private_key_pem
  sensitive = true
}