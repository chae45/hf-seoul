# Key (ssh-keygen -m PEM -f HF)
resource "aws_key_pair" "key" {
  key_name   = "HF"
  public_key = file("HF.pub")
}


# Public에 PRD-CUS-VPC-BASTION-PUB-2A 생성
resource "aws_instance" "PRD-CUS-VPC-BASTION-PUB-2A" {
  ami                    = coalesce(data.aws_ami.ubuntu.id, var.image_id)
  instance_type          = "t2.micro"
  key_name               = "HF"
  vpc_security_group_ids = [aws_security_group.PRD-VPC-BASTION-PUB-SG-2A.id]
  subnet_id              = aws_subnet.PRD-CUS-VPC-BASTION-PUB-2A.id
  private_ip             = "10.250.1.240"

  tags = {
    Name = "PRD-CUS-VPC-BASTION-PUB-2A"
  }
}

# Private에 PRD-CUS-VPC-EFS-PRI-2A 생성
resource "aws_instance" "PRD-CUS-VPC-EFS-PRI-2A" {
  ami                    = coalesce(data.aws_ami.ubuntu.id, var.image_id)
  instance_type          = "t2.micro"
  key_name               = "HF"
  vpc_security_group_ids = [aws_security_group.PRD-VPC-EFS-MANAGED-SG.id]
  subnet_id              = aws_subnet.PRD-CUS-VPC-PRI-2A.id
  private_ip             = "10.250.2.240"

  tags = {
    Name = "PRD-CUS-VPC-EFS-PRI-2A"
  }
}

# Private에 PRD-CUS-VPC-ARGOCD-PRI-2A 생성
resource "aws_instance" "PRD-CUS-VPC-ARGOCD-PRI-2A" {
  ami                    = coalesce(data.aws_ami.ubuntu.id, var.image_id)
  instance_type          = "t2.micro"
  key_name               = "HF"
  vpc_security_group_ids = [aws_security_group.PRD-VPC-PRI-ARGOCD.id]
  subnet_id              = aws_subnet.PRD-CUS-VPC-PRI-2A.id
  private_ip             = "10.250.2.241"

  tags = {
    Name = "PRD-CUS-VPC-ARGOCD-PRI-2A"
  }
}

# Private에 PRD-CUS-VPC-EKS-MANAGED-SERVER-2C 생성
resource "aws_instance" "PRD-CUS-VPC-EKS-MANAGED-SERVER-2C" {
  ami                    = coalesce(data.aws_ami.ubuntu.id, var.image_id)
  instance_type          = "t2.micro"
  key_name               = "HF"
  vpc_security_group_ids = [aws_security_group.PRD-VPC-EKS-MANAGED-PUB-SG-2C.id]
  subnet_id              = aws_subnet.PRD-CUS-VPC-PRI-2C.id
  private_ip             = "10.250.12.240"

  tags = {
    Name = "PRD-CUS-VPC-EKS-MANAGED-SERVER-2C"
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

# Ubuntu 20.04 AMI 검색
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Ubuntu 공식 AWS 계정 ID
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}