provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group
  location = var.location
}

module "cosmos" {
  source = "./cosmos"
}

module "storage" {
  source = "./storage"
}

module "function_app" {
  source = "./function_app"
}
