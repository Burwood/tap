#! /bin/sh

# Set variables
GCS_BUCKET=tap-staging-2
REGION=us-central1

# Create datasets
bq --location=US mk --dataset tap_schema

# Create schema tables
bq mk --table tap_schema.KeyValue ./install/tap-schema/key_value.json
bq mk --table tap_schema.Modelversion ./install/tap-schema/model_version.json
bq mk --table tap_schema.columns11 ./install/tap-schema/columns11.json
bq mk --table tap_schema.key_columns11 ./install/tap-schema/key_columns11.json
bq mk --table tap_schema.keys11 ./install/tap-schema/keys11.json
bq mk --table tap_schema.schemas11 ./install/tap-schema/schemas11.json
bq mk --table tap_schema.tables11 ./install/tap-schema/tables11.json

# Load data into schemas
gsutil mb -b on -l ${REGION} gs://${GCS_BUCKET}
gsutil cp install/tap-schema-data/*.csv gs://${GCS_BUCKET}
bq load --noreplace --source_format=CSV --skip_leading_rows=1 tap_schema.tables11 gs://${GCS_BUCKET}/tables11.csv
bq load --noreplace --source_format=CSV --skip_leading_rows=1 tap_schema.schemas11 gs://${GCS_BUCKET}/schemas11.csv
bq load --noreplace --source_format=CSV --skip_leading_rows=1 tap_schema.columns11 gs://${GCS_BUCKET}/columns11.csv
bq load --noreplace --source_format=CSV --skip_leading_rows=1 tap_schema.key_columns11 gs://${GCS_BUCKET}/key_columns11.csv
bq load --noreplace --source_format=CSV --skip_leading_rows=1 tap_schema.keys11 gs://${GCS_BUCKET}/keys11.csv

bq load --noreplace --source_format=CSV --skip_leading_rows=1 tap_schema.keys11 gs://${GCS_BUCKET}/keys11.csv
bq load --noreplace --source_format=CSV --skip_leading_rows=1 tap_schema.keys11 gs://${GCS_BUCKET}/keys11.csv

bq mk --table tap_schema.KeyValue ./install/tap-schema/key_value.json
bq mk --table tap_schema.Modelversion ./install/tap-schema/model_version.json