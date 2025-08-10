terraform {
  required_version = ">= 1.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.50"
    }
  }
}


provider "aws" {
  region = var.aws_region

  default_tags {
    tags = merge(
      var.common_tags,
      { Component = "ecs" }
    )
  }
}