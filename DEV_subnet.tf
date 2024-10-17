resource "aws_subnet" "DEV-VPC-BASTION-PUB-2A" {
  vpc_id                  = aws_vpc.DEV-VPC.id
  cidr_block              = "10.230.1.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = true # public IP 자동 할당

  tags = {
    Name = "DEV-VPC-BASTION-PUB-2A"
  }
}

resource "aws_subnet" "DEV-VPC-PRI-2A" {
  vpc_id                  = aws_vpc.DEV-VPC.id
  cidr_block              = "10.230.2.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = true # Public IP 자동 할당

  tags = {
    Name = "DEV-VPC-PRI-2A"
  }
}