**The Deep Learning VM images](https://cloud.google.com/deep-learning-vm/),  help you automate your notebook training, such that you no longer need to pay extra or manually manage your Cloud infrastructure. Take advantage of all the pre-installed ML software and Nteract’s Papermill project to help you solve your ML problems more quickly!**

**Papermill will help you automate the execution of yourJupyter notebooks and in combination of Cloud Storage and Deep Learning VM images you can now set up this process in a very simple and cost efficient way.**

The Deep Learning VM instance requires several permissions: read and write ability to Cloud Storage, and the ability to delete instances on Compute Engine. That is why the original command has the scope “https://www.googleapis.com/auth/cloud-platform” defined.
The submission process will look like this:
```
execute_notebook_with_gpu gs://my-bucket/input.ipynb gs://my-bucket/output.ipynb t4 4
```
## Note: 
Verify that you have enough CPU or GPU resources available by checking your quota in the zone where your instance will be deployed.


This ```executing_a_Jupyter_notebook.sh``` is the standard way to create a Deep Learning VM. But keep in mind, you’ll need to pick the VM that includes the core dependencies you need to execute your notebook. Do not try to use a TensorFlow image if your notebook needs PyTorch or vice versa.

## Note: 
if you do not see a dependency that is required for your notebook and you think should be in the image, please let us know on the forum (or with a comment to this article).

### The secret sauce here contains two following things:

[Startup shell script](https://raw.githubusercontent.com/GoogleCloudPlatform/ml-on-gcp/master/dlvm/tools/scripts/notebook_executor.sh)

[Papermill library](https://papermill.readthedocs.io/en/latest/)

Papermill is a tool for parameterising, executing, and analysing Jupyter Notebooks. Papermill lets you:
1. Parameterise notebooks via command line arguments or a parameter file in YAML format
2. Execute and collect metrics across the notebooks
3. Summarise collections of notebooks

### Behind the scenes

Let’s start with the startup shell script parameters:

```INPUT_NOTEBOOK_PATH```: The input notebook located Cloud Storage bucket.
Example: ```gs://my-bucket/input.ipynb```

```OUTPUT_NOTEBOOK_PATH```: The output notebook located Cloud Storage bucket.
Example: ```gs://my-bucket/input.ipynb```

```PARAMETERS_FILE```: Users can provide a YAML file where notebook parameter values should be read.
Example: ```gs://my-bucket/params.yaml```

```PARAMETERS```: Pass parameters via -p key value for notebook execution.
Example: ```-p batch_size 128 -p epochs 40```

The two ways to execute the notebook with parameters are: (1) through the Python API and (2) through the command line interface. This sample script supports two different ways to pass parameters to Jupyter notebook, although Papermill supports other formats, so please consult Papermill’s documentation.

The above script performs the following steps:

1. Creates a Compute Engine instance using the TensorFlow Deep Learning VM and 2 NVIDIA Tesla T4 GPUs
2. Installs NVIDIA GPU drivers
3. Executes the notebook using Papermill tool
4. Uploads notebook result (with all the cells pre-computed) to Cloud Storage bucket in this case: ```gs://my-bucket/```
5. Papermill emits a save after each cell executes, this could generate “429 Too Many Requests” [errors](https://github.com/nteract/papermill/issues/312), which are handled by the library itself.
6. Terminates the Compute Engine instance
