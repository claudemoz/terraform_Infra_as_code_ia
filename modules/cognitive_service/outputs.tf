output "cognitive_service_id" {
  value = azurerm_cognitive_account.cog.id
}

output "cognitive_service_name" {
  value = azurerm_cognitive_account.cog.name
}

output "cognitive_service_endpoint" {
  value = azurerm_cognitive_account.cog.endpoint
}

output "cognitive_service_key" {
  value     = azurerm_cognitive_account.cog.primary_access_key
  sensitive = true
}