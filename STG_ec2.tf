# Key (ssh-keygen -m PEM -f HF)
#resource "aws_key_pair" "key" {
#  key_name   = "HF"
#  public_key = file("HF.pub")
#}


# Public에 STG-VPC-BASTION-PUB-2A 생성
resource "aws_instance" "STG-VPC-BASTION-PUB-2A" {
  ami                    = coalesce(data.aws_ami.ubuntu.id, var.image_id)
  instance_type          = "t2.micro"
  key_name               = "HF"
  vpc_security_group_ids = [aws_security_group.STG-VPC-BASTION-PUB-SG-2A.id]
  subnet_id              = aws_subnet.STG-VPC-BASTION-PUB-2A.id
  private_ip             = "10.220.1.240"

  tags = {
    Name = "STG-VPC-BASTION-PUB-2A"
  }
}

# Private에 STG-VPC-EFS-PRI-2A 생성
resource "aws_instance" "STG-VPC-EFS-PRI-2A" {
  ami                    = coalesce(data.aws_ami.ubuntu.id, var.image_id)
  instance_type          = "t2.micro"
  key_name               = "HF"
  vpc_security_group_ids = [aws_security_group.STG-VPC-EFS-SG.id]
  subnet_id              = aws_subnet.STG-VPC-PRI-2A.id
  private_ip             = "10.220.2.240"

  tags = {
    Name = "STG-VPC-EFS-PRI-2A"
  }
}

# Private에 STG-VPC-ARGOCD-PRI-2A 생성
resource "aws_instance" "STG-VPC-ARGOCD-PRI-2A" {
  ami                    = coalesce(data.aws_ami.ubuntu.id, var.image_id)
  instance_type          = "t2.micro"
  key_name               = "HF"
  vpc_security_group_ids = [aws_security_group.STG-VPC-PRI-ARGOCD.id]
  subnet_id              = aws_subnet.STG-VPC-PRI-2A.id
  private_ip             = "10.220.2.241"

  tags = {
    Name = "STG-VPC-ARGOCD-PRI-2A"
  }
}

# Private에 STG-VPC-EKS-MANAGED-SERVER-2C 생성
resource "aws_instance" "STG-VPC-EKS-MANAGED-SERVER-2C" {
  ami                    = coalesce(data.aws_ami.ubuntu.id, var.image_id)
  instance_type          = "t2.micro"
  key_name               = "HF"
  vpc_security_group_ids = [aws_security_group.STG-VPC-EKS-MANAGED-PUB-SG-2C.id]
  subnet_id              = aws_subnet.STG-VPC-PRI-2C.id
  private_ip             = "10.220.12.240"

  tags = {
    Name = "STG-VPC-EKS-MANAGED-SERVER-2C"
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
