# bastion security group
resource "aws_security_group" "STG-VPC-BASTION-PUB-SG-2A" {
  name        = "STG-VPC-BASTION-PUB-SG-2A"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.STG-VPC.id # 내가 생성한 VPC

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "STG-VPC-BASTION-PUB-SG-2A"
  }
}

# EKS-MANAGED security group
resource "aws_security_group" "STG-VPC-EKS-MANAGED-PUB-SG-2C" {
  name        = "STG-VPC-EKS-MANAGED-PUB-SG-2C"
  description = "Allow SSH,HTTPS inbound traffic"
  vpc_id      = aws_vpc.STG-VPC.id # 내가 생성한 VPC

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "STG-VPC-EKS-MANAGED-PUB-SG-2C"
  }
}

# ALB security group
resource "aws_security_group" "STG-ALB-SG" {
  name        = "STG-ALB-SG"
  description = "Allow HTTP,HTTPS inbound traffic"
  vpc_id      = aws_vpc.STG-VPC.id # 내가 생성한 VPC

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "STG-ALB-SG"
  }
}

# monitoring security group
/*resource "aws_security_group" "monitoring_security" {
  name        = "monitoring"
  description = "Allow ALL traffic"
  vpc_id      = aws_vpc.vpc.id # 내가 생성한 VPC

  ingress {
    description = "ALL traffic from VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "awesome-monitoring-sg"
  }
} */

resource "aws_security_group" "STG-DB-SG" {
  name_prefix = "STG-DB-SG"
  description = "Allow db inbound traffic"
  vpc_id      = aws_vpc.STG-VPC.id # 내가 생성한 VPC

  ingress {
    description = "mysql from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "STG-DB-SG"
  }
}

resource "aws_security_group" "STG-VPC-REDIS-SG" {
  name_prefix = "STG-VPC-REDIS-SG"
  description = "Allow Redis inbound traffic"
  vpc_id      = aws_vpc.STG-VPC.id # 내가 생성한 VPC

  ingress {
    description = "Redis from VPC"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "STG-VPC-REDIS-SG"
  }
}

resource "aws_security_group" "STG-VPC-EFS-SG" {
  name_prefix = "STG-VPC-EFS-SG"
  description = "Allow EFS inbound traffic"
  vpc_id      = aws_vpc.STG-VPC.id # 내가 생성한 VPC

  ingress {
    description = "EFS from VPC"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "STG-VPC-EFS-SG"
  }
}

resource "aws_security_group" "STG-VPC-PRI-ARGOCD" {
  name_prefix = "STG-VPC-PRI-ARGOCD"
  description = "Allow SSH,HTTP,HTTPS inbound traffic"
  vpc_id      = aws_vpc.STG-VPC.id # 내가 생성한 VPC

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "STG-VPC-EFS-SG"
  }
}