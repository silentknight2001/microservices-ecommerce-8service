
output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_ca_certificate" {
  description = "EKS cluster CA certificate"
  value       = aws_eks_cluster.main.certificate_authority[0].data
}

output "cluster_token" {
  description = "EKS cluster authentication token"
  value       = data.aws_eks_cluster_auth.main.token
  sensitive   = true
}

output "cluster_version" {
  description = "EKS cluster Kubernetes version"
  value       = aws_eks_cluster.main.version
}

output "oidc_provider_arn" {
  description = "OIDC provider ARN"
  value       = aws_iam_openid_connect_provider.eks.arn
}

# output "ebs_csi_role_arn" {
#   description = "EBS CSI IAM role ARN"
#   value       = aws_iam_role.ebs_csi.arn
# }

output "alb_controller_policy_arn" {
  description = "ALB controller IAM policy ARN"
  value       = aws_iam_policy.alb_controller.arn
}