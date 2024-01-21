function execute_notebook_with_cpu() {
        
    IMAGE_FAMILY="tf-latest-cpu" # Or use any required DLVM image.
    ZONE="us-central1-b"
    INSTANCE_NAME="notebook-executor"
    INSTANCE_TYPE="n1-standard-8"
    INPUT_NOTEBOOK_PATH=$1
    OUTPUT_NOTEBOOK_PATH=$2
    STARTUP_SCRIPT="papermill ${INPUT_NOTEBOOK_PATH} ${OUTPUT_NOTEBOOK_PATH}"
    # Create DLVM
    gcloud compute instances create $INSTANCE_NAME \
        --zone=$ZONE \
        --image-family=$IMAGE_FAMILY \
        --image-project=deeplearning-platform-release \
        --machine-type=$INSTANCE_TYPE \
        --boot-disk-size=100GB \
        --scopes=https://www.googleapis.com/auth/cloud-platform \
        --metadata="startup-script=${STARTUP_SCRIPT}"
    gcloud --quiet compute instances delete $INSTANCE_NAME --zone $ZONE
}
