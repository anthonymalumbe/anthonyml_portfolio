The Deep Learning VM instance requires several permissions: read and write ability to Cloud Storage, and the ability to delete instances on Compute Engine. That is why our original command has the scope “https://www.googleapis.com/auth/cloud-platform” defined.
The submission process will look like this:
```
execute_notebook_with_gpu gs://my-bucket/input.ipynb gs://my-bucket/output.ipynb t4 4
```
## Note: 
Verify that you have enough CPU or GPU resources available by checking your quota in the zone where your instance will be deployed.
