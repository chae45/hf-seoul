# bastion security group
resource "aws_security_group" "DEV-VPC-BASTION-PUB-SG-2A" {
  name        = "DEV-VPC-BASTION-PUB-SG-2A"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.DEV-VPC.id # 내가 생성한 VPC

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
    Name = "DEV-VPC-BASTION-PUB-SG-2A"
  }
}

# EKS-MANAGED security group
resource "aws_security_group" "DEV-VPC-MASTER-PRI-SG-2A" {
  name        = "DEV-VPC-MASTER-PRI-SG-2A"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.DEV-VPC.id # 내가 생성한 VPC

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
    Name = "DEV-VPC-MASTER-PRI-SG-2A"
  }
}

# ALB security group
resource "aws_security_group" "DEV-VPC-WORKER-PRI-SG-2A" {
  name        = "DEV-VPC-WORKER-PRI-SG-2A"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.DEV-VPC.id # 내가 생성한 VPC

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
    Name = "DEV-VPC-WORKER-PRI-SG-2A"
  }
}

resource "aws_security_group" "DEV-DB-SG" {
  name_prefix = "DEV-DB-SG"
  description = "Allow db,SSH inbound traffic"
  vpc_id      = aws_vpc.DEV-VPC.id # 내가 생성한 VPC

  ingress {
    description = "mariadb from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
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
    Name = "DEV-DB-SG"
  }
}