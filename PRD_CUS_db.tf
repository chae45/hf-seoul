#파라미터

resource "aws_db_parameter_group" "hf-rds-parameter" {
  name        = "hf-rds-parameter"
  family      = "mariadb10.11"
  description = "Custom Mariadb parameter group with binlog settings"

  # 바이너리 로그 포맷 설정 (ROW 형식 사용)
  parameter {
    name  = "binlog_format"
    value = "ROW"
  }

  parameter {
    name  = "log_bin_trust_function_creators"
    value = "1" # 1로 설정하여 함수 생성 시 binary logging에 대한 요구 사항을 완화합니다.
  }

  # Time zone 설정 (Asia/Seoul)
  parameter {
    name  = "time_zone"
    value = "Asia/Seoul"
  }

  # 클라이언트 문자 집합
  parameter {
    name  = "character_set_client"
    value = "utf8mb4"
  }

  # 연결 문자 집합
  parameter {
    name  = "character_set_connection"
    value = "utf8mb4"
  }

  # 데이터베이스 문자 집합
  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }

  # 결과 문자 집합
  parameter {
    name  = "character_set_results"
    value = "utf8mb4"
  }

  # 기본 문자 집합 설정 (기본값도 utf8mb4로 설정)
  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  # 파일 시스템 문자 집합 설정
  parameter {
    name  = "character_set_filesystem"
    value = "utf8mb4"
  }

  # Collation 설정
  parameter {
    name  = "collation_connection"
    value = "utf8mb4_general_ci"
  }

  # 최대 연결 수 설정
  parameter {
    name  = "max_connections"
    value = "200"
  }
}

# DB 서브넷 그룹
resource "aws_db_subnet_group" "db_subnet" {
  name       = "hf-subnetgroup2"
  subnet_ids = [aws_subnet.PRD-CUS-VPC-BASTION-PUB-2A.id, aws_subnet.PRD-CUS-VPC-BASTION-PUB-2C.id, aws_subnet.PRD-CUS-VPC-PRI-2A.id, aws_subnet.PRD-CUS-VPC-PRI-2C.id]

  tags = {
    Name = "hf-subnetgroup"
  }
}

# DB 구성
resource "aws_db_instance" "db" {
  identifier_prefix      = "hf-database"
  allocated_storage      = 10
  engine                 = "mariadb"
  engine_version         = "10.11.8"
  instance_class         = "db.t3.micro"
  db_name                = "test"
  username               = "ham"
  password               = "12341234"
  parameter_group_name   = "hf-rds-parameter"
  skip_final_snapshot    = true
  multi_az               = false
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name
  vpc_security_group_ids = [aws_security_group.PRD-DB-SG.id]

  backup_retention_period = 7 # 백업 보존 기간 (일 단위), dms 가능 및 R/O DB 생성 위함

  tags = {
    Name = "hf"
  }
}

# 리드 레플리카 RDS 인스턴스
