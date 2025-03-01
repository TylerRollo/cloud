# 
# EC2 INSTANCE
#

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Owner is Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_instance" "name" {
  count         = 2
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
    project_name = var.project_name
    Name         = "ec2_instance_${count.index}"
  }
}