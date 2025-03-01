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

variable "instance_type" {
  type    = string
  default = "t2.micro"

  validation {
    condition     = contains(local.accepted_instance, var.instance_type)
    error_message = "Instance size must be t2.micro or t3.micro"
  }
}

#
# SUBNETS
#

variable "private_subnet_config" {
  type = map(object({
    cidr_block = string
  }))

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

  # Ensure that all provided CIDR blocks are valid.
  validation {
    condition = alltrue([
      for config in values(var.public_subnet_config) : can(cidrnetmask(config.cidr_block))
    ])
    error_message = "At least one of the provided CIDR blocks is not valid for public subnet."
  }
}
