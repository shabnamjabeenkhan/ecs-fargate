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
