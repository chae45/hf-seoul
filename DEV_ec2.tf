# Key (ssh-keygen -m PEM -f HF)
resource "aws_key_pair" "key" {
  key_name   = "HF"
  public_key = file("HF.pub")
}

# Public에 DEV-VPC-BASTION-PUB-2A 생성
resource "aws_instance" "DEV-VPC-BASTION-PUB" {
  ami                    = coalesce(data.aws_ami.ubuntu.id, var.image_id)
  instance_type          = "t2.micro"
  key_name               = "HF"
  vpc_security_group_ids = [aws_security_group.DEV-VPC-BASTION-PUB-SG-2A.id]
  subnet_id              = aws_subnet.DEV-VPC-BASTION-PUB-2A.id
  private_ip             = "10.230.1.240"

  tags = {
    Name = "DEV-VPC-BASTION-PUB"
  }
}

# Private에 DEV-VPC-MASTER-PRI 생성
resource "aws_instance" "DEV-VPC-MASTER-PRI" {
  ami                    = coalesce(data.aws_ami.ubuntu.id, var.image_id)
  instance_type          = "t2.micro"
  key_name               = "HF"
  vpc_security_group_ids = [aws_security_group.DEV-VPC-MASTER-PRI-SG-2A.id]
  subnet_id              = aws_subnet.DEV-VPC-PRI-2A.id
  private_ip             = "10.230.2.240"

  tags = {
    Name = "DEV-VPC-MASTER-PRI"
  }
}

# Private에 DEV-VPC-WORKER-PRI 생성
resource "aws_instance" "DEV-VPC-WORKER-PRI" {
  ami                    = coalesce(data.aws_ami.ubuntu.id, var.image_id)
  instance_type          = "t2.micro"
  key_name               = "HF"
  vpc_security_group_ids = [aws_security_group.DEV-VPC-WORKER-PRI-SG-2A.id]
  subnet_id              = aws_subnet.DEV-VPC-PRI-2A.id
  private_ip             = "10.230.2.241"

  tags = {
    Name = "DEV-VPC-WORKER-PRI"
  }
}

# Private에 DEV-VPC-DB-PRI 생성
resource "aws_instance" "DEV-VPC-DB-PRI" {
  ami                    = coalesce(data.aws_ami.ubuntu.id, var.image_id)
  instance_type          = "t2.micro"
  key_name               = "HF"
  vpc_security_group_ids = [aws_security_group.DEV-DB-SG.id]
  subnet_id              = aws_subnet.DEV-VPC-PRI-2A.id
  private_ip             = "10.230.2.242"

  tags = {
    Name = "DEV-VPC-DB-PRI"
  }
}


data "aws_ami" "amzlinux2" {
  most_recent = true
  owners      = ["amazon"]
  name_regex  = "^amzn2-"

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*-gp2"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Ubuntu 22.04 AMI 검색
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Ubuntu 공식 AWS 계정 ID
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}