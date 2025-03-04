#
# EC2 INSTANCES
#

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# PRIVATE


# PUBLIC

resource "aws_instance" "app_2a" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public["subnet_1"].id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.my_key_pair.key_name

  security_groups = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "react-app-instance_2a"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install -y nginx
              sudo rm /var/www/html/index.html
              EOF

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_instance" "app_2b" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public["subnet_2"].id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.my_key_pair.key_name

  security_groups = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "react-app-instance_2b"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install -y nginx
              sudo rm /var/www/html/index.html
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

