# EFS 파일 시스템 생성
resource "aws_efs_file_system" "stg-efs" {
  creation_token = "stg-efs-token"
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
  tags = {
    Name = "stg-hf-efs"
  }
}


# VPC 내 모든 서브넷에 EFS 마운트 타겟 생성
resource "aws_efs_mount_target" "stg-efs-target" {
  for_each = {
    "subnet-1" = aws_subnet.STG-VPC-BASTION-PUB-2A.id,
    "subnet-2" = aws_subnet.STG-VPC-BASTION-PUB-2C.id
  }

  file_system_id   = aws_efs_file_system.stg-efs.id
  subnet_id        = each.value
  security_groups  = [aws_security_group.STG-VPC-EFS-SG.id]
}
