module "vpc" {
  source = "./modules/vpc"

  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  cluster_name         = var.cluster_name

}

module "security" {
  source = "./modules/security"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
}

module "eks" {
  source = "./modules/eks"

  project_name            = var.project_name
  environment             = var.environment
  cluster_name            = var.cluster_name
  cluster_version         = var.cluster_version
  vpc_id                  = module.vpc.vpc_id
  private_subnet_ids      = module.vpc.private_subnet_ids
  public_subnet_ids       = module.vpc.public_subnet_ids
  eks_cluster_role_arn    = module.security.eks_cluster_role_arn
  eks_node_group_role_arn = module.security.eks_node_group_role_arn
  eks_cluster_sg_id       = module.security.eks_cluster_sg_id
  eks_nodes_sg_id         = module.security.eks_nodes_sg_id
  node_instance_type      = var.node_instance_type
  node_min_size           = var.node_min_size
  node_max_size           = var.node_max_size
  node_desired_size       = var.node_desired_size

}
