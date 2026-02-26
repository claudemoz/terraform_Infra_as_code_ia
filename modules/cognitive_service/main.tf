resource "azurerm_cognitive_account" "cog" {
  name                = "cog-${var.project}-${var.env}"
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "ComputerVision"
  sku_name            = var.sku

  # Network rules (optionnel)
  # public_network_access_enabled = true

  tags = var.tags
}