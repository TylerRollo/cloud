locals {
  vpc_cidr = "10.0.0.0/16"
}

resource "aws_vpc" "main" {
  cidr_block = local.vpc_cidr
}

resource "aws_subnet" "private" {
  for_each   = var.private_subnet_config
  vpc_id     = aws_vpc.main.id
  cidr_block = each.value.cidr_block

  tags = {
    project_name = var.project_name
    Name         = "private-${each.key}"
  }
}

resource "aws_subnet" "public" {
  for_each   = var.public_subnet_config
  vpc_id     = aws_vpc.main.id
  cidr_block = each.value.cidr_block

  tags = {
    project_name = var.project_name
    Name         = "public-${each.key}"
  }
}

