# # Worker node role
# resource "aws_iam_role" "Node-Group-Role" {
#   name = "EKSNodeGroupRole"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#       },
#     ]
#   })
# }

# # Cluster Autoscaler를 위한 권한을 노드 그룹 역할에 추가
# resource "aws_iam_role_policy" "eks-autoscaler-policy" {
#   name = "eks-autoscaler-policy"
#   role = aws_iam_role.Node-Group-Role.id

#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Action": [
#         "autoscaling:DescribeAutoScalingGroups",
#         "autoscaling:DescribeAutoScalingInstances",
#         "autoscaling:DescribeLaunchConfigurations",
#         "autoscaling:DescribeTags",
#         "autoscaling:SetDesiredCapacity",
#         "autoscaling:TerminateInstanceInAutoScalingGroup",
#         "ec2:DescribeLaunchTemplateVersions"
#       ],
#       "Resource": "*"
#     }
#   ]
# }
# EOF
# }



# Node Group 생성
resource "aws_eks_node_group" "stg-node-1" {
  cluster_name    = aws_eks_cluster.stg-k8s-cluster.name
  node_group_name = "stg-node-group-1"
  node_role_arn = "arn:aws:iam::992382441622:role/EKSNodeGroupRole"
  stg_subnet_ids      = [aws_subnet.STG-VPC-PRI-2A.id]

  tags = {
    "k8s.io/cluster-autoscaler/enabled"         = "true"
    "k8s.io/cluster-autoscaler/stg-k8s-cluster" = "owned"
  }
  
  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 1
  }

  ami_type       = "AL2_x86_64"
  instance_types = ["t3.medium"]
  #capacity_type  = "ON_DEMAND"
  disk_size = 20

}

# Node Group 생성
resource "aws_eks_node_group" "stg-node-2" {
  cluster_name    = aws_eks_cluster.stg-k8s-cluster.name
  node_group_name = "stg-node-group-2"
  node_role_arn = "arn:aws:iam::992382441622:role/EKSNodeGroupRole"
  stg_subnet_ids      = [aws_subnet.STG-VPC-PRI-2C.id]

  tags = {
    "k8s.io/cluster-autoscaler/enabled"         = "true"
    "k8s.io/cluster-autoscaler/stg-k8s-cluster" = "owned"
  }
  
  scaling_config {
    desired_size = 2
    max_size     = 2 
    min_size     = 1
  }

  ami_type       = "AL2_x86_64"
  instance_types = ["t3.medium"]
  #capacity_type  = "ON_DEMAND"
  disk_size = 20

}



# resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#   role       = aws_iam_role.EKSNodeGroupRole.name
# }

# resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#   role       = aws_iam_role.EKSNodeGroupRole.name
# }

# resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#   role       = aws_iam_role.EKSNodeGroupRole.name
# }
