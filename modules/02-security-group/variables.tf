variable "aws_region" {
  type        = string
  description = "default value for aws region"
}

variable "common_tags" {
  type = object({})
}

variable "project" {
  type        = string
  description = "default value for resource name"
}

variable "vpc_id" {
  type        = string
  description = "vpc id value"
}

variable "vpc_cidr_block" {
  type        = string
  description = "cidr_block vpc"
}