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