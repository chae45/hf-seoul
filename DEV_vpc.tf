# VPC 생성
resource "aws_vpc" "DEV-VPC" {
  cidr_block           = "10.230.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "DEV-VPC"
  }
}

# IGW 생성
resource "aws_internet_gateway" "DEV-IGW" {
  vpc_id = resource.aws_vpc.DEV-VPC.id
  tags = {
    Name = "DEV-IGW"
  }
}

# EIP 생성
resource "aws_eip" "DEV-NGW-EIP" {
    domain = "vpc"

  tags = {
    Name = "DEV-NGW-EIP"
  }
}

# NAT 생성
resource "aws_nat_gateway" "DEV-NGW-2A" {
  allocation_id = aws_eip.DEV-NGW-EIP.id
  subnet_id     = aws_subnet.DEV-VPC-BASTION-PUB-2A.id

  tags = {
    Name = "DEV-NGW-2A"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.DEV-IGW]
}


# Public rtb
resource "aws_route_table" "DEV-RT-PUB" {
  vpc_id = aws_vpc.DEV-VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.DEV-IGW.id
  }

  tags = {
    Name = "DEV-RT-PUB"
  }
}

# Private rtb
resource "aws_route_table" "DEV-RT-PRI-2A" {
  vpc_id = aws_vpc.DEV-VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.DEV-NGW-2A.id
  }

  tags = {
    Name = "DEV-RT-PRI-2A"
  }
  depends_on = [aws_nat_gateway.DEV-NGW-2A]
}

# rtb association
resource "aws_route_table_association" "DEV-VPC-BASTION-PUB-2A" {
  subnet_id      = aws_subnet.DEV-VPC-BASTION-PUB-2A.id
  route_table_id = aws_route_table.DEV-RT-PUB.id
}

resource "aws_route_table_association" "DEV-VPC-PRI-2A" {
  subnet_id      = aws_subnet.DEV-VPC-PRI-2A.id
  route_table_id = aws_route_table.DEV-RT-PRI-2A.id
}
