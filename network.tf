locals {
  vpc_cidr            = "10.0.0.0/16"
  private_subnet_cidr = "10.0.0.0/24"
  public_subnet_cidr  = "10.0.128.0/24"
}

data "aws_vpc" "default" {
  default = false
}

resource "aws_vpc" "main" {
  cidr_block = local.vpc_cidr
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = local.private_subnet_cidr

  tags = {
    project_name = var.project_name
    Name = "private-subnet"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = local.public_subnet_cidr

  tags = {
    project_name = var.project_name
    Name = "public-subnet"
  }
}

