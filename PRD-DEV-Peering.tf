# VPC Peering Connection: PRD to DEV
resource "aws_vpc_peering_connection" "PRD_DEV_Peering" {
  vpc_id      = aws_vpc.PRD-CUS-VPC.id
  peer_vpc_id = aws_vpc.DEV-VPC.id
  auto_accept = true
}

# Route for DEV to PRD
resource "aws_route" "DEV_VPC_to_PRD_VPC" {
  route_table_id              = aws_route_table.DEV-RT-PUB.id
  destination_cidr_block      = aws_vpc.PRD-CUS-VPC.cidr_block
  vpc_peering_connection_id    = aws_vpc_peering_connection.PRD_DEV_Peering.id
}

# Route for PRD to DEV
resource "aws_route" "PRD_VPC_to_DEV_VPC" {
  route_table_id              = aws_route_table.PRD-CUS-RT-PUB.id
  destination_cidr_block      = aws_vpc.DEV-VPC.cidr_block
  vpc_peering_connection_id    = aws_vpc_peering_connection.PRD_DEV_Peering.id
}
