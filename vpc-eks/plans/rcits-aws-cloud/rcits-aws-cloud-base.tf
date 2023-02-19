terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  profile = "default"
#   assume_role {
#   role_arn = "arn:aws:iam::000000:role/rcits-explorer"
#     }
}

module "base-infra" {
  source                     = "../../modules/core"
  env                        = "sandbox"
  application                = "rcits"
  # uai                        = "327"
  aws_region                 = "us-east-1"
  aws_availability_zones     = ["us-east-1a","us-east-1b"]
  vpc_cidr                   = "10.0.0.0/16"
  log_s3                     = "arn:aws:s3:::rcits-poc"
  ip_subnets                 =  {
                                "subnet_public0"  = "10.0.0.0/24"
                                "subnet_public1"  = "10.0.1.0/24"
                                "subnet_database0" = "10.0.2.0/24"
                                "subnet_database1" = "10.0.3.0/24"
                                "subnet_compute0" = "10.0.4.0/24"
                                "subnet_compute1" = "10.0.5.0/24"
                                }
  tagging_standard           =  {
                                "deployment"  = "sandbox"
                                "tag1" = "tag1"
                                "tag2" = "tag2"
                                }
}

# module "eks-cluster" {
#   source                     = "../../modules/eks"
#   env                        = "sandbox"
#   application                = "rcits"
#   # uai                        = "327"
#   aws_region                 = "us-east-1"
#   aws_availability_zones     = ["us-east-1a","us-east-1b"]
#   subnet_ids                 = module.base-infra.aws-subnet-compute-id
#   vpc_id                     = module.base-infra.aws-vpc-main-id
#   instance_type              = "m6a.large"
#   tagging_standard           =  {
#                                 "deployment"  = "sandbox"
#                                 "tag1" = "tag1"
#                                 "tag2" = "tag2"
#                                 }
#   security_group             = module.base-infra.eks-sg-id

#   depends_on = [
#     module.base-infra
#   ]
# }

# module "db" {
#   source                     = "../../modules/rds"
#   env                        = "sandbox"
#   application                = "rcits"
#   uai                        = "327"
#   aws_region                 = "us-east-1"
#   db_allocated_storage       = "200"
#   db_engine                  = "postgres"
#   db_engine_version          = "14.1"
#   db_identifier              = "rcitst-pg-db"
#   db_instance_class          = "db.t4g.large"
#   db_storage_type            = "gp2"
#   db_name                    = "rcitstpgdb"
#   db_password                = ""
#   db_username                = "rcitsdba"
#   aws_subnet_database_id     = module.base-infra.aws-subnet-database-id
#   aws_vpc_main_id            = module.base-infra.aws-vpc-main-id
#   # enabled_cloudwatch_logs_exports = var.rds_log
#   # monitoring_role_arn        = var.rds_monitoring
#   vpc_cidr                   = "10.0.0.0/16"
#   tagging_standard           =  {
#                                 "deployment"  = "sandbox"
#                                 "tag1" = "tag1"
#                                 "tag2" = "tag2"
#                                 }

#   depends_on = [
#     module.base-infra
#   ]
# }

# module "api-gateway" {
#   source                     = "../../modules/api_gateway"
#   env                        = "sandbox"
#   application                = "rcits"
#   uai                        = "327"
#   aws_region                 = "us-east-1"
#   random_string              = "some-string"
#   account_id                 = "123456789"
#   cat_url                    = "https:\\test.com"
#   nlb_endpoint_arns          = ["arn:aws:elasticloadbalancing:us-east-1:653187539224:loadbalancer/net/a6e16b1dd761b45249f262f01466dcc4/8c1bbc5064a3c091"]
#   tagging_standard           =  {
#                                 "deployment"  = "sandbox"
#                                 "tag1" = "tag1"
#                                 "tag2" = "tag2"
#                                 }

#   depends_on = [
#     module.base-infra
#   ]
# }

module "bastion-host" {
  source                     = "../../modules/bastion_ec2"
  env                        = "sandbox"
  application                = "rcits"
  # uai                        = "327"
  # aws_region                 = "us-east-1"
  aws_subnet_compute_id      = module.base-infra.aws-subnet-compute-id
  aws_vpc_main_id            = module.base-infra.aws-vpc-main-id
  aws_key_pair               = "rcits-poc-bastion-key"
  vpc_cidr                   = "10.0.0.0/16"
  tagging_standard           =  {
                                "deployment"  = "sandbox"
                                "tag1" = "tag1"
                                "tag2" = "tag2"
                                }
  bastion_ec2_settings       =  {
                                "ami"  = "ami-00e87074e52e6c9f9"
                                "instance_type" = "t3.small"
                                "instance_count" = "1"
                                "volume_size" = "50"
                                "volume_type" = "gp2"
                                }

  depends_on = [
    module.base-infra
  ]
}

# module "cloudfront" {
#   source                     = "../../modules/cloudfront"
#   env                        = "sandbox"
#   application                = "rcits"
#   uai                        = "327"
#   aws_region                 = "us-east-1"
#   nlb_subnet_ids             = module.base-infra.aws-subnet-compute-id
#   domain_cnames              = ["dev-rcits.idam.gehealthcloud.io"]
#   domain_name                = "gehealthcloud.io"
#   nlb_endpoint               = "ad2e1bc4e6fd947efa8bcd1ad3167832-38c92dd22c16dcd3.elb.us-east-2.amazonaws.com"
#   # nlb_sg_ids                 = module.base-infra.eks-sg-id
#   tagging_standard           =  {
#                                 "deployment"  = "sandbox"
#                                 "tag1" = "tag1"
#                                 "tag2" = "tag2"
#                                 }

#   depends_on = [
#     module.base-infra,
#     module.eks-cluster
#   ]
# }

# module "waf" {
#   source                     = "../../modules/waf"
#   env                        = "sandbox"
#   application                = "rcits"
#   uai                        = "327"
#   aws_region                 = "us-east-1"
#   tagging_standard           =  {
#                                 "deployment"  = "sandbox"
#                                 "tag1" = "tag1"
#                                 "tag2" = "tag2"
#                                 }

#   depends_on = [
#     module.cloudfront
#   ]
# }