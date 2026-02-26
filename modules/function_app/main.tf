resource "azurerm_storage_account" "func_storage" {
  name                     = lower(replace("stfunc${var.project}${var.env}", "-", ""))
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags
}

resource "azurerm_service_plan" "plan" {
  name                = "asp-${var.project}-${var.env}"
  location            = var.location
  resource_group_name = var.resource_group_name

  os_type  = "Linux"   # obligatoire
  sku_name = "B1"      # Basic Linux (compatible toutes régions)

  tags = var.tags
}

resource "azurerm_function_app" "func" {
  name                       = "func-${var.project}-${var.env}"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  app_service_plan_id        = azurerm_service_plan.plan.id
  storage_account_name       = var.storage_account_name
  storage_account_access_key = azurerm_storage_account.func_storage.primary_access_key
  version                    = "~4"

   app_settings = {
    "VISION_ENDPOINT" = var.vision_endpoint
    "VISION_KEY"      = var.vision_key
    "AzureWebJobsStorage" = var.storage_account_access_key
    "FUNCTIONS_WORKER_RUNTIME" = "python"
  }

  identity {
    type = "SystemAssigned"
  }

  depends_on = [
    azurerm_service_plan.plan,
    azurerm_storage_account.func_storage
  ]
  tags = var.tags
}