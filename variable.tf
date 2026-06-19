terraform {
  required_version = ">=1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.0.0"
    }
  }
}

variable "aws_region" {
  default = "us-east-1"
}

variable "instance_type" {
  default = "t3.micro"
}