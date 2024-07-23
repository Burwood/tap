# BigQuery Tap Server


## BigQuery Connection

The (Simba JDBC Driver)[https://cloud.google.com/bigquery/docs/reference/odbc-jdbc-drivers#current_jdbc_driver].   Using the JDBC ADO the tap-user is used for queries to BigQuery.  The JDBC configuration is specified [here in context.xml](../src/main/webapp/META-INF/context.xml).  GKE Workload Identity was used and the JDBC configuration specifies using the built-in GCP service account.  The configuration was also tested with using a service account file and updating the JDBC configuration to reference a service account file.

## Authentication
All connections are set to anonymous with overriding of authentication.  The local authority map file LocalAuthority.properties was added for authentication and authorization.

## ResultStore


## Converstions
The conversions are done mainly in the parser folder.  

Since BigQuery uses meters as unit of distance the code is converting any distance from degrees to meters before constructing and sending the BigQuery query.
