#! /bin/sh

# Set Variables
PROJECT_ID=$(gcloud config get-value project)
REGION=us-central1
ZONE=us-central1-c

# Enable Services
gcloud services enable compute.googleapis.com
gcloud services enable container.googleapis.com
gcloud services enable cloudbuild.googleapis.com
gcloud services enable sql-component.googleapis.com
gcloud services enable sqladmin.googleapis.com

# Create CloudSQL Instance
if ! gcloud sql instances describe tap-schema; then

    # Overwrite if want to set password
    POSTGRES_PASSWORD=$(openssl rand -base64 14)
    echo "POSTGRES password is $POSTGRES_PASSWORD"

    gcloud sql instances create tap-schema \
    --database-version=POSTGRES_13 \
    --availability-type=zonal \
    --zone=${ZONE} \
    --cpu=2 \
    --memory=4 \
    --storage-type=SSD \
    --storage-size=10GB \
    --root-password=${POSTGRES_PASSWORD}
else
  echo "TAP Schema Cloud SQL already created in ${ZONE}"
fi

# Create Cloud SQL Database and load data
if ! gcloud sql databases describe tap_schema -i tap-schema; then
    gcloud sql databases create tap_schema -i tap-schema
    gcloud sql import sql tap-schema gs://tapschema-postgres/tap_schema.sql -d tap_schema --quiet
else
  echo "TAP Schema database already created on instance tap-schema.  Data already loaded"
fi

# Reserve External IP Address
if ! gcloud compute addresses describe tap-external-ip --region=${REGION}; then
    gcloud compute addresses create tap-external-ip  \
        --region=${REGION}
else
    echo "External IP already created in ${REGION}"
fi

EXTERNAL_IP=$(gcloud compute addresses describe tap-external-ip --region us-central1 --format='value(address)')

# Create GKE Autopilot Cluster
if ! gcloud container clusters describe tap --region ${REGION}; then
    gcloud container clusters create-auto tap \
        --region ${REGION} \
        --project=${PROJECT_ID}
else
    echo "Cluster tap already exists.  Not creating"
fi

# Create GCP and Kubernetes Service Accounts
SA_NAME=tap-sa

if ! gcloud iam service-accounts describe ${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com; then
    gcloud iam service-accounts create ${SA_NAME}
else
    echo "${SA_NAME} already existings in GCP.  Not creating"
fi

if ! kubectl get sa ${SA_NAME}; then
    kubectl create serviceaccount --namespace default ${SA_NAME}
else
    echo "${SA_NAME} already existings in GKE.  Not creating"
fi

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member "serviceAccount:${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role "roles/bigquery.dataViewer"


gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member "serviceAccount:${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role "roles/bigquery.jobUser"


gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member "serviceAccount:${SA_NAME}@$PROJECT_ID.iam.gserviceaccount.com" \
    --role "roles/bigquery.readSessionUser"
    
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member "serviceAccount:${SA_NAME}@$PROJECT_ID.iam.gserviceaccount.com" \
    --role "roles/cloudsql.client"

# Set Workload Identity Bindings

gcloud iam service-accounts add-iam-policy-binding  \
    --role roles/iam.workloadIdentityUser \
    --member "serviceAccount:${PROJECT_ID}.svc.id.goog[default/${SA_NAME}]" \
    ${SA_NAME}@$PROJECT_ID.iam.gserviceaccount.com

kubectl annotate serviceaccount \
    --namespace default ${SA_NAME} \
    iam.gke.io/gcp-service-account=${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com

# Update Kubernetes Deployment
sed -i "s/EXTERNAL_IP_REPLACE/${EXTERNAL_IP}/g" k8s/tap-bq-manifests.yaml
sed -i "s/PROJECT_ID_REPLACE/${PROJECT_ID}/g" k8s/tap-bq-manifests.yaml


# Connect to GKE
gcloud container clusters get-credentials tap --region ${REGION} --project ${PROJECT_ID}

# Create secret for Postgres password
kubectl create secret generic tapschema-postgres-secret --from-literal=password=${POSTGRES_PASSWORD}

# Deploy TAP Services and External Load Balancer
kubectl apply -f k8s/tap-bq-manifests.yaml

echo "External IP is ${EXTERNAL_IP}.  TAP URL is http://${EXTERNAL_IP}/tap"