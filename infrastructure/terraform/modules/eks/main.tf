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

resource "aws_eks_node_group" "mian" {
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

    labels = {
      Environment = var.environment
      nodeGroup = "main"
    }

    tags = {
      Name = "${var.cluster_name}-node-group"
    }

    depends_on = [ aws_eks_cluster.main ]
  
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
