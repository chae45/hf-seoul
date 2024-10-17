# VPC A와 VPC B가 이미 생성되었다고 가정합니다.
# 각각의 VPC, 서브넷, 라우팅 테이블 리소스는 아래의 피어링 설정 전에 생성되어 있어야 합니다.

# VPC 피어링 연결 생성
resource "aws_vpc_peering_connection" "PRD_STG_Peering" {
  vpc_id        = aws_vpc.PRD-CUS-VPC.id   # VPC A ID
  peer_vpc_id   = aws_vpc.STG-VPC.id   # VPC B ID
  #peer_owner_id = "123456789012"     # VPC B가 다른 계정에 있는 경우 해당 계정의 AWS 계정 ID

  auto_accept = true # 동일한 계정 내에서 피어링하는 경우 자동 수락 가능
}

# VPC A의 라우팅 테이블 업데이트 (피어링된 VPC B로의 트래픽 허용)
resource "aws_route" "PRD_CUS_VPC_to_STG_VPC" {
  route_table_id         = aws_route_table.PRD-CUS-RT-PUB.id
  destination_cidr_block = aws_vpc.STG-VPC.cidr_block  # VPC B의 CIDR 블록
  vpc_peering_connection_id = aws_vpc_peering_connection.PRD_STG_Peering.id
}

# VPC B의 라우팅 테이블 업데이트 (피어링된 VPC A로의 트래픽 허용)
resource "aws_route" "STG_VPC_to_PRD_CUS_VPC" {
  route_table_id         = aws_route_table.STG-RT-PUB.id
  destination_cidr_block = aws_vpc.PRD-CUS-VPC.cidr_block  # VPC A의 CIDR 블록
  vpc_peering_connection_id = aws_vpc_peering_connection.PRD_STG_Peering.id
}
