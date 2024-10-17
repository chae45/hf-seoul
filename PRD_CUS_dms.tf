# IAM 역할 생성
resource "aws_iam_role" "dms_vpc_role" {
  name = "dms_vpc_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "dms.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = ""
      }
    ]
  })
}

# IAM 역할에 AmazonDMSVPCManagementRole 정책 연결
resource "aws_iam_role_policy_attachment" "dms_vpc_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonDMSVPCManagementRole"
  role       = aws_iam_role.dms_vpc_role.name
}

# IAM 역할에 AmazonDMSCloudWatchLogsRole 정책 연결
resource "aws_iam_role_policy_attachment" "dms_cloudwatch_logs_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonDMSCloudWatchLogsRole"
  role       = aws_iam_role.dms_vpc_role.name
}

# IAM 정책 생성
resource "aws_iam_policy" "dms_policy" {
  name        = "dms_policy"
  description = "Policy for DMS to manage replication tasks"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dms:CreateReplicationTask",
          "dms:DescribeReplicationInstances",
          "dms:DescribeEndpoints",
          "dms:DescribeReplicationTasks",
          "dms:StartReplicationTask",
          "dms:StopReplicationTask",
          "dms:DeleteReplicationTask",
          "dms:CreateReplicationSubnetGroup",
          "dms:DeleteReplicationSubnetGroup",
          "dms:DescribeReplicationSubnetGroups",
          "dms:ModifyReplicationSubnetGroup"
        ],
        Resource = "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "rds:DescribeDBInstances",
          "rds:ModifyDBInstance",
          "rds:DescribeDBSecurityGroups"
        ],
        "Resource" : "*"
      }
    ]
  })
}

# IAM 역할에 정책 연결
resource "aws_iam_role_policy_attachment" "dms_role_policy_attachment" {
  role       = aws_iam_role.dms_vpc_role.name
  policy_arn = aws_iam_policy.dms_policy.arn

  depends_on = [aws_iam_policy.dms_policy] # 정책이 생성된 후에 역할에 연결
}


# 복제 서브넷 그룹 생성
resource "aws_dms_replication_subnet_group" "hf_replication_subnet_group" {
  replication_subnet_group_id          = "hf-replication-subnet-group" # 알파벳으로 시작
  replication_subnet_group_description = "Subnet group for DMS replication instance"
  subnet_ids = [
    aws_subnet.PRD-CUS-VPC-PRI-2A.id, aws_subnet.PRD-CUS-VPC-PRI-2C.id
  ]

  tags = {
    Name = "hf-replication-subnet-group"
  }

  depends_on = [
    aws_subnet.PRD-CUS-VPC-PRI-2A, aws_subnet.PRD-CUS-VPC-PRI-2C
  ] # 서브넷 리소스에 의존
}

# DMS Replication Instance 생성
resource "aws_dms_replication_instance" "hf_replication_instance" {
  replication_instance_id     = "hf-replication-instance"
  replication_instance_class  = "dms.t3.medium"
  allocated_storage           = 50
  vpc_security_group_ids      = [aws_security_group.PRD-DB-SG.id]
  replication_subnet_group_id = aws_dms_replication_subnet_group.hf_replication_subnet_group.id # 수정
  availability_zone           = "ap-northeast-2a"                                               # 단일 가용 영역으로 설정
  publicly_accessible         = false                                                           # 퍼블릭 액세스 비활성화
  auto_minor_version_upgrade  = false                                                           # 자동 버전 업그레이드 비활성화

  tags = {
    Name = "hf_replication_instance"
  }
}

# 소스 데이터베이스 엔드포인트 생성
resource "aws_dms_endpoint" "hf-source" {
  endpoint_id   = "hf-source-endpoint"
  endpoint_type = "source"
  engine_name   = "mariadb"
  username      = "ham"
  password      = "12341234"
  database_name = "test"
  server_name   = aws_db_instance.db.address # 서버 이름
  port          = 3306
  ssl_mode      = "none" # SSL 모드

  tags = {
    Name = "Source Database Endpoint"
  }
}

# 타겟 데이터베이스 엔드포인트 생성
resource "aws_dms_endpoint" "hf-target" {
  endpoint_id   = "target-endpoint"
  endpoint_type = "target"
  engine_name   = "mariadb"
  username      = "ham"
  password      = "12341234"
  database_name = "test"
  server_name   = aws_db_instance.db.address
  port          = 3306
  ssl_mode      = "none"

  tags = {
    Name = "Target Database Endpoint"
  }
}

# DMS Migration Task 생성
resource "aws_dms_replication_task" "hf-task" {
  replication_task_id      = "hf-task"
  migration_type           = "full-load-and-cdc" # 기존 마이그레이션 복제 및 지속적인 변경사항 복제
  replication_instance_arn = aws_dms_replication_instance.hf_replication_instance.replication_instance_arn
  #source_endpoint_arn       = "arn:aws:dms:${var.region}:${data.aws_caller_identity.current.account_id}:endpoint:${aws_dms_endpoint.hf-source.endpoint_id}"
  #target_endpoint_arn       = "arn:aws:dms:${var.region}:${data.aws_caller_identity.current.account_id}:endpoint:${aws_dms_endpoint.hf-target.endpoint_id}"
  source_endpoint_arn = aws_dms_endpoint.hf-source.endpoint_arn
  target_endpoint_arn = aws_dms_endpoint.hf-target.endpoint_arn
  table_mappings = jsonencode({
    rules = [
      {
        "rule-type"   = "selection",
        "rule-id"     = "1",
        "rule-name"   = "select_all_tables",
        "rule-action" = "include",
        "filters"     = [],
        "object-locator" = {
          "schema-name" = "test", # 소스 스키마 이름
          "table-name"  = "%"     # 모든 테이블을 포함
        }
      }
    ]
  })

  tags = {
    Name = "hf-task"
  }
}
# AWS 계정 정보 가져오기
data "aws_caller_identity" "current" {}
