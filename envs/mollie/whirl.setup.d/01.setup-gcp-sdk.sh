#!/usr/bin/bash

echo "======================================="
echo "= Configure GCP connection in Airflow ="
echo "======================================="

gcloud config set project ${GCP_PROJECT}

airflow connections -a --conn_id google_cloud_default --conn_type google_cloud_platform \
                       --conn_extra "{\"extra__google_cloud_platform__scope\": \"https://www.googleapis.com/auth/cloud-platform\",
                                      \"extra__google_cloud_platform__project\": \"${GCP_PROJECT}\"
                                     }"                                                               

airflow connections -a --conn_id bigquery_default --conn_type google_cloud_platform  \
					   --conn_extra "{\"extra__google_cloud_platform__scope\": \"https://www.googleapis.com/auth/cloud-platform\",
                                      \"extra__google_cloud_platform__project\": \"${GCP_PROJECT}\"
                                     }"