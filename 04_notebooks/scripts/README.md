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
