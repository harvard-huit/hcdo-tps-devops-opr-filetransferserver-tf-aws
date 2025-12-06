# Additional instructions for using this backend can be found here: https://developer.hashicorp.com/terraform/language/settings/backends/s3
terraform {
  backend "s3" {
    bucket       = "networktools-prod-standard-terraform-state-bucket"
    key          = "manageengine/prod/terraform.tfstate"
    use_lockfile = true
    region = "us-east-1"
  }
}
