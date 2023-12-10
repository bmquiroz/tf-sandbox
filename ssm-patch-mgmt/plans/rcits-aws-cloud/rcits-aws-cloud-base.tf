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

# module "base-infra" {
#   source                     = "../../modules/core"
#   env                        = "sandbox"
#   application                = "rcits"
#   uai                        = "123"
#   aws_region                 = "us-east-1"
#   aws_availability_zones     = ["us-east-1a","us-east-1b"]
#   vpc_cidr                   = "10.0.0.0/16"
#   log_s3                     = "arn:aws:s3:::rcits-poc"
#   ip_subnets                 =  {
#                                 "subnet_public0"  = "10.0.0.0/24"
#                                 "subnet_public1"  = "10.0.1.0/24"
#                                 "subnet_database0" = "10.0.2.0/24"
#                                 "subnet_database1" = "10.0.3.0/24"
#                                 "subnet_compute0" = "10.0.4.0/24"
#                                 "subnet_compute1" = "10.0.5.0/24"
#                                 }
#   tagging_standard           =  {
#                                 "deployment"  = "sandbox"
#                                 "tag1" = "tag1"
#                                 "tag2" = "tag2"
#                                 }
# }

# module "bastion-host" {
#   source                     = "../../modules/ec2"
#   env                        = "sandbox"
#   application                = "rcits"
#   uai                        = "123"
#   # aws_region                 = "us-east-1"
#   aws_subnet_compute_id      = module.base-infra.aws-subnet-compute-id
#   aws_vpc_main_id            = module.base-infra.aws-vpc-main-id
#   aws_key_pair               = "rcits-poc-bastion-key"
#   vpc_cidr                   = "10.0.0.0/16"
#   tagging_standard           =  {
#                                 "deployment"  = "sandbox"
#                                 "tag1" = "tag1"
#                                 "tag2" = "tag2"
#                                 }
#   bastion_ec2_settings       =  {
#                                 "ami"  = "ami-00e87074e52e6c9f9"
#                                 "instance_type" = "t3.small"
#                                 "instance_count" = "1"
#                                 "volume_size" = "50"
#                                 "volume_type" = "gp2"
#                                 }

#   depends_on = [
#     module.base-infra
#   ]
# }

module "ssm-managed-host" {
  source                      = "../../modules/ec2"
  env                         = "sandbox"
  application                 = "rcits"
  uai                         = "123"
  # aws_region                 = "us-east-1"
  aws_subnet_compute_id       = ["subnet-047543b5ae3b70ee4"]
  aws_vpc_main_id             = "vpc-03d790a49d55d25c2"
  aws_key_pair                = "rcits-poc-bastion-key"
  vpc_cidr                    = "10.0.0.0/16"
  associate_public_ip_address = true
  tagging_standard            =  {
                                "deployment"  = "sandbox"
                                "tag1" = "tag1"
                                "tag2" = "tag2"
                                }
  instance_ec2_settings       =  {
                                "ami"  = "ami-093693792d26e4373"
                                "instance_type" = "t3.small"
                                "instance_count" = "1"
                                "volume_size" = "50"
                                "volume_type" = "gp2"
                                }

  # depends_on = [
  #   module.base-infra
  # ]
}