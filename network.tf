#
# VPC AND SUBNETS
#

locals {
  cidr_block = "10.0.0.0/16"
}

# GITHUB ACTIONS KEEPS MAKING NEW VPC'S
/**
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}
*/

data "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  default = false
}

resource "aws_subnet" "private" {
  for_each   = var.private_subnet_config
  vpc_id     = data.aws_vpc.main.id
  cidr_block = each.value.cidr_block

  tags = {
    project_name = var.project_name
    Name         = "private-${each.key}"
  }
}

resource "aws_subnet" "public" {
  for_each   = var.public_subnet_config
  vpc_id     = data.aws_vpc.main.id
  cidr_block = each.value.cidr_block

  tags = {
    project_name = var.project_name
    Name         = "public-${each.key}"
  }
}

