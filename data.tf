# # VPC 정보를 데이터 블록을 통해 가져오기
# data "aws_vpc" "PRD_CUS_VPC" {
#   tags = {
#     Name = "PRD-CUS-VPC"  # VPC A의 이름으로 변경
#   }
# }

# data "aws_vpc" "STG_VPC" {
#   tags = {
#     Name = "STG-VPC"  # VPC B의 이름으로 변경
#   }
# }

# data "aws_vpc" "DEV_VPC" {
#   tags = {
#     Name = "DEV-VPC"  # VPC B의 이름으로 변경
#   }
# }

# # VPC 의 라우팅 테이블 가져오기
# data "aws_route_table" "PRD_CUS_RT_PUB" {
#   filter {
#     name   = "tag:Name"
#     values = ["PRD-CUS-RT-PUB"]
#   }
# }

# data "aws_route_table" "STG_RT_PUB" {
#   filter {
#     name   = "tag:Name"
#     values = ["STG-RT-PUB"]
#   }
# }

# data "aws_route_table" "DEV_RT_PUB" {
#   filter {
#     name   = "tag:Name"
#     values = ["DEV-RT-PUB"]
#   }
# }
