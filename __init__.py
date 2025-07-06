import logging
import datetime
import gzip
import json
import os

import azure.functions as func
from azure.cosmos import CosmosClient
from azure.storage.blob import BlobServiceClient

def main(mytimer: func.TimerRequest) -> None:
    logging.info("Billing archival function started.")

    # Env vars from app settings
    cosmos_uri = os.environ["COSMOS_DB_URI"]
    cosmos_key = os.environ["COSMOS_DB_KEY"]
    blob_conn_str = os.environ["BLOB_STORAGE_CONN_STRING"]
    container_name = os.environ["BLOB_CONTAINER_NAME"]

    cosmos_client = CosmosClient(cosmos_uri, cosmos_key)
    database = cosmos_client.get_database_client("billingdb")
    container = database.get_container_client("BillingRecords")

    blob_service_client = BlobServiceClient.from_connection_string(blob_conn_str)
    blob_container = blob_service_client.get_container_client(container_name)

    cutoff = (datetime.datetime.utcnow() - datetime.timedelta(days=90)).isoformat()

    query = f"SELECT * FROM c WHERE c.timestamp < '{cutoff}'"
    items = list(container.query_items(query=query, enable_cross_partition_query=True))

    for item in items:
        try:
            record_date = datetime.datetime.fromisoformat(item["timestamp"])
            blob_path = f"{record_date.year}/{record_date.month:02}/{record_date.day:02}/record_{item['id']}.json.gz"

            # Serialize + compress
            blob_data = gzip.compress(json.dumps(item).encode("utf-8"))

            # Upload
            blob_container.upload_blob(blob_path, blob_data, overwrite=True)
            container.delete_item(item=item["id"], partition_key=item["partitionKey"])

            logging.info(f"Archived and removed record {item['id']}")
        except Exception as e:
            logging.error(f"Error processing record {item.get('id', 'unknown')}: {e}")

    logging.info("Billing archival function completed.")
