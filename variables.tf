# GLOBAL

variable "project_name" {
  type    = string
  default = "first_cloud_project"
}

# EC2 INSTANCE

locals {
  accepted_instance = [
    "t2.micro",
    "t3.micro"
  ]
}

locals {
  accepted_ami = [
    "ubuntu",
    "nginx"
  ]
}

variable "ec2_instance_config_map" {
  type = map(object({
    instance_type = string
    ami           = string
  }))

  default = {
    instance_1 = {
      instance_type = "t2.micro",
      ami           = "ubuntu"
    }
  }

  validation {
    condition = alltrue([
      for instance in var.ec2_instance_config_map : contains(local.accepted_instance, instance.instance_type)
    ])
    error_message = "Instance type must be t2.micro or t3.micro"
  }

  validation {
    condition = alltrue([
      for instance in var.ec2_instance_config_map : contains(local.accepted_ami, instance.ami)
    ])
    error_message = "Image must either be 'ubuntu' or 'nginx'"
  }
}

#
# SUBNETS
#

variable "private_subnet_config" {
  type = map(object({
    cidr_block = string
  }))

  default = {
    subnet_1 = {
      cidr_block = "10.0.0.0/24"
    }
  }

  # Ensure that all provided CIDR blocks are valid.
  validation {
    condition = alltrue([
      for config in values(var.private_subnet_config) : can(cidrnetmask(config.cidr_block))
    ])
    error_message = "At least one of the provided CIDR blocks is not valid for private subnet."
  }
}

variable "public_subnet_config" {
  type = map(object({
    cidr_block = string
  }))
  default = {
    subnet_1 = {
      cidr_block = "10.0.128.0/24"
    }
  }

  # Ensure that all provided CIDR blocks are valid.
  validation {
    condition = alltrue([
      for config in values(var.public_subnet_config) : can(cidrnetmask(config.cidr_block))
    ])
    error_message = "At least one of the provided CIDR blocks is not valid for public subnet."
  }
}
