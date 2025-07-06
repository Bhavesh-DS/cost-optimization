resource "azurerm_service_plan" "plan" {
  name                = "function-consumption-plan"
  location            = var.location
  resource_group_name = var.resource_group
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "function" {
  name                = var.function_app_name
  location            = var.location
  resource_group_name = var.resource_group
  service_plan_id     = azurerm_service_plan.plan.id
  functions_extension_version = "~4"

  storage_account_name       = azurerm_storage_account.storage.name
  storage_account_access_key = azurerm_storage_account.storage.primary_access_key

  site_config {
    application_stack {
      python_version = "3.11"
    }
  }

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME"      = "python"
    "AzureWebJobsStorage"           = azurerm_storage_account.storage.primary_connection_string
    "COSMOS_DB_URI"                 = azurerm_cosmosdb_account.cosmos.endpoint
    "COSMOS_DB_KEY"                 = azurerm_cosmosdb_account.cosmos.primary_key
    "BLOB_STORAGE_CONN_STRING"      = azurerm_storage_account.storage.primary_connection_string
    "BLOB_CONTAINER_NAME"           = azurerm_storage_container.archive.name
  }
}
