resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.project}-${var.env}"
  location = var.location

  tags = local.tags
}

locals {
  tags = {
    env     = var.env
    project = var.project
    owner   = "claude"
  }
}

module "network" {
  source              = "./modules/network"
  project             = var.project
  env                 = var.env
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
}

module "compute" {
  source              = "./modules/compute"
  project             = var.project
  env                 = var.env
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  nic_id              = module.network.nic_id
  admin_username      = var.admin_username
  ssh_public_key_path = var.ssh_public_key_path
  tags                = local.tags
}

module "storage" {
  source              = "./modules/storage"
  project             = var.project
  env                 = var.env
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  container_name      = "data"
  tags                = local.tags
}

module "monitoring" {
  source              = "./modules/monitoring"
  project             = var.project
  env                 = var.env
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
}

module "cognitive" {
  source              = "./modules/cognitive_service"
  project             = var.project
  env                 = var.env
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "S1"
  tags                = local.tags
}

module "function" {
  source              = "./modules/function_app"
  project             = var.project
  env                 = var.env
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags

  storage_account_name       = module.storage.storage_account_name
  storage_account_access_key = module.storage.primary_access_key

  vision_endpoint  = module.cognitive.cognitive_service_endpoint
  vision_key      = module.cognitive.cognitive_service_key
}

module "keyvault" {
  source              = "./modules/key_vault"
  project             = var.project
  env                 = var.env
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
}