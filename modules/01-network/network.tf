#Criando a VPC e setando o IP de rede e configs
resource "aws_vpc" "vpc_cloud" {
  cidr_block           = var.network.cidr_block
  enable_dns_support   = var.network.enable_dns_support
  enable_dns_hostnames = var.network.enable_dns_hostnames

  tags = {
    "Name" = "vpc_${var.project}"
  }

}

#Criando o internet gateway e configs
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc_cloud.id

  tags = {
    "Name" = "ig_${var.project}"
  }
}

#Criando as subnets publicas
resource "aws_subnet" "subnet-public" {
  count             = var.network.az_count
  vpc_id            = aws_vpc.vpc_cloud.id
  cidr_block        = cidrsubnet(aws_vpc.vpc_cloud.cidr_block, 8, var.network.az_count + count.index)
  availability_zone = local.selected_vailability_zones[count.index]

  tags = {
    "Name" = "subnet_public_${var.project}"
  }
}

#Criando as subnets privadas
resource "aws_subnet" "subnet-private" {
  count             = var.network.az_count
  vpc_id            = aws_vpc.vpc_cloud.id
  cidr_block        = cidrsubnet(aws_vpc.vpc_cloud.cidr_block, 8, count.index)
  availability_zone = local.selected_vailability_zones[count.index]

  tags = {
    "Name" = "subnet_private_${var.project}"
  }
}

#Criando a tabela de roteamento publica
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc_cloud.id

  route {
    cidr_block = var.network.cidr_internet
    gateway_id = aws_internet_gateway.ig.id
  }

  route {
    cidr_block = var.network.cidr_block
    gateway_id = "local"
  }

  tags = {
    "Name" = "rtb_public_${var.project}"
  }
}

#Criando a tabela de roteamento privada
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc_cloud.id

  route {
    cidr_block = var.network.cidr_block
    gateway_id = "local"
  }

  tags = {
    "Name" = "rtb_private_${var.project}"
  }
}

#Associado as rotas da tabela publica com as subnets publicas
resource "aws_route_table_association" "public" {
  count          = var.network.az_count
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.subnet-public.*.id[count.index]
}

#Assiciando a tabela privada com as subnets privadas
resource "aws_route_table_association" "private" {
  count          = var.network.az_count
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.subnet-private.*.id[count.index]
}


# S3 (gateway endpoint) para as tasks terem acesso ao S3
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.vpc_cloud.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private.id]
}

# CloudWatch Logs
resource "aws_vpc_endpoint" "logs" {
  private_dns_enabled = true
  vpc_id              = aws_vpc.vpc_cloud.id
  service_name        = "com.amazonaws.${var.aws_region}.logs"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.subnet-private.*.id
  security_group_ids  = var.sg_vpc_endpoint
}

# ECR API
resource "aws_vpc_endpoint" "ecr_api" {
  private_dns_enabled = true
  vpc_id              = aws_vpc.vpc_cloud.id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.subnet-private.*.id
  security_group_ids  = var.sg_vpc_endpoint
}

# ECR DKR
resource "aws_vpc_endpoint" "ecr_dkr" {
  private_dns_enabled = true
  vpc_id              = aws_vpc.vpc_cloud.id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.subnet-private.*.id
  security_group_ids  = var.sg_vpc_endpoint
}


