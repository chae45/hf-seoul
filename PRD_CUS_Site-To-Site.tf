provider "aws" {
  alias  = "other_region"
  region = "us-east-1"  # 다른 리전
}

data "aws_instance" "PRD_VPC_Router" {
  provider = aws.other_region
  filter {
    name   = "tag:Name"
    values = ["PRD-VPC-ROUTE-1A"]
  }
  filter {
    name   = "instance-state-name"  # 인스턴스 상태 필터
    values = ["running"]  # 실행 중인 인스턴스만 가져오기
  }
}

# 고객 게이트웨이 생성
resource "aws_customer_gateway" "CGW" {
  bgp_asn    = 65000  # 고객 측 BGP ASN
  ip_address = data.aws_instance.PRD_VPC_Router.public_ip  # 인스턴스의 공인 IP
  type       = "ipsec.1"
}

# VPN 게이트웨이 생성
resource "aws_vpn_gateway" "VGW" {
  vpc_id = aws_vpc.PRD-CUS-VPC.id  # VPC ID
}

# VPN 게이트웨이와 VPC 연결
resource "aws_vpn_gateway_attachment" "VGW-VPC" {
  vpc_id          = aws_vpc.PRD-CUS-VPC.id  # VPC ID
  vpn_gateway_id  = aws_vpn_gateway.VGW.id
}

# VPN 연결 생성
resource "aws_vpn_connection" "STS" {
  vpn_gateway_id      = aws_vpn_gateway.VGW.id
  customer_gateway_id = aws_customer_gateway.CGW.id
  type                = "ipsec.1"

  static_routes_only = true
}

# 정적 경로 설정
resource "aws_vpn_connection_route" "STS_STATIC" {
  vpn_connection_id     = aws_vpn_connection.STS.id
  destination_cidr_block = "10.240.0.0/16"  # 고객  네트워크 CIDR
}
resource "aws_vpn_connection_route" "STS_STATIC2" {
  vpn_connection_id     = aws_vpn_connection.STS.id
  destination_cidr_block = "10.250.0.0/16"  # 가상 네트워크 CIDR
}