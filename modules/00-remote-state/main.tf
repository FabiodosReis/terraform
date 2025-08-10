provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = merge(
      local.common_tags,
      { Component = "remote-state" }
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




