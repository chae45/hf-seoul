# VPC 생성
resource "aws_vpc" "PRD-CUS-VPC" {
  cidr_block           = "10.250.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "PRD-CUS-VPC"
  }
}

# IGW 생성
resource "aws_internet_gateway" "PRD-CUS-IGW" {
  vpc_id = resource.aws_vpc.PRD-CUS-VPC.id
  tags = {
    Name = "PRD-CUS-IGW"
  }
}

# EIP 생성
# resource "aws_eip" "PRD-CUS-VPC-BASTION-PUB-2A-EIP" {
#   instance = aws_instance.PRD-CUS-VPC-BASTION-PUB-2A.id
#   vpc      = true

#   tags = {
#     Name = "PRD-CUS-VPC-BASTION-PUB-2A-EIP"
#   }
# }

resource "aws_eip" "PRD-CUS-NGW-EIP" {
  vpc = true

  tags = {
    Name = "PRD-CUS-NGW-EIP"
  }
}

# NAT 생성
resource "aws_nat_gateway" "PRD-CUS-NGW-2A" {
  allocation_id = aws_eip.PRD-CUS-NGW-EIP.id
  subnet_id     = aws_subnet.PRD-CUS-VPC-BASTION-PUB-2A.id

  tags = {
    Name = "PRD-CUS-NGW-2A"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.PRD-CUS-IGW]
}


# Public rtb
resource "aws_route_table" "PRD-CUS-RT-PUB" {
  vpc_id = aws_vpc.PRD-CUS-VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.PRD-CUS-IGW.id
  }
  tags = {
    Name = "PRD-CUS-RT-PUB"
  }
}

resource "aws_route" "vgw_route" {
  route_table_id         = aws_route_table.PRD-CUS-RT-PRI-2A.id  # 라우팅 테이블 ID
  destination_cidr_block = "10.240.0.0/16"  # 대상 CIDR 블록
  gateway_id             = aws_vpn_gateway.VGW.id  # VGW ID

  depends_on = [aws_vpn_gateway.VGW]
}

# VGW 경로 전파 활성화
resource "aws_vpn_gateway_route_propagation" "vgw" {
  vpn_gateway_id = aws_vpn_gateway.VGW.id
  route_table_id = aws_route_table.PRD-CUS-RT-PUB.id
}

# Private rtb
resource "aws_route_table" "PRD-CUS-RT-PRI-2A" {
  vpc_id = aws_vpc.PRD-CUS-VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.PRD-CUS-NGW-2A.id
  }

  tags = {
    Name = "PRD-CUS-RT-PRI-2A"
  }
  depends_on = [aws_nat_gateway.PRD-CUS-NGW-2A]
}

# rtb association
resource "aws_route_table_association" "PRD-CUS-VPC-BASTION-PUB-2A" {
  subnet_id      = aws_subnet.PRD-CUS-VPC-BASTION-PUB-2A.id
  route_table_id = aws_route_table.PRD-CUS-RT-PUB.id
}

resource "aws_route_table_association" "PRD-CUS-VPC-BASTION-PUB-2C" {
  subnet_id      = aws_subnet.PRD-CUS-VPC-BASTION-PUB-2C.id
  route_table_id = aws_route_table.PRD-CUS-RT-PUB.id
}

resource "aws_route_table_association" "PRD-CUS-VPC-PRI-2A" {
  subnet_id      = aws_subnet.PRD-CUS-VPC-PRI-2A.id
  route_table_id = aws_route_table.PRD-CUS-RT-PRI-2A.id
}

resource "aws_route_table_association" "PRD-CUS-VPC-PRI-2C" {
  subnet_id      = aws_subnet.PRD-CUS-VPC-PRI-2C.id
  route_table_id = aws_route_table.PRD-CUS-RT-PRI-2A.id
}