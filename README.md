A.Proposal for this Project :

1.Active Tier (Hot): Recent billing records (<= 3 months) stay in Azure Cosmos DB.
2.Archive Tier (Cold): Older records (> 3 months) are moved to Azure Blob Storage (Cool or Archive tier) in a serialized format (e.g., JSON or Avro).
3.Read API Proxy Layer: On record retrieval, query Cosmos DB first. If not found, fallback to blob storage and serve from there (with slight delay allowed).
4.Background Archival Function: An Azure Function with Timer trigger moves old data daily to Blob Storage and deletes from Cosmos DB.


B. Architecture Diagram

         +-----------------------+
         |     Client/API       |
         +----------+-----------+
                    |
             +------v-------+
             |  Billing API |
             +------+-------+
                    |
        +-----------v-----------+
        |  Cosmos DB (Active)   |
        +-----------+-----------+
                    |
     +--------------v--------------+
     |   Azure Function (Archival) |
     +--------------+--------------+
                    |
        +-----------v-----------+
        | Azure Blob Storage    |
        |  (Cool/Archive Tier)  |
        +-----------------------+

- Read Path: API → Cosmos → [Fallback → Blob]
- Write Path: API → Cosmos
- Archival: Azure Function moves older data from Cosmos → Blob

Architecture Components:
1. Cosmos DB (Hot Data)
2. Azure Blob Storage (Cold Data)
3. Azure Function App for archival and read-through logic
4. Timer-triggered Azure Function to move data >3 months


C. Key Benefits

1.Cost Optimization: Cosmos DB usage is drastically reduced.

2.No API Change: Backend logic handles retrieval from archive seamlessly.

3.No Downtime: Migration is backgrounded.

4.Simplicity: Easy to deploy via Terraform.