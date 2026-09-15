# VPC
resource "aws_vpc" "ecs-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "ecsVPC"
  }
}

# data AZ
data "aws_availability_zones" "ecs_azs" {
  state = "available"
}

# Subnets
resource "aws_subnet" "subnetA" {
  vpc_id            = aws_vpc.ecs-vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = data.aws_availability_zones.ecs_azs.names[0]

  tags = {
    Name = "subnetA"
  }
}

resource "aws_subnet" "subnetB" {
  vpc_id            = aws_vpc.ecs-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.ecs_azs.names[1]

  tags = {
    Name = "subnetB"
  }
}


# Internet Gateway and attaching it to VPC
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.ecs-vpc.id

  tags = {
    Name = "IGW"
  }
}


# Route Table
resource "aws_route_table" "ecsRT" {
  vpc_id = aws_vpc.ecs-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

# Route Table Association
resource "aws_route_table_association" "RTSubnetA" {
  subnet_id      = aws_subnet.subnetA.id
  route_table_id = aws_route_table.ecsRT.id
}
resource "aws_route_table_association" "RTSubnetB" {
  subnet_id      = aws_subnet.subnetB.id
  route_table_id = aws_route_table.ecsRT.id
}


# ALB SG
resource "aws_security_group" "alb_sg" {
  name   = "albSG"
  vpc_id = aws_vpc.ecs-vpc.id
}
# ECS SG
resource "aws_security_group" "ecs_sg" {
  name   = "ecsSG"
  vpc_id = aws_vpc.ecs-vpc.id
}
# ALB SG Rules
resource "aws_vpc_security_group_ingress_rule" "alb_inbound" {
  security_group_id = aws_security_group.alb_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "alb_outbound" {
  security_group_id = aws_security_group.alb_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

# ECS SG Rules
resource "aws_vpc_security_group_ingress_rule" "ecs_inbound" {
  security_group_id = aws_security_group.ecs_sg.id

  referenced_security_group_id = aws_security_group.alb_sg.id
  from_port                    = 8080
  to_port                      = 8080
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "ecs_outbound" {
  security_group_id = aws_security_group.ecs_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}