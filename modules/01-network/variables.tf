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

variable "sg_vpc_endpoint" {
  type        = list(string)
  description = "security group for config internal aws endpoint"
}

variable "network" {

  type = object({
    az_count             = number
    cidr_block           = string
    cidr_internet        = string
    enable_dns_support   = bool
    enable_dns_hostnames = bool
  })

  default = {
    az_count             = 2
    cidr_block           = "10.0.0.0/16"
    cidr_internet        = "0.0.0.0/0"
    enable_dns_support   = true
    enable_dns_hostnames = true
  }

  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]{1,2}$", var.network.cidr_block))
    error_message = "Cidr block is not valid format."
  }

  validation {
    condition     = var.network.az_count >= 1 && var.network.az_count <= 3
    error_message = "The az count must be between 1 and 2."
  }
}

