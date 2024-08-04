# Define the VPC
resource "aws_vpc" "ministore-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "ministore-vpc"
  }
}

# Define the first subnet in us-west-1a
resource "aws_subnet" "ministore-subnet-1" {
  vpc_id                  = aws_vpc.ministore-vpc.id
  cidr_block              = var.subnet_cidr_1
  availability_zone       = "us-west-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "ministore-subnet-1"
  }
}

# Define the second subnet in us-west-1b
resource "aws_subnet" "ministore-subnet-2" {
  vpc_id                  = aws_vpc.ministore-vpc.id
  cidr_block              = var.subnet_cidr_2
  availability_zone       = "us-west-1c"
  map_public_ip_on_launch = true
  tags = {
    Name = "ministore-subnet-2"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "ministore-gw" {
  vpc_id = aws_vpc.ministore-vpc.id
  tags = {
    Name = "ministore-gateway"
  }
}

# Create a Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.ministore-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ministore-gw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# Associate the Route Table with the first subnet
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.ministore-subnet-1.id
  route_table_id = aws_route_table.public.id
}

# Associate the Route Table with the second subnet
resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.ministore-subnet-2.id
  route_table_id = aws_route_table.public.id
}