output "vpc" {
  value = {
    id         = aws_vpc.vpc_cloud.id
    arn        = aws_vpc.vpc_cloud.arn
    cidr_block = aws_vpc.vpc_cloud.cidr_block
  }
}

output "subnets" {
  value = {
    private = {
      id         = aws_subnet.subnet-private.*.id
      cidr_block = aws_subnet.subnet-private.*.cidr_block
    }
    public = {
      id         = aws_subnet.subnet-public.*.id
      cidr_block = aws_subnet.subnet-public.*.cidr_block
    }
  }
}

output "route_tables" {
  value = {
    private = {
      id = aws_route_table.private.*.id
    }
    public = {
      id = aws_route_table.public.*.id
    }
  }
}

output "az_count" {
  value = var.network.az_count
}

output "selected_availability_zones" {
  value = local.selected_vailability_zones
}