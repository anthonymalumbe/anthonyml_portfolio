IMAGE=--image-family=tf-latest-gpu
INSTANCE_NAME=dlvm

GCP_LOGIN_NAME=google-cloud-customer@gmail.com  # CHANGE THIS

STARTUP_SCRIPT="git clone https://github.com/GoogleCloudPlatform/data-science-on-gcp"

gcloud config set compute/zone us-central1-a  # CHANGE THIS

gcloud compute instances create ${INSTANCE_NAME} \
      --machine-type=n1-standard-8 \
      --scopes=https://www.googleapis.com/auth/cloud-platform,https://www.googleapis.com/auth/userinfo.email \
      --min-cpu-platform="Intel Skylake" \
      ${IMAGE} \
      --image-project=deeplearning-platform-release \
      --boot-disk-size=100GB \
      --boot-disk-type=pd-ssd \ 
      --accelerator=type=nvidia-tesla-p100,count=1 \
      --boot-disk-device-name=${INSTANCE_NAME} \
      --maintenance-policy=TERMINATE --restart-on-failure \
      --metadata="proxy-user-mail=${GCP_LOGIN_NAME},install-nvidia-driver=True,startup-script=${STARTUP_SCRIPT}"
