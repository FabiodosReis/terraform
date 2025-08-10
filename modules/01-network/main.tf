#https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-create

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = merge(
      var.common_tags,
      { Component = "network" }
    )
  }
}

terraform {
  required_version = ">= 1.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.50"
    }
  }

}



