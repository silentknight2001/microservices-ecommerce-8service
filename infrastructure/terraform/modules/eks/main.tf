# eks cluster ....... 
resource "aws_eks_cluster" "main" {
    name = var.cluster_name
    version = var.cluster_version
    role_arn = var.eks_cluster_role_arn

    vpc_config {
      subnet_ids = concat(var.public_subnet_ids, var.private_subnet_ids)
      security_group_ids = [ var.eks_cluster_sg_id ]
      endpoint_private_access = true
      endpoint_public_access = true

    }

    enabled_cluster_log_types = [
        "api",
        "audit",
        "authenticator",
        "controllerManager",
        "scheduler"
    ]
    tags = {
      Name = var.cluster_name
    }
}

# Eks Node Group ........ 

resource "aws_eks_node_group" "main" {
    cluster_name = aws_eks_cluster.main.name 
    node_group_name = "${var.cluster_name}-node-group"
    node_role_arn = var.eks_node_group_role_arn
    subnet_ids = var.private_subnet_ids

    instance_types = [var.node_instance_type]

    scaling_config {
      desired_size = var.node_desired_size
      min_size = var.node_min_size
      max_size = var.node_max_size
    }

    update_config {
      max_unavailable = 1
    }

    launch_template {
      name    = aws_launch_template.eks_nodes.name
      version = aws_launch_template.eks_nodes.latest_version
    }


    labels = {
      Environment = var.environment
      nodeGroup = "main"
    }

    tags = {
      Name = "${var.cluster_name}-node-group"
    }

    depends_on = [ aws_eks_cluster.main ]
  
}

resource "aws_launch_template" "eks_nodes" {
  name = "${var.cluster_name}-node-launch-template"

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${var.cluster_name}-node"
      Environment = var.environment
    }
  }
}

# OIDC provider (for IAm role for service account)... 

data "tls_certificate" "eks" {
    url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

data "aws_eks_cluster_auth" "main" {
  name = aws_eks_cluster.main.name
}

resource "aws_iam_openid_connect_provider" "eks" {

    client_id_list = ["sts:amazonaws.com"]
    thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
    url = aws_eks_cluster.main.identity[0].oidc[0].issuer

    tags = {
      Name = "${var.cluster_name}-oidc"
    }
  
}

#  EBS CSI Driver Addon ......... 
# EBS CSI IAM Role (Pod Identity) ... 

resource "aws_iam_role" "ebs_csi" {
  name = "${var.cluster_name}-ebs-csi-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "pods.eks.amazonaws.com" }
      Action    = [
        "sts:AssumeRole",
        "sts:TagSession"
      ]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ebs_csi" {
  role       = aws_iam_role.ebs_csi.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

resource "aws_eks_addon" "ebs_csi" {
  cluster_name                = aws_eks_cluster.main.name
  addon_name                  = "aws-ebs-csi-driver"
  resolve_conflicts_on_create = "OVERWRITE"
  # NO service_account_role_arn ← Pod Identity handles this

  timeouts {
    create = "30m"
  }

  depends_on = [
    aws_eks_node_group.main,
    aws_eks_addon.pod_identity,
    aws_eks_pod_identity_association.ebs_csi
  ]
}

# modules/eks/main.tf — add to node role
resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = aws_iam_role.eks_node_group.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_eks_addon" "pod_identity" {
  cluster_name                = aws_eks_cluster.main.name
  addon_name                  = "eks-pod-identity-agent"
  resolve_conflicts_on_create = "OVERWRITE"

  depends_on = [aws_eks_node_group.main]
}

resource "aws_eks_pod_identity_association" "ebs_csi" {
  cluster_name    = aws_eks_cluster.main.name
  namespace       = "kube-system"
  service_account = "ebs-csi-controller-sa"
  role_arn        = aws_iam_role.ebs_csi.arn

  depends_on = [aws_eks_addon.pod_identity]
}


#  StorageClass  .......... :)

resource "kubernetes_storage_class" "gp2_csi" {
  metadata {
    name = "gp2-csi"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }

  storage_provisioner    = "ebs.csi.aws.com"
  volume_binding_mode    = "WaitForFirstConsumer"
  allow_volume_expansion = true

  parameters = {
    type      = "gp2"
    encrypted = "true"
  }

  depends_on = [aws_eks_addon.ebs_csi]
}
