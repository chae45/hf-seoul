# VPC 생성
resource "aws_vpc" "STG-VPC" {
  cidr_block           = "10.220.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "STG-VPC"
  }
}

# IGW 생성
resource "aws_internet_gateway" "STG-IGW" {
  vpc_id = resource.aws_vpc.STG-VPC.id
  tags = {
    Name = "STG-IGW"
  }
}

# EIP 생성
# resource "aws_eip" "STG-VPC-BASTION-PUB-2A-EIP" {
#   instance = aws_instance.STG-VPC-BASTION-PUB-2A.id
#     domain = "vpc"

#   tags = {
#     Name = "STG-VPC-BASTION-PUB-2A-EIP"
#   }
# }

resource "aws_eip" "STG-NGW-EIP" {
    domain = "vpc"

  tags = {
    Name = "STG-NGW-EIP"
  }
}

# NAT 생성
resource "aws_nat_gateway" "STG-NGW-2A" {
  allocation_id = aws_eip.STG-NGW-EIP.id
  subnet_id     = aws_subnet.STG-VPC-BASTION-PUB-2A.id

  tags = {
    Name = "STG-NGW-2A"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.STG-IGW]
}


# Public rtb
resource "aws_route_table" "STG-RT-PUB" {
  vpc_id = aws_vpc.STG-VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.STG-IGW.id
  }

  tags = {
    Name = "STG-RT-PUB"
  }
}

# Private rtb
resource "aws_route_table" "STG-RT-PRI-2A" {
  vpc_id = aws_vpc.STG-VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.STG-NGW-2A.id
  }

  tags = {
    Name = "STG-RT-PRI-2A"
  }
  depends_on = [aws_nat_gateway.STG-NGW-2A]
}

# rtb association
resource "aws_route_table_association" "STG-VPC-BASTION-PUB-2A" {
  subnet_id      = aws_subnet.STG-VPC-BASTION-PUB-2A.id
  route_table_id = aws_route_table.STG-RT-PUB.id
}

resource "aws_route_table_association" "STG-VPC-BASTION-PUB-2C" {
  subnet_id      = aws_subnet.STG-VPC-BASTION-PUB-2C.id
  route_table_id = aws_route_table.STG-RT-PUB.id
}

resource "aws_route_table_association" "STG-VPC-PRI-2A" {
  subnet_id      = aws_subnet.STG-VPC-PRI-2A.id
  route_table_id = aws_route_table.STG-RT-PRI-2A.id
}

resource "aws_route_table_association" "STG-VPC-PRI-2C" {
  subnet_id      = aws_subnet.STG-VPC-PRI-2C.id
  route_table_id = aws_route_table.STG-RT-PRI-2A.id
}