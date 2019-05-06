#!/usr/bin/bash

SCRIPT_DIR=$( dirname ${BASH_SOURCE[0]} )
# the file credentials.json should not be checked into git, and is therefore added to the .gitignore
# make sure you obtain the credentials file and paste it in the whirl.setup.d folder
cp "$SCRIPT_DIR/credentials.json" /credentials.json

echo "========================================="
echo "= Download and install Google Cloud SDK ="
echo "========================================="

SDK_VERSION=244.0.0
SHA256=832567cbd0046fd6c80f55196c5c2a8ee3a0f1e1e2587b4a386232bd13abc45b

cd /
wget "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${SDK_VERSION}-linux-x86_64.tar.gz"
echo "${SHA256} google-cloud-sdk-${SDK_VERSION}-linux-x86_64.tar.gz" | sha256sum -c -
tar xzf /google-cloud-sdk-${SDK_VERSION}-linux-x86_64.tar.gz
rm /google-cloud-sdk-${SDK_VERSION}linux-x86_64.tar.gz
/google-cloud-sdk/install.sh --quiet
echo "export PATH=/google-cloud-sdk/bin:$PATH" >> ~/.bashrc
source ~/.bashrc
gcloud components install beta --quiet


echo "======================================="
echo "= Configure GCP connection in Airflow ="
echo "======================================="

if [ -f "${GOOGLE_APPLICATION_CREDENTIALS}" ]; then
	export GCP_PROJECT=$(grep -o "project_id\":\s\"\(.*\)\"" ${GOOGLE_APPLICATION_CREDENTIALS} | sed -e 's/.*:\s\"\(.*\)\"/\1/g')
	echo "Project ID: " $GCP_PROJECT

	gcloud config set disable_usage_reporting true
	gcloud config set project ${GCP_PROJECT}
	gcloud auth activate-service-account --key-file ${GOOGLE_APPLICATION_CREDENTIALS}

	airflow connections -a --conn_id google_cloud_default --conn_type google_cloud_platform \
	                       --conn_extra "{\"extra__google_cloud_platform__scope\": \"https://www.googleapis.com/auth/cloud-platform\",
	                                      \"extra__google_cloud_platform__project\": \"${GCP_PROJECT}\",
	                                      \"extra__google_cloud_platform__key_path\": \"${GOOGLE_APPLICATION_CREDENTIALS}\"
	                                     }"                                                               
else 
  	echo "No service account set via GOOGLE_APPLICATION_CREDENTIALS"                                       
fi

