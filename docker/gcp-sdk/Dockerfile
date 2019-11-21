ARG GCP_SDK_VERSION=267.0.0
ARG PYTHON_VERSION=3.6
FROM docker-whirl-airflow:py-${PYTHON_VERSION}-local

RUN sudo adduser _apt --force-badname && sudo apt-get update &&\
    sudo apt-get install -y gnupg apt-transport-https ca-certificates &&\
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - &&\
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list &&\
    sudo apt-get update && sudo apt-get install -y google-cloud-sdk