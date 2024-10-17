# VPC Peering Connection: DEV to STG
resource "aws_vpc_peering_connection" "DEV_STG_Peering" {
  vpc_id      = data.aws_vpc.DEV_VPC.id
  peer_vpc_id = data.aws_vpc.STG_VPC.id
  auto_accept = true
}

# Route for DEV to STG
resource "aws_route" "DEV_VPC_to_STG_VPC" {
  route_table_id              = data.aws_route_table.DEV_RT_PUB.id
  destination_cidr_block      = data.aws_vpc.STG_VPC.cidr_block
  vpc_peering_connection_id    = aws_vpc_peering_connection.DEV_STG_Peering.id
}

# Route for STG to DEV
resource "aws_route" "STG_VPC_to_DEV_VPC" {
  route_table_id              = data.aws_route_table.STG_RT_PUB.id
  destination_cidr_block      = data.aws_vpc.DEV_VPC.cidr_block
  vpc_peering_connection_id    = aws_vpc_peering_connection.DEV_STG_Peering.id
}
