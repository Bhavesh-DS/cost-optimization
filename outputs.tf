output "cosmos_db_uri" {
  value = azurerm_cosmosdb_account.cosmos.endpoint
}

output "storage_container_url" {
  value = azurerm_storage_account.storage.primary_blob_endpoint
}
