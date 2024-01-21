#!/bin/bash

IMAGE=--image-family=tf-latest-cpu
INSTANCE_NAME=dlvm
GCP_LOGIN_NAME=google-cloud-customer@gmail.com  # CHANGE THIS

gcloud config set compute/zone us-central1-a  # CHANGE THIS

echo "Launching $INSTANCE_NAME"
gcloud compute instances create ${INSTANCE_NAME} \
      --machine-type=n1-standard-2 \
      --scopes=https://www.googleapis.com/auth/cloud-platform,https://www.googleapis.com/auth/userinfo.email \
      ${IMAGE} \
      --image-project=deeplearning-platform-release \
      --boot-disk-device-name=${INSTANCE_NAME} \
      --metadata="proxy-user-mail=${GCP_LOGIN_NAME}"
echo "Looking for Jupyter URL on $INSTANCE_NAME"
while true; do
   proxy=$(gcloud compute instances describe ${INSTANCE_NAME} 2> /dev/null | grep dot-datalab-vm)
   if [ -z "$proxy" ]
   then
      echo -n "."
      sleep 1
   else
      echo "done!"
      echo "$proxy"
      break
   fi
done
