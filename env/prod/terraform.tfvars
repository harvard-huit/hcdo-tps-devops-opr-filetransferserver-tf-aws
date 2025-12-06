
# -----------------------------------------
# REQUIRED VALUES 
# -----------------------------------------

# Product Context Variables
product_name              = "opr-filetransferserver"
product_name_short        = "opr-filetransferserver"
product_environment       = "Production"
product_environment_short = "prod"
product_asset_id          = "11754"
product_context           = "standard"
product_criticality       = "Non-Critical"
product_data_class        = "nonlevel4"
product_hosted_by         = "DevOps-APT6"
#product_patch_policy      = "Ton_11PM"
#product_backup_policy     = "11PM_DAILY"
#product_tier              = "app"
#product_owner             = "Networking"
git_repo                  = "https://github.com/harvard-huit/hcdo-tps-devops-filetransferserver-tf-aws"
route53_zone_name         = "cadm.cloud.huit.harvard.edu"
shared_values_prefix      = "SharedValues-cadm-prod"
ec2_keypair_name          = "opr-filetransferserver-prod"
iam_instance_profile_name = "opr-filetransferserver-aws-prod-app-iam-role"





# ------------------------------------------------------------------------------------------------------------------------------------------
# Add infrastructure tier variables
# The Reference Architecture can be found here: https://github.com/harvard-huit/hcdo-cto-reference-architecture-app-tf-aws
#-------------------------------------------------------------------------------------------------------------------------------------------

