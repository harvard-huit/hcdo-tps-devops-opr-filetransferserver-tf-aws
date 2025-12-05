# ------------------------------------------------------------------------------
# Locals
# ------------------------------------------------------------------------------

locals {

  # Retrieve the default tags and region from the constants module
  default_tags   = module.constants.default_tags
  default_region = module.constants.default_region

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

  # You can additionally make the subnet calls more dynamic by using a 'app tier' variable

  # subnet = module.metadata.vpc_config.subnets["${var.product_context}"]["${var.app_tier}"]

  # If you have additional global tags you'd like to add to all resources, you can do that like this:
  # global_tags = merge(
  #   local.default_tags,
  #   {
  #     "some_tag_key"              = "some_tag_value",
  #   }
  # )
  # You can then use the same merge function to add these tags to any resource you create alongside any resource-specific tags.

}

# ------------------------------------------------------------------------------
# Data Sources
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# Modules
# ------------------------------------------------------------------------------

module "constants" {
  source  = "artifactory.huit.harvard.edu/cloudarch-terraform-virtual__aws-modules/aws_constants/aws"
  version = "~> v1.0"

  # Product Context Variables
  product_name              = var.product_name
  product_name_short        = var.product_name_short
  product_environment       = var.product_environment
  product_environment_short = var.product_environment_short
  product_asset_id          = var.product_asset_id
  product_context           = var.product_context
  product_criticality       = var.product_criticality
  product_data_class        = var.product_data_class
}

module "metadata" {
  source  = "artifactory.huit.harvard.edu/cloudarch-terraform-virtual__aws-modules/aws_metadata/aws"
  version = "~> v2.0"

  # Set to the defual shared valued in CF Export
  shared_values_prefix = var.shared_values_prefix

}

# ------------------------------------------------------------------------------
# Resources
# ------------------------------------------------------------------------------

# Place additional resources here. The following resource is just used as an example.
resource "null_resource" "do_nothing" {

}
