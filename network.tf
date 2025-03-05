#
# ROUTE TABLES
#

# PUBLIC
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# PRIVATE EC2
resource "aws_route_table" "private_ec2_2a" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.public["subnet_1"].id # For AZ 2A
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "private-ec2-route-table-2a"
  }
}

resource "aws_route_table_association" "private_ec2_2a" {
  subnet_id      = aws_subnet.private_ec2_2a.id
  route_table_id = aws_route_table.private_ec2_2a.id
}

resource "aws_route_table" "private_ec2_2b" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.public["subnet_2"].id # For AZ 2B
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "private-ec2-route-table-2b"
  }
}

resource "aws_route_table_association" "private_ec2_2b" {
  subnet_id      = aws_subnet.private_ec2_2b.id
  route_table_id = aws_route_table.private_ec2_2b.id
}


# PRIVATE RDS 

resource "aws_route_table" "private_rds" {
  vpc_id = aws_vpc.main.id

  # No need to add a route to the internet for RDS subnets
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "private-rds-route-table"
  }
}

resource "aws_route_table_association" "private_rds" {
  for_each = {
    "private_rds_2a" = aws_subnet.private_rds_2a,
    "private_rds_2b" = aws_subnet.private_rds_2b
  }

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rds.id
}


#
# VPC AND SUBNETS
#

# Use an existing VPC instead of creating a new one
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "main-vpc"
  }
}

# PRIVATE 
# AZ 2A
resource "aws_subnet" "private_ec2_2a" {
  vpc_id            = aws_vpc.main.id # Ensure it uses an existing VPC
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-2a"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    project_name = var.project_name
    Name         = "private_ec2_2a"
  }
}

resource "aws_subnet" "private_rds_2a" {
  vpc_id            = aws_vpc.main.id # Ensure it uses an existing VPC
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-2a"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    project_name = var.project_name
    Name         = "private_rds_2a"
  }
}

# AZ 2B
resource "aws_subnet" "private_ec2_2b" {
  vpc_id            = aws_vpc.main.id # Ensure it uses an existing VPC
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-2b"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    project_name = var.project_name
    Name         = "private_ec2_2b"
  }
}

resource "aws_subnet" "private_rds_2b" {
  vpc_id            = aws_vpc.main.id # Ensure it uses an existing VPC
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-2b"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    project_name = var.project_name
    Name         = "private_rds_2b"
  }
}

# PUBLIC
resource "aws_subnet" "public" {
  for_each                = var.public_subnet_config
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = false


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

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "main-igw"
  }
}

#
# NAT GATEWAY
#

# PUBLIC
resource "aws_nat_gateway" "public" {
  for_each      = aws_subnet.public
  subnet_id     = each.value.id
  allocation_id = aws_eip.nat[each.key].id


  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "nat-${each.key}"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_eip" "nat" {
  for_each = aws_subnet.public


  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "eip-${each.key}"
  }
}


#
# SECURITY GROUPS
#

resource "aws_security_group" "frontend_sg" {
  name   = "frontend_sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22 #TCP protocol for SSH port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535 # all outbound traffic is allowed to any destination
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "backend_sg" {
  name   = "backend_sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend_sg.id] # Allow only from frontend EC2 SG
  }

  ingress {
    from_port   = 22
    to_port     = 22 #TCP protocol for SSH port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "backend-security-group"
  }
}


resource "aws_security_group" "rds_sg" {
  name   = "rds_sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306 # default port used by MySQL
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Allow EC2 instances to connect
  }

  ingress {
    from_port   = 22
    to_port     = 22 #TCP protocol for SSH port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "main" {
  name = "my-db-subnet-group"
  subnet_ids = [
    aws_subnet.private_rds_2a.id,
    aws_subnet.private_rds_2b.id
  ]
  description = "Database Subnet Group for Multi-AZ Deployment"

  tags = {
    Name = "MyDatabaseSubnetGroup"
  }
}

