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
  name = "${var.project}-${var.environment}"

  tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

module "vpc" {
  source = "../../modules/vpc"

  name       = local.name
  cidr_block = var.vpc_cidr
  tags       = local.tags
}

module "subnets" {
  source = "../../modules/subnets"

  name                = local.name
  vpc_id              = module.vpc.vpc_id
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zone   = var.availability_zone
  tags                = local.tags
}

module "nat_gateway" {
  source = "../../modules/nat-gateway"

  name             = local.name
  public_subnet_id = module.subnets.public_subnet_id
  tags             = local.tags

  depends_on = [module.vpc]
}

module "route_tables" {
  source = "../../modules/route-tables"

  name                = local.name
  vpc_id              = module.vpc.vpc_id
  internet_gateway_id = module.vpc.internet_gateway_id
  nat_gateway_id      = module.nat_gateway.nat_gateway_id
  public_subnet_id    = module.subnets.public_subnet_id
  private_subnet_id   = module.subnets.private_subnet_id
  tags                = local.tags
}
