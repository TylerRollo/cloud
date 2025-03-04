#
# KEY PAIR
#

resource "tls_private_key" "my_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "my_key_pair" {
  key_name   = var.keypair
  public_key = tls_private_key.my_key.public_key_openssh
}


