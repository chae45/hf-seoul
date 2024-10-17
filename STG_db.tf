

# DB 서브넷 그룹
resource "aws_db_subnet_group" "stg_db_subnet" {
  name       = "stg-hf-subnetgroup"
  subnet_ids = [aws_subnet.STG-VPC-BASTION-PUB-2A.id, aws_subnet.STG-VPC-BASTION-PUB-2C.id, aws_subnet.STG-VPC-PRI-2A.id, aws_subnet.STG-VPC-PRI-2C.id]

  tags = {
    Name = "stg-hf-subnetgroup"
  }
}



# DB 구성
resource "aws_db_instance" "db-stg" {
  identifier_prefix      = "hf-stg-database"
  allocated_storage      = 10
  engine                 = "mariadb"
  engine_version         = "10.11.8"
  instance_class         = "db.t3.micro"
  db_name                = "stg-test"
  username               = "ham"
  password               = "12341234"
  parameter_group_name   = "default.mariadb10.11"
  skip_final_snapshot    = true
  multi_az               = false
  db_subnet_group_name   = aws_db_subnet_group.stg_db_subnet.name
  vpc_security_group_ids = [aws_security_group.STG-DB-SG.id]

  tags = {
    Name = "hf-stg"
  }
}
