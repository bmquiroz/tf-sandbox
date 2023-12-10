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
  profile = "mfa"
#   assume_role {
#   role_arn = "arn:aws:iam::653187539224:role/gehc-explorer"
#     }
}

module "base-infra" {
  source                     = "../modules/core"
  env                        = "dev"
  application                = "atlas"
  uai                        = "327"
  aws_region                 = "us-east-1"
  aws_availability_zones     = ["us-east-1a","us-east-1b"]
  vpc_cidr                   = "10.0.0.0/16"
  log_s3                     = "arn:aws:s3:::267-atlas-poc"
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

module "eks-cluster" {
  source                     = "../modules/eks"
  env                        = "dev"
  application                = "atlas"
  uai                        = "327"
  aws_region                 = "us-east-1"
  aws_availability_zones     = ["us-east-1a","us-east-1b"]
  # subnet_ids                 = ["subnet-03c158cfc9d632bd7", "subnet-0d45ecfd0b3d2032a"]
  # vpc_id                     = "vpc-04893809054cc38bf"
  subnet_ids                 = [module.base-infra.aws_subnet.compute.*.id]
  vpc_id                     = module.base-infra.aws-vpc-main-id
  instance_type              = "m6a.large"
  tagging_standard           =  {
                                "deployment"  = "sandbox"
                                "tag1" = "tag1"
                                "tag2" = "tag2"
                                }
  # security_group             = "sg-0e691c18d86efc7da"
  security_group             = module.base-infra.eks-sg-id
}