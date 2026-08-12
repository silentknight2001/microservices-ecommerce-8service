# general environment 
aws_region = "ap-south-1"
project_name = "ecommerce-devopsify" 
environment = "prod"

# VPC env ............. 
vpc_cidr = "10.0.0.0/16"
availability_zones = ["ap-south-1a", "ap-south-1b"]
public_subnet_cidrs = ["10.2.1.0/24", "10.2.2.0/24"]
private_subnet_cidrs = ["10.2.10.0/24", "10.2.11.0/24"]

#EKS env  ........ 
cluster_name = "ecommerce-eks-prod"
cluster_version = "1.29"
node_instance_type = "t3.large"
node_min_size      = 2
node_max_size      = 5
node_desired_size  = 3