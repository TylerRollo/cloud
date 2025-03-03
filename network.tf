#
# VPC AND SUBNETS
#

# Use an existing VPC instead of creating a new one
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "private" {
  for_each          = var.private_subnet_config
  vpc_id            = aws_vpc.main.id # Ensure it uses an existing VPC
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    project_name = var.project_name
    Name         = "private-${each.key}"
  }
}

resource "aws_subnet" "public" {
  for_each          = var.public_subnet_config
  vpc_id            = aws_vpc.main.id # Ensure it uses an existing VPC
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    project_name = var.project_name
    Name         = "public-${each.key}"
  }
}

#
# INTERNET GATEWAY
#

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

resource "aws_internet_gateway_attachment" "example" {
  internet_gateway_id = aws_internet_gateway.igw.id
  vpc_id              = aws_vpc.main.id
}

#
# NAT GATEWAY
#

resource "aws_nat_gateway" "example" {
  for_each = aws_subnet.public
  subnet_id = each.value.id

  allocation_id = aws_eip.nat[each.key].id

  tags = {
    Name = "nat-${each.key}"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_eip" "nat" {
  for_each = aws_subnet.public
  
  tags = {
    Name = "eip-${each.key}"
  }
}

