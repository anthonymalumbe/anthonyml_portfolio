function execute_notebook_with_gpu() {  
    IMAGE_FAMILY="tf-latest-cu100" # Or use any required DLVM image.
    ZONE="us-central1-b"
    INSTANCE_NAME="notebook-executor"
    INSTANCE_TYPE="n1-standard-8"
    INPUT_NOTEBOOK_PATH=$1
    OUTPUT_NOTEBOOK_PATH=$2
    GPU_TYPE=$3
    GPU_COUNT=$4
    STARTUP_SCRIPT="papermill ${INPUT_NOTEBOOK_PATH} ${OUTPUT_NOTEBOOK_PATH}"
    # Create DLVM
    gcloud compute instances create $INSTANCE_NAME \
        --zone=$ZONE \
        --image-family=$IMAGE_FAMILY \
        --image-project=deeplearning-platform-release \
        --maintenance-policy=TERMINATE \
        --accelerator="type=nvidia-tesla-${GPU_TYPE},count=${GPU_COUNT}" \
        --machine-type=$INSTANCE_TYPE \
        --boot-disk-size=100GB \
        --scopes=https://www.googleapis.com/auth/cloud-platform \           --metadata="install-nvidia-driver=True,startup-script=${STARTUP_SCRIPT}"
    gcloud --quiet compute instances delete $INSTANCE_NAME --zone $ZONE
}
