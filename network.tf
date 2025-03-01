#
# VPC AND SUBNETS
#

# Use an existing VPC instead of creating a new one
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "private" {
  for_each   = var.private_subnet_config
  vpc_id     = aws_vpc.main.id # Ensure it uses an existing VPC
  cidr_block = each.value.cidr_block

  tags = {
    project_name = var.project_name
    Name         = "private-${each.key}"
  }
}

resource "aws_subnet" "public" {
  for_each   = var.public_subnet_config
  vpc_id     = aws_vpc.main.id # Ensure it uses an existing VPC
  cidr_block = each.value.cidr_block

  tags = {
    project_name = var.project_name
    Name         = "public-${each.key}"
  }
}
