data "aws_kms_key" "kms-key" {
key_id = "d10fea54-118a-4f97-92ea-b22f419a79b5"
}

resource "aws_eks_cluster" "eks" {
  encryption_config {
    resources = ["secrets"]
    provider {
      key_arn = "arn:aws:kms:us-east-1:653187539224:key/d10fea54-118a-4f97-92ea-b22f419a79b5"
    }
  }
  enabled_cluster_log_types = ["api", "authenticator", "audit", "scheduler", "controllerManager"]

  name     = lower("${var.application}-${var.uai}-${lookup(var.tagging_standard, "deployment")}-eks")
  role_arn = aws_iam_role.eks.arn

  vpc_config {
    subnet_ids = var.subnet_ids
    security_group_ids        = [var.security_group]
    endpoint_private_access   = true
    endpoint_public_access    = false
    #public_access_cidrs  = ["165.156.28.64/26","165.156.29.64/26","165.156.40.0/26","165.156.31.64/26","165.156.39.0/26","194.9.245.0/26","165.156.34.0/24","165.156.37.0/24","194.9.244.0/26"] 
  }

  tags = merge(
    var.tagging_standard,
    tomap({"Name" = "${var.application}-${var.uai}-${lookup(var.tagging_standard, "deployment")}-eks"})
  )

  depends_on = [
    aws_iam_role_policy_attachment.eks-cluster-policy,
    aws_iam_role_policy_attachment.eks-vpc-resource-controller-policy,
    data.aws_kms_key.kms-key,
  ]
}

resource "aws_iam_role" "eks" {
  name = lower("${var.application}-${var.uai}-${lookup(var.tagging_standard, "deployment")}-eks-role")

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": ["eks.amazonaws.com","ec2.amazonaws.com"]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role" "eks_node" {
  name = lower("${var.application}-${var.uai}-${lookup(var.tagging_standard, "deployment")}-eks-node")
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "eks-cluster-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks.name
}

resource "aws_iam_role_policy_attachment" "eks-vpc-resource-controller-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks.name
}

resource "aws_iam_role_policy_attachment" "eks-worker-node-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks.name
}

resource "aws_iam_role_policy_attachment" "container-registry-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks.name
}

resource "aws_iam_role_policy_attachment" "eks-cni-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node.name
}

resource "aws_iam_role_policy_attachment" "ec2-container-registry-readonly-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node.name
}

resource "aws_eks_node_group" "eks-node-group" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = lower("${var.application}-${var.uai}-${lookup(var.tagging_standard, "deployment")}-eks-nodegroup")
  node_role_arn   = aws_iam_role.eks.arn
  subnet_ids      = var.subnet_ids
  instance_types  = [var.instance_type]

  scaling_config {
    desired_size = 4
    max_size     = 5
    min_size     = 2
  }

  update_config {
    max_unavailable = 2
  }

  tags = merge(
    var.tagging_standard,
    tomap({"Name" = "${var.application}-${var.uai}-${lookup(var.tagging_standard, "deployment")}-eks-nodegroup"})
  )

  depends_on = [
    aws_iam_role_policy_attachment.eks-worker-node-policy,
    aws_iam_role_policy_attachment.eks-cni-policy,
    aws_iam_role_policy_attachment.ec2-container-registry-readonly-policy,
  ]
}