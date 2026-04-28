terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  name = var.name_prefix != null && var.name_prefix != "" ? var.name_prefix : "${var.project}-${var.environment}"

  tags = merge(
    {
      Project     = var.project
      Environment = var.environment
      ManagedBy   = "terraform"
    },
    var.tags
  )
}

module "security_groups" {
  source = "../../modules/security-groups"

  name             = local.name
  vpc_id           = var.vpc_id
  allowed_ssh_cidr = var.allowed_ssh_cidr
  tags             = local.tags
}

module "ec2" {
  source = "../../modules/ec2"

  name                      = local.name
  image_id                  = var.image_id
  instance_type             = var.instance_type
  key_name                  = var.key_name
  public_subnet_id          = var.public_subnet_id
  private_subnet_id         = var.private_subnet_id
  public_security_group_id  = module.security_groups.public_security_group_id
  private_security_group_id = module.security_groups.private_security_group_id
  tags                      = local.tags
}
