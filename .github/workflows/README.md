# Workflow Readme
This directory contains active workflows for this repository.  It also has a sample_workflows directory with additional workflow examples.

## Active Workflows

| Workflow        | Trigger       | Description   |
| --------------- | ------------- | -------------- |
| build_app.yml   | Manual [Instructions](#triggering-actions) | Builds the app with a simple `terraform plan` and `terraform apply`. The values within the included `terraform.tfvars` will be used when the workflow executes these commands. |
| destroy_app.yml | Manual [Instructions](#triggering-actions) | Destroys the app with a simple `terraform destroy`. The values within the included `terraform.tfvars` will be used when the workflow executes this command.|


## Triggering Actions 

To manually trigger the `build_app` or `destroy_app` by going to the Actions tab at the top of your repo. These both require an input for the `environment_name` field to control what environment the workflow executes against. These are meant to be used as examples, and will likely need updated to tailor them to your Terraform configuration.


# Example Workflows

| Workflow        | Trigger       | Description   |
| --------------- | ------------- | -------------- |
| [validate-on-main_apply-on-release.yml ](./sample_workflows/README.md)  | PR to main , Published Release to main | This workflow triggers on PR to main and runs a Terraform plan.  After PR merged to main, Terraform apply is triggered on published release to main. |

