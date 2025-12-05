# AWS Terraform App Template

## 1.1. Purpose

This is meant to serve as a base configuration to get started with developing Terraform for AWS. An example environment folder for a `dev`  and `prod` environments have also been created.

After this template has been deployed for an application.  This readme must be replaced with an application infrastructure readme.  A template [readme](README_template.md) has been created and should be used as a standard. 

- [AWS Terraform App Template](#aws-terraform-app-template)
  - [1.1. Purpose](#11-purpose)
  - [1.2. Contents of This Repository](#12-contents-of-this-repository)
    - [1.2.1. The following Terraform files have been provided.  Some will require updating. See below for instructions.:](#121-the-following-terraform-files-have-been-provided--some-will-require-updating-see-below-for-instructions)
    - [1.2.2. The following GitHub Action Workflow files have been provided:](#122-the-following-github-action-workflow-files-have-been-provided)
  - [1.3. Included HUIT Provided Modules](#13-included-huit-provided-modules)
    - [1.3.1. Included HUIT Provided Modules](#131-included-huit-provided-modules)
    - [1.3.2. Module Usage Information](#132-module-usage-information)
      - [1.3.2.1. AWS Metadata Module](#1321-aws-metadata-module)
      - [1.3.2.2. AWS Constants Module](#1322-aws-constants-module)
  - [1.4. GitHub Actions Setup and Configuration](#14-github-actions-setup-and-configuration)
    - [1.4.1. GitHub Actions](#141-github-actions)
    - [1.4.2. Sample Github Actions](#142-sample-github-actions)
    - [1.4.3. Setup Instructions](#143-setup-instructions)
  - [1.5. Local Execution](#15-local-execution)
  - [1.6. Additional Resources](#16-additional-resources)


## 1.2. Contents of This Repository 
Click "Expand for more details", to see more details on the files and folders that are contained in this repository.
<details>
<summary>Expand for more details.</summary>

### 1.2.1. The following Terraform files have been provided.  Some will require updating. See below for instructions.:
1. `main.tf`
    - This is where the bulk of your Terraform configuration can be placed, including resources, data sources, and any locals needed to simplify your configuration logic.
2. `versions.tf`
    - This is where all Terraform/provider configuration is placed. The general versions and a generic AWS provider config have already been placed in this file.
3. `variables.tf`
    - This is where any input variables required by your Terraform should be placed.
4. `outputs.tf`
    - This is where any values that you'd like to output from your Terraform configuration should be placed.
5. `./env/dev/backend.tf`
    - This controls where your Terraform state is stored in AWS S3. You'll need to update the file accordingly for your environment.
    - There are prerequisites to get the S3 Terraform backend to work with AWS S3, detailed here: [Setting up Terraform S3 backend with AWS S3](https://developer.hashicorp.com/terraform/language/settings/backends/s3)
6. `./env/dev/terraform.tfvars`
    - This houses your input values for each environment.
    - When you add more environments (stage, prod, etc), create a new folder within the ./env/ directory with your environment name and copy this file and the `backend.tf` file there, updating values as necessary for the new environment.

### 1.2.2. The following GitHub Action Workflow files have been provided:
1. `.github/workflow/README.md`
   - This readme provides details on the active workflows and the `sample_workflows`
2. `.github/workflow/build_app.yaml`
   - This workflow will validate and build/deploy an AWS application defined in the Terraform configuration in this repo. It is triggered manually by the user and will prompt for the Terraform 'Action', app environment name, and the runner. These input variables are meant as an example and can be modified to fit the needs of the Terraform configuration in this repo.
3. `.github/workflow/destroy_app.yaml`
   - This workflow will destroy the app infrastructure using Terraform. It is triggered manually by the user and will prompt for the app environment name, and the runner. These input variables are meant as an example and can be modified to fit the needs of the Terraform configuration in this repo.
4. `.github/workflow/terraform_state_verify.yaml`
   - This workflow will refresh the state of the app infrastructure via `terraform plan/apply -refresh-only`. It is triggered manually like the previous two workflows.
5. `.github/workflow/sample_workflows/`
   - This folder contains sample workflows that are triggered by repository events.  See the [README.md](.github/workflows/sample_workflows/README.md) for more details.

</details>

## 1.3. Included HUIT Provided Modules
The `main.tf` file uses two HUIT modules, "constants" and "metadata" that are used to enforce IaC standards and to provide cloud account details used to build cloud resources.  It also provides usage information.  Click "Expand for more details", to get more information on these modules.

<details>
<summary>Expand for more details.</summary>

### 1.3.1. Included HUIT Provided Modules
1. [AWS Metadata Module](https://github.com/HUIT-Cloud-Architecture/hcdo-cto-metadata-tf-module-aws)
2. [AWS Constants Module](https://github.com/HUIT-Cloud-Architecture/hcdo-cto-constants-tf-module-aws)

### 1.3.2. Module Usage Information

#### 1.3.2.1. AWS Metadata Module


Module call:
```
module "metadata" {
  source  = "artifactory.huit.harvard.edu/cloudarch-terraform-virtual__aws-modules/aws_metadata/aws"
  version = ">= v1.3.9" # This is just to ensure the latest version will be pulled when the app is first set up. 
  # We recommend updating this so that only patch version upgrades are pulled in the future.

  # Product Context Variables
  account_name = var.account_name
  # account_env               = var.account_env
  product_name              = var.product_name
  product_name_short        = var.product_name_short
  product_environment       = var.product_environment
  product_environment_short = var.product_environment_short
  product_asset_id          = var.product_asset_id
  product_context           = var.product_context

  # Set to the defual shared valued in CF Export
  shared_values_prefix = var.shared_values_prefix

}
```

Structure of the `vpc_config` output:
```
vpc_config = {
    az_count         = 2
    global_sg_all    = "sg-xxxxxxxx"
    global_sg_lm_web = "sg-xxxxxxxx"
    subnets          = {
        level4   = {
            app     = [
                "subnet-xxxxxxxx",
                "subnet-xxxxxxxx",
            ]
            db      = [
                "subnet-xxxxxxxx",
                "subnet-xxxxxxxx",
            ]
            elbpriv = [
                "subnet-xxxxxxxx",
                "subnet-xxxxxxxx",
            ]
            elbpub  = [
                "subnet-xxxxxxxx",
                "subnet-xxxxxxxx",
            ]
        }
        standard = {
            app     = [
                "subnet-xxxxxxxx",
                "subnet-xxxxxxxx",
            ]
            db      = [
                "subnet-xxxxxxxx",
                "subnet-xxxxxxxx",
            ]
            elbpriv = [
                "subnet-xxxxxxxx",
                "subnet-xxxxxxxx",
            ]
            elbpub  = [
                "subnet-xxxxxxxx",
                "subnet-xxxxxxxx",
            ]
        }
    }
    vpc_id           = "vpc-xxxxxxxx"
}
```

Example Usage when calling the AWS Metadata Module:
```
# Retrieve the whole VCN Config and OCID from the metadata module
vpc_config = module.metadata.vpc_config
vpc_id     = module.metadata.vpc_config.vpc_id

# Retrieve the AZ Count and Global SGs from the metadata module
az_count         = module.metadata.vpc_config.az_count
global_sg_all    = module.metadata.vpc_config.global_sg_all
global_sg_lm_web = module.metadata.vpc_config.global_sg_lm_web

# NOTE: The below subnet calls are meant as examples -- please feel free to use whichever method works best for your use case and delete the ones you don't need.

# Retrieve standard subnets directly from the metadata module
standard_app_subnet     = module.metadata.vpc_config.subnets.standard.app
standard_db_subnet      = module.metadata.vpc_config.subnets.standard.db
standard_elbpriv_subnet = module.metadata.vpc_config.subnets.standard.elbpriv
standard_elbpub_subnet  = module.metadata.vpc_config.subnets.standard.elbpub

# Retrieve the level4 subnets directly from the metadata module
level4_app_subnet     = module.metadata.vpc_config.subnets.level4.app
level4_db_subnet      = module.metadata.vpc_config.subnets.level4.db
level4_elbpriv_subnet = module.metadata.vpc_config.subnets.level4.elbpriv
level4_elbpub_subnet  = module.metadata.vpc_config.subnets.level4.elbpub

# Retrieve the Subnet IDs more dynamically from the metadata module using the product context variable.
elbpub_subnet  = module.metadata.vpc_config.subnets["${var.product_context}"].elbpub
elbpriv_subnet = module.metadata.vpc_config.subnets["${var.product_context}"].elbpriv
app_subnet     = module.metadata.vpc_config.subnets["${var.product_context}"].app
db_subnet      = module.metadata.vpc_config.subnets["${var.product_context}"].db

# Retrieve the Subnet ID of a single tier by use of the tier variable. This is useful if you want to create multiple resources in the same tier.
tier_subnet = module.metadata.vpc_config.subnets["${var.product_context}"]["${var.tier}"]
```

#### 1.3.2.2. AWS Constants Module
Module call:
```
module "constants" {
  source  = "artifactory.huit.harvard.edu/cloudarch-terraform-virtual__aws-modules/aws_constants/aws"
  version = ">= v1.0.7" # This is just to ensure the latest version will be pulled when the app is first set up. 
  # We recommend updating this so that only patch version upgrades are pulled in the future.

  # Product Context Variables
  product_name              = var.product_name
  product_name_short        = var.product_name_short
  product_environment       = var.product_environment
  product_environment_short = var.product_environment_short
  product_asset_id          = var.product_asset_id
  product_context           = var.product_context
}
```

Output structure for `values` output:
```
values = {
  "default_region" = "us-east-1"
  "default_tags" = {
    "backup_policy" = "11PM_DAILY"
    "criticality" = "Non-Critical"
    "data_class" = "nonlevel4"
    "environment" = "dev"
    "hosted_by" = "Not-Defined"
    "huit_assetid" = -1
    "managed_by" = "Terraform"
    "product" = "terraform"
  }
}
```

Output structure for `default_tags` output:
```
default_tags = {
    "backup_policy" = "11PM_DAILY"
    "criticality" = "Non-Critical"
    "data_class" = "nonlevel4"
    "environment" = "dev"
    "hosted_by" = "Not-Defined"
    "huit_assetid" = -1
    "managed_by" = "Terraform"
    "product" = "terraform"
  }
```

</details>

## 1.4. GitHub Actions Setup and Configuration
This repository includes [Active](.github/workflows/README.md) and [Sample](.github/workflows/sample_workflows/README.md) GitHub Action Workflows. The following section contains information on how to configure and use them.  Click "Expand for more details", to see more information on the provided GitHub Action Workflows
<details>
<summary>Expand for more details.</summary>  

### 1.4.1. GitHub Actions

There are two workflows included in this base repository: `build_app.yaml` and `destroy_app.yaml` under `.github/workflows/`. These each are triggered off of the `workflow_dispatch` event, meaning that you
have to manually trigger them by going to the Actions tab at the top of your repo. These both require an input for the `environment_name` field to control what environment the workflow executes against. These are meant to be used as examples, and will likely need updated to tailor them to your Terraform configuration.

Addition sample workflows are provided under the `.github/workflows/sample_workflows/` folder, and these workflows operate in a more automated fashion compared to the workflows mentioned in the previous paragraph.

### 1.4.2. Sample Github Actions
Additional sample Github Actions have been provided for alternative workflows for deploying and managing AWS infrastructure.  Information on sample GitHub Actions can be found [here](.github/workflows/README.md) 

### 1.4.3. Setup Instructions

Prerequisites: You will need a service account in AWS with API keys and customer secret keys provisioned and stored correctly in an environment in your repo. These credentials specified as file contents such as:

1. Create a new Environment in your repository settings to store required secrets, detailed in the table below.

<table>
    <tr>
        <th>GitHub Environment Secrets</th>
        <th>Expected Content</th>
    </tr>
    <tr>
        <td>AWS_ASSUMED_ROLE</td>
        <td>Obtained from AWS IAM</td>
    </tr>
</table>

2. At the Repository, create the following Repository variables:

<table>
    <tr>
        <th>GitHub Repository Variables</th>
        <th>Expected Content</th>
    </tr>
    <tr>
        <td>AWS_REGION</td>
        <td>us-east-1</td> 
    </tr>
</table>

1. In order for any GitHub Action workflow to run, you'll need to enable GitHub Actions under your repository settings in Actions --> General.
2. If needed/desired, update the input variables at the top of the workflow to match your needs.
3. Expose the necessary Terraform variables to the necessary workflows/jobs/steps as described within the workflow files.
    - Consult the following documents for more information:
        - https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions
        - https://developer.hashicorp.com/terraform/language/values/variables

</details>

## 1.5. Local Execution

A script called `tflocal` has been included for convenience, if the need arises to execute your Terraform configuration locally. To use the script:

```bash
Usage:
./tflocal <env> terraform <terraform operation + options>
Note: This script will run any command that comes after the <env> argument.
Examples:
./tflocal <env> terraform plan
./tflocal <env> terraform init -reconfigure
```

## 1.6. Additional Resources

1. [Terraform Standards/Best Practices](https://harvardwiki.atlassian.net/wiki/spaces/ITSCloud/pages/50694336/Standards+Best+Practices)
2. [Terraform Training Courses (VPN Required)](https://tft.prod.cloudarch.cloud.huit.harvard.edu/)
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=5.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.2.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_null"></a> [null](#provider\_null) | >= 3.2.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_constants"></a> [constants](#module\_constants) | artifactory.huit.harvard.edu/cloudarch-terraform-virtual__aws-modules/aws_constants/aws | >= v1.0.21 |
| <a name="module_metadata"></a> [metadata](#module\_metadata) | artifactory.huit.harvard.edu/cloudarch-terraform-virtual__aws-modules/aws_metadata/aws | >= v2.0.9 |

## Resources

| Name | Type |
|------|------|
| [null_resource.do_nothing](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_composite_name"></a> [composite\_name](#input\_composite\_name) | Used as an override to support pre-existing resource names that don't fit the new naming scheme. | `string` | `""` | no |
| <a name="input_product_asset_id"></a> [product\_asset\_id](#input\_product\_asset\_id) | The HUIT asset id associated to this product. This value must be procured before stack creation in order to insure accurate billing. | `number` | `-1` | no |
| <a name="input_product_context"></a> [product\_context](#input\_product\_context) | The security context applied to this product. This determines which subnets CloudFormation will deploy the product into and if it creates various resources to meet a given context's compliance requirements, e.g. KMS. | `string` | `"standard"` | no |
| <a name="input_product_criticality"></a> [product\_criticality](#input\_product\_criticality) | (Optional) The criticality of this product. This value must correspond with the product rating as listed in ServiceNow -> HUIT Config -> Application. The default is 'Non-Critical'. | `string` | `"Non-Critical"` | no |
| <a name="input_product_data_class"></a> [product\_data\_class](#input\_product\_data\_class) | (Optional) The data class of the data stored in this product. This value is generally calculated by subnet placement - e.g. in a level4 subnet. | `string` | `"nonlevel4"` | no |
| <a name="input_product_environment"></a> [product\_environment](#input\_product\_environment) | Which stage of development is this stack being provisioned for (long form, e.g. 'Development')? | `string` | n/a | yes |
| <a name="input_product_environment_short"></a> [product\_environment\_short](#input\_product\_environment\_short) | Which stage of development is this stack being provisioned for (short form, e.g. 'dev')? | `string` | n/a | yes |
| <a name="input_product_hosted_by"></a> [product\_hosted\_by](#input\_product\_hosted\_by) | (Optional) The HUIT hosted by group. This is used by reporting and operations e.g. DevOps-APT12, DevOps-APT3, etc. This value must be set if managed by DevOps.  The default is 'Not-Defined'. | `string` | `"Not-Defined"` | no |
| <a name="input_product_name"></a> [product\_name](#input\_product\_name) | Identifies this project. This name is used within various resource's 'Name' tag, DNS entries, to determine S3 locations, and so on. | `string` | n/a | yes |
| <a name="input_product_name_short"></a> [product\_name\_short](#input\_product\_name\_short) | Identifies this project. This Short name is used within various resource's 'Name' tag, DNS entries, to determine S3 locations, and so on. | `string` | n/a | yes |
| <a name="input_shared_values_prefix"></a> [shared\_values\_prefix](#input\_shared\_values\_prefix) | The prefix to use for the SharedValues CloudFormation imports.  The default "SharedValues" value will utilize the CS1 SharedValues exports.<br/>      The following examples show you how to use a CS2 SharedValues export:<br/>        Example: SharedValues-cloudhacks-dev<br/>        Example: SharedValues-hup-prod | `string` | n/a | yes |
| <a name="input_tier"></a> [tier](#input\_tier) | The application tier being deployed, e.g. app, db, lb\_pub, or lb\_priv. | `string` | `"app"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vpc_config"></a> [vpc\_config](#output\_vpc\_config) | n/a |
<!-- END_TF_DOCS -->
