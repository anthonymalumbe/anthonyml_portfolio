# The key aspect here is to launch papermill with a startup script and 
# exit the notebook VM using TERMINATE without a restart-on-failure once papermill is done. 
# Then, delete the VM.


# Compute Engine Instance parameters
IMAGE=--image=tf-latest-gpu-20190125b2 # CHANGE
INSTANCE_NAME=dlvm
ZONE="us-central1-b"  # CHANGE
INSTANCE_TYPE="n1-standard-4"  #CHANGE
# Notebook parameters
GCS_INPUT_NOTEBOOK="gs://my-bucket/input.ipynb"
GCS_OUTPUT_NOTEBOOK="gs://my-bucket/output.ipynb"
GCS_INPUT_PARAMS="gs://my-bucket/params.yaml" # Optional
export STARTUP_SCRIPT="https://raw.githubusercontent.com/anthonymalumbe/anthonyml_portfolio/main/04_notebooks/scripts/notebook_executor.sh"

gcloud compute instances create $INSTANCE_NAME \
        --zone=$ZONE \
        --image=$IMAGE \
        --image-project=deeplearning-platform-release \
        --maintenance-policy=TERMINATE \
        --accelerator='type=nvidia-tesla-t4,count=2' \
        --machine-type=$INSTANCE_TYPE \
        --boot-disk-size=100GB \
        --scopes=https://www.googleapis.com/auth/cloud-platform \
        --metadata="input_notebook_path=${GCS_INPUT_NOTEBOOK},output_notebook_path=${GCS_OUTPUT_NOTEBOOK},parameters_file=${GCS_INPUT_PARAMS},startup-script-url=$LAUNCHER_SCRIPT,startup-script=${STARTUP_SCRIPT}"

gcloud --quiet compute instances delete $INSTANCE_NAME --zone $ZONE
