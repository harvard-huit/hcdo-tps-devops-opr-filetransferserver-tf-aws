# Release Notes

## Requirements

- Terraform version >= 1.11.0

## New Features

- Added support for the `use_lockfile` argument in the S3 backend configuration. This feature requires Terraform version 1.11.0 or higher.

## Usage

To make use of the `use_lockfile` argument in your S3 backend configuration, ensure that your Terraform version is 1.11.0 or higher. Below is an example of how to configure the S3 backend with the `use_lockfile` argument:

```hcl
terraform {
  backend "s3" {
    bucket       = "<your_compartment_bucket_here>"     # Update accordingly with your remote state bucket name.
    key          = "some/unique/path/terraform.tfstate" # Make sure this value is unique, especially if using the same cloudhacks bucket.
    use_lockfile = true

    region = "us-east-1" # Update for your environment.
  }
}
```

## Upgrade Notes

- If you are upgrading from a version of Terraform older than 1.11.0, you will need to update your Terraform installation to take advantage of the `use_lockfile` argument.
- To move from DynamoDB to a lockfile, no further action is required after replacing the `dynamodb_table` argument with `use_lockfile = true`
  - However, if you need to move in the opposite direction after already using DynamoDB in the past, you must remove the entry from your DynamoDB table to be able to initialize the backend
    - This is because DynamoDB will be out of sync with the current TF state after performing operations with `use_lockfile = true` set.

## Bug Fixes

- N/A

## Known Issues

- N/A

## Deprecations

- N/A

For more details, please refer to the official [Terraform documentation](https://www.terraform.io/docs/backends/types/s3.html).