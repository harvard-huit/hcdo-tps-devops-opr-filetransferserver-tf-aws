
# -----------------------------------------
# REQUIRED VALUES 
# -----------------------------------------

# Product Context Variables
product_name              = "manageengine"
product_name_short        = "manageengine"
product_environment       = "Production"
product_environment_short = "prod"
product_asset_id          = "11744"
product_context           = "standard"
product_criticality       = "Non-Critical"
product_data_class        = "nonlevel4"
product_hosted_by         = "DevOps-APT6"
#product_patch_policy      = "Mon_11PM"
#product_backup_policy     = "11PM_DAILY"
#product_tier              = "app"
#product_owner             = "Networking"
git_repo                  = "https://github.com/harvard-huit/hcdo-tps-devops-manageengine-tf-aws"
route53_zone_name         = "network.prod.cloud.huit.harvard.edu"
shared_values_prefix      = "SharedValues-networktools-prod"
ec2_keypair_name          = "manageengine-prod"
iam_instance_profile_name = "manageengine-aws-prod-app-iam-role"





# ------------------------------------------------------------------------------------------------------------------------------------------
# Add infrastructure tier variables
# The Reference Architecture can be found here: https://github.com/harvard-huit/hcdo-cto-reference-architecture-app-tf-aws
#-------------------------------------------------------------------------------------------------------------------------------------------

