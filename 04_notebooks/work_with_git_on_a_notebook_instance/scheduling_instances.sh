# Notebook parameters
INPUT_NOTEBOOK_PATH="gs://my-bucket/input.ipynb"
OUTPUT_NOTEBOOK_PATH="gs://my-bucket/output.ipynb"
PARAMETERS_FILE="params.yaml" # Optional
PARAMETERS="-p batch_size 128 -p epochs 40"  # Optional
STARTUP_SCRIPT="papermill ${INPUT_NOTEBOOK_PATH} ${OUTPUT_NOTEBOOK_PATH} -y ${PARAMETERS_FILE} ${PARAMETERS}"

## E. TPU
INSTANCE_NAME=laktpu   # CHANGE THIS
GCP_LOGIN_NAME=google-cloud-customer@gmail.com  # CHANGE THIS
TPU_NAME=$INSTANCE_NAME
gcloud compute instances create $INSTANCE_NAME \
--machine-type n1-standard-8 \
--image-project deeplearning-platform-release \
--image-family tf-1-12-cpu \
--scopes cloud-platform \
--metadata proxy-user-mail="${GCP_LOGIN_NAME}",\
startup-script="echo export TPU_NAME=$TPU_NAME > /etc/profile.d/tpu-env.sh"
gcloud compute tpus create $TPU_NAME \
  --network default \
  --range 10.240.1.0 \
  --version 1.12
  
## F. User credentials
gcloud auth application-default login


## G. TF Nightly
INSTANCE_NAME=tfnightly   # CHANGE THIS
GCP_LOGIN_NAME=google-cloud-customer@gmail.com  # CHANGE THIS
ZONE="us-west1-b" # CHANGE THIS
INSTANCE_TYPE="n1-standard-4" # CHANGE THIS
gcloud compute instances create ${INSTANCE_NAME} \
      --machine-type=$INSTANCE_TYPE \
      --zone=$ZONE \
      --scopes=https://www.googleapis.com/auth/cloud-platform,https://www.googleapis.com/auth/userinfo.email \
      --min-cpu-platform="Intel Skylake" \
      --image-family="tf-latest-gpu-experimental" \
      --image-project=deeplearning-platform-release \
      --boot-disk-size=100GB \
      --boot-disk-type=pd-ssd \
      --accelerator=type=nvidia-tesla-p100,count=1 \
      --boot-disk-device-name=${INSTANCE_NAME} \
      --maintenance-policy=TERMINATE --restart-on-failure \
      --metadata="proxy-user-mail=${GCP_LOGIN_NAME},install-nvidia-driver=True"
