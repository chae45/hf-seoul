# resource "aws_elasticache_subnet_group" "redis_subnet_group" {
#   name       = "redis-subnet-group"
#   subnet_ids = [aws_subnet.PRD-CUS-VPC-BASTION-PUB-2A.id, aws_subnet.PRD-CUS-VPC-BASTION-PUB-2C.id, aws_subnet.PRD-CUS-VPC-PRI-2A.id, aws_subnet.PRD-CUS-VPC-PRI-2C.id]  # 기존 서브넷 ID 사용
# }

# resource "aws_elasticache_replication_group" "redis_replication_group" {
#   replication_group_id          = "redis-replication-group"
#   description = "Redis replication group with cluster mode disabled"
#   engine                        = "redis"
#   engine_version                = "7.1"  # 원하는 Redis 버전 선택
#   node_type                     = "cache.t3.micro"  # 원하는 인스턴스 타입 설정
#   parameter_group_name          = "default.redis7"  # 사용할 Redis 파라미터 그룹

#   automatic_failover_enabled    = false  # 자동 장애 조치 비활성화
#   preferred_cache_cluster_azs   = ["ap-northeast-2a"]  # 원하는 가용 영역 선택
#   security_group_ids            = [aws_security_group.PRD-VPC-REDIS-SG.id]  # 기존 보안 그룹 ID 사용
#   subnet_group_name             = aws_elasticache_subnet_group.redis_subnet_group.name

#   replicas_per_node_group = 0  # 복제본 없음 (단일 노드)

#   # 스냅샷 비활성화 (snapshot 설정을 제거하거나 snapshot_retention_limit을 0으로 설정)
#   snapshot_retention_limit = 0  # 스냅샷 저장 비활성화
# }
