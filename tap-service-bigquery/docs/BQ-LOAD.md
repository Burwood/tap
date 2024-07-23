
# Creation of Tap Schemas Tables
Instructions below on how to create the tap schema tables and load data.

## Create dataset

To create a dataset run `bq --location=US mk --dataset tap_schema`

## Make Tables
Run below to make tables.  Commands below assume you are running from [tap-service-bigquery folder](tap-service-bigquery)

```
bq mk --table tap_schema.KeyValue ./install/tap-schema/key_value.json
bq mk --table tap_schema.Modelversion ./install/tap-schema/model_version.json
bq mk --table tap_schema.columns11 ./install/tap-schema/columns11.json
bq mk --table tap_schema.key_columns11 ./install/tap-schema/key_columns11.json
bq mk --table tap_schema.keys11 ./install/tap-schema/keys11.json # error
bq mk --table tap_schema.schemas11 ./install/tap-schema/schemas11.json
bq mk --table tap_schema.tables11 ./install/tap-schema/tables11.json
```

## Load Data for Schemas
Run below to load schema data into Cloud Storage then BigQuery.  Please note data must be staged in GCS bucket.

Load data into Cloud Storage.

```
gsutil tap-schema-data/*.csv gs://tap-staging
```


Load data into BigQuery.

```
bq load --noreplace --source_format=CSV --skip_leading_rows=1 tap_schema.tables11 gs://tap-staging/public-data/tables11.csv
bq load --noreplace --source_format=CSV --skip_leading_rows=1 tap_schema.schemas11 gs://tap-staging/public-data/schemas11.csv
bq load --noreplace --source_format=CSV --skip_leading_rows=1 tap_schema.columns11 gs://tap-staging/public-data/columns11.csv
bq load --noreplace --source_format=CSV --skip_leading_rows=1 tap_schema.key_columns11 gs://tap-staging/public-data/key_columns11.csv
bq load --noreplace --source_format=CSV --skip_leading_rows=1 tap_schema.keys11 gs://tap-staging/public-data/keys11.csv
```

## Export current schema

Reference below to export current schema

```
bq show --format=prettyjson cloud-native-hpc:tap_schema.KeyValue | jq '.schema.fields' > tap.schema.key.value.json
bq show --format=prettyjson cloud-native-hpc:tap_schema.Modelversion | jq '.schema.fields' > tap.schema.model.version.json
bq show --format=prettyjson cloud-native-hpc:tap_schema.columns11 | jq '.schema.fields' > tap.schema.columns11.json
bq show --format=prettyjson cloud-native-hpc:tap_schema.key_columns11 | jq '.schema.fields' > tap.schema.key_columns11.json
bq show --format=prettyjson cloud-native-hpc:tap_schema.key_11 | jq '.schema.fields' > keys11.json
bq show --format=prettyjson cloud-native-hpc:tap_schema.schemas11 | jq '.schema.fields' > tap.schemas11.json
bq show --format=prettyjson cloud-native-hpc:tap_schema.tables11 | jq '.schema.fields' > tap.schema.tables11.json
```