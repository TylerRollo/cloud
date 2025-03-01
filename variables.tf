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


