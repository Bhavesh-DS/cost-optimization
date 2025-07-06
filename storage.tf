resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  access_tier              = "Cool"
}

resource "azurerm_storage_container" "archive" {
  name                  = "billing-archive"
  storage_account_id= azurerm_storage_account.storage.name
  container_access_type = "private"
}
