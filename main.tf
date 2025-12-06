# ------------------------------------------------------------------------------
# Modules
# ------------------------------------------------------------------------------
module "constants" {
  source  = "artifactory.huit.harvard.edu/cloudarch-terraform-virtual__aws-modules/aws_constants/aws"
  version = "~> v1.0"

  product_name              = var.product_name
  product_name_short        = var.product_name_short
  product_environment       = var.product_environment
  product_environment_short = var.product_environment_short
  product_asset_id          = var.product_asset_id
  product_context           = var.product_context
  product_criticality       = var.product_criticality
  product_data_class        = var.product_data_class
  product_hosted_by         = var.product_hosted_by
}

module "metadata" {
  source  = "artifactory.huit.harvard.edu/cloudarch-terraform-virtual__aws-modules/aws_metadata/aws"
  version = "~> v2.0"
  shared_values_prefix = var.shared_values_prefix
}

# ------------------------------------------------------------------------------
# Resources
# ------------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# EC2 Security Group
# -----------------------------------------------------------------------------
module "ec2_sg" {
  source  = "artifactory.huit.harvard.edu/cloudarch-terraform-virtual__aws-modules/aws_sg/aws"
  version = "~> v2.0"

  tier   = "app"
  vpc_id = module.metadata.vpc_config.vpc_id

  name_prefix = "${module.constants.resource_prefix}"

  ingress_rules = {
    "socdbadmin" = {
      from_port   = -1
      to_port     = -1
      ip_protocol = -1
      cidr_ipv4   = "10.11.134.0/24"
      description = "VPN Tunnel (socdbadmin)."
    },
    "devops" = {
      from_port   = 22
      to_port     = 22
      ip_protocol = "tcp"
      cidr_ipv4   = "10.142.34.64/26"
      description = "devops vdi"
    },
    "UNSGADMIN" = {
      from_port   = 22
      to_port     = 22
      ip_protocol = "tcp"
      cidr_ipv4   = "10.1.209.0/24"
      description = "UNSGADMIN_VPN_TUNNEL"
    }
  }

}
  
# -----------------------------------------------------------------------------
# Instances
# -----------------------------------------------------------------------------
module "ec2_kms_key" {
  source  = "artifactory.huit.harvard.edu/cloudarch-terraform-virtual__aws-modules/aws_kms/aws"
  version = "~> v0.2"

  description    = "KMS key for ${var.product_name_short}-${var.product_environment_short} resources."
  key_name       = "${var.product_name_short}-${var.product_environment_short}-app-${var.product_context}-kms"
  constants_data = module.constants
  kms_key_for    = "ec2"
  tier           = "app"
  iam_role_name  = var.iam_instance_profile_name
  enable_key_rotation = false
}

locals {
  security_group_ids = [module.metadata.global_sg_all, module.ec2_sg.sg.id]
}

locals {
  instances = {
    01 = {
      tier          = "app"
      name          = "${module.constants.resource_prefix}-app-ec2-01"
      ami           = "ami-052931429e6676282"
      instance_type = "r7a.xlarge"
      static        = true
      platform      = "linux"
      backup_policy = "11PM_DAILY"
      security_group_ids = [module.ec2_sg.sg.id]
      #subnet_id     = module.metadata.vpc_config.subnets["level4"]["app"][0]
      subnet_id       = "subnet-04d1ec120efa1d573"
      fqdn          = "${var.product_name}-app01.${var.route53_zone_name}"
      iam_instance_profile_name = var.iam_instance_profile_name
    }
  }
}

module "ec2_instances" {
  source  = "artifactory.huit.harvard.edu/cloudarch-terraform-virtual__aws-modules/aws_ec2/aws"
  version = "~> 1.0"

  for_each = local.instances

  name          = each.value.name
  tier          = each.value.tier
  instance_type = each.value.instance_type
  subnet_id     = each.value.subnet_id
  static        = each.value.static
  platform      = each.value.platform
  backup_policy = each.value.backup_policy
  iam_instance_profile_name = each.value.iam_instance_profile_name

  constants_data = module.constants
  metadata_data  = module.metadata

  ami                = each.value.ami
  security_group_ids = local.security_group_ids
  disable_api_stop   = false
  key_name           = var.ec2_keypair_name

  user_data_base64            = module.bootstrap[each.key].user_data_cmd
  user_data_replace_on_change = false

  enable_volume_tags = true
  root_block_device = [
    {
      delete_on_termination = false
      encrypted   = true
      volume_type = "gp3"
      volume_size = 50
      kms_key_id  = module.ec2_kms_key.key_arn
      tags = {
        Name        = "${module.constants.resource_prefix}-app-ec2-0${each.key}"
        mount_point = "/"
        git_repo    = var.git_repo
      }
    },
  ]
  additional_ebs_block_devices = {
    01 = {
      device_name = "/dev/xvdf"
      encrypted   = true
      volume_type = "gp3"
      volume_size = 500
      kms_key_id  = module.ec2_kms_key.key_arn
      tags = {
        Name        = "${module.constants.resource_prefix}-app-ec2-0${each.key}"
        mount_point = "/data"
        git_repo    = var.git_repo
      }
    },
  }
  tags = {
      patch_policy = "Mon_11PM"
      fqdn         = each.value.fqdn
      git_repo     = var.git_repo
  }
}

# -----------------------------------------------------------------------------
# Route53 for EC2
# -----------------------------------------------------------------------------
data "aws_route53_zone" "this" {
  name = var.route53_zone_name
  private_zone = true #"I have used this option because the hosted is private, comment this if you are using public hostedzone"
  #name = "network.prod.cloud.huit.harvard.edu"
}

locals {
  route53 = {
    01 = {
      domain_name   = "${module.constants.resource_prefix}-app01.${var.route53_zone_name}"
      records       = [module.ec2_instances[1].private_ip]
    }
  }
}
module "ec2_alias" {
  source  = "artifactory.huit.harvard.edu/cloudarch-terraform-virtual__aws-modules/aws_route53/aws"
  version = "~> v0.1"

  for_each = local.route53
  zone_id     = data.aws_route53_zone.this.id
  domain_name = each.value.domain_name
  type        = "A"
  records     = each.value.records
  ttl         = 300
}

# -----------------------------------------------------------------------------
# Bootstrap
# -----------------------------------------------------------------------------
data "aws_secretsmanager_secret" "ansible_callback_token" {
  name = "ansible-callback-token"
}

data "aws_secretsmanager_secret_version" "ansible_callback_token" {
  secret_id = data.aws_secretsmanager_secret.ansible_callback_token.id
}

locals {
  hostname = {
    01 = {
      hostname = "${module.constants.resource_prefix}-app01.${var.route53_zone_name}"
    }
  }
}

locals {
  user_data_after = <<-EOT
#!/bin/sh
# Install some utilities.
dnf install nmap bc gcc -y > /dev/null 2>&1
# Get the EBS mounting script from the repository and run it.
aws s3 cp s3://huit-devops-software-repository/dbasme-utils/usr-local-bin/dbsme-aws-mount-ebs.sh /root/dbsme-aws-mount-ebs.sh
chmod 740 /root/dbsme-aws-mount-ebs.sh
/root/dbsme-aws-mount-ebs.sh
EOT
}

module "bootstrap" {
  source  = "artifactory.huit.harvard.edu/cloudarch-terraform-virtual__aws-modules/aws_bootstrap/aws"
  version = "~> v1.0"
  ansible_callback_token  = jsondecode(data.aws_secretsmanager_secret_version.ansible_callback_token.secret_string)["ansible-callback-token"]
  ansible_module_template = 16406
  user_data_after = local.user_data_after
  
  for_each = local.hostname
  
  user_data_before = templatefile("./files/hostname.sh.tpl", {
    hostname = "${each.value.hostname}"
  })
  role_list = ["satellite_reg", "os_utils", "os_ad_registration"]
}
