terraform {
  required_version = ">= 1.15.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# VPC
resource "aws_vpc" "p4_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# public subnet
resource "aws_subnet" "p4_subnet" {
  vpc_id                  = aws_vpc.p4_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "${var.project_name}-subnet"
  }
}
# Internet Gateway
resource "aws_internet_gateway" "p4_igw" {
  vpc_id = aws_vpc.p4_vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# Route Table
resource "aws_route_table" "p4_rt" {
  vpc_id = aws_vpc.p4_vpc.id

  tags = {
    Name = "${var.project_name}-rt"
  }
}

# Public Route
resource "aws_route" "p4_public_route" {
  route_table_id         = aws_route_table.p4_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.p4_igw.id
}

# Subnet Association
resource "aws_route_table_association" "p4_assoc" {
  subnet_id      = aws_subnet.p4_subnet.id
  route_table_id = aws_route_table.p4_rt.id
}
