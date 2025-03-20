locals {
  azs      = data.aws_availability_zones.azs.names
  az_count = (length(data.aws_availability_zones.azs) >= 3) ? 3 : 2

  private_cidr = cidrsubnet(var.vpc_cidr, 1, 0)
  public_cidr  = cidrsubnet(var.vpc_cidr, 1, 1)

  private_subnets = [
    for idx in range(local.az_count) : cidrsubnet(local.private_cidr, 2, idx)
  ]

  public_subnets = [
    for idx in range(local.az_count) : cidrsubnet(local.public_cidr, 2, idx)
  ]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${local.unique_id}-vpc"
  cidr = var.vpc_cidr

  azs             = local.azs
  public_subnets  = local.public_subnets
  private_subnets = local.private_subnets

  create_igw                                    = true
  enable_nat_gateway                            = false
  enable_vpn_gateway                            = false
  enable_dns_hostnames                          = true
  enable_dns_support                            = true
  enable_ipv6                                   = true
  public_subnet_assign_ipv6_address_on_creation = true

  public_subnet_ipv6_prefixes  = [0, 1, 2]
  private_subnet_ipv6_prefixes = [3, 4, 5]

  tags = {
    owner = "jw"
  }
}